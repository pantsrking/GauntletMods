-- chunkname: @lua/components/soul_leech_component.lua

require("foundation/lua/component/base_component")

SoulLeechComponent = class("SoulLeechComponent", "PeriodicBaseComponent")

local FULL_UPDATES_PER_SECOND = 1
local INCREMENT_PER_KILL = 0.03
local INCREMENT_PER_DRAIN = 0.03
local COST_BASE = 0
local COST_SKELETON = 0.1

SoulLeechComponent.init = function (self, creation_context)
	PeriodicBaseComponent.init(self, "soul_leech", creation_context, false, 1 / FULL_UPDATES_PER_SECOND)
	self.event_delegate:register(self, "on_avatar_exiting_floor")
	self:register_rpc_events("rpc_avatar_killed_something")
end

SoulLeechComponent.setup_master = function (self, unit, context, setup_info)
	local state = context.state

	state.soul_power = 0
	state.soul_counter = 0
	state.souls = {}

	EntityEventModifierManager:register_modifier(unit, "on_hit_dealt", "soulleech", callback(self, "on_hit_dealt"))
	self:register_unit_events(unit, "unit_on_death")
end

SoulLeechComponent.remove_master = function (self, unit, context)
	self:unregister_unit_event(unit, "unit_on_death")
end

SoulLeechComponent.unit_on_death = function (self, unit)
	self:queue_command(unit, self.name, "clear_soul_power")
	self:queue_command(unit, self.name, "disable_soul_leech")
end

local SOUL_TRAVEL_TIME = 0.5

SoulLeechComponent.update_masters = function (self, entities, dt)
	for unit, context in pairs(entities) do
		local state = context.state
		local pos_world = Unit.local_position(unit, 0)

		if state.enable_gui ~= false then
			local dmg_recv = EntityAux.get_component("avatar_damage_receiver")
			local gui = dmg_recv.health_bar_extension.screen_gui
			local world_proxy = WorldManager:get_world_proxy("game_world")
			local viewport = world_proxy:viewport("game_viewport")
			local pos_pixels = viewport:world_to_screen(pos_world)
			local size = Vector3(32, 3, 0)

			pos_pixels = pos_pixels - size / 2
			pos_pixels.y = pos_pixels.y - 25
			pos_pixels.z = 1

			Gui.rect(gui, pos_pixels, size, Color(200, 0, 0, 0))

			local color = Color(255, 100, 200, 250)

			if state.soul_power == 1 then
				color = Color(255, 255, 255, 255)
			end

			size.x = math.max(state.soul_power - 0.5, 0) * 2 * 36
			size.y = 7

			local pos = Vector3(pos_pixels.x - 2, pos_pixels.y - 2, 0)

			Gui.rect(gui, pos, size, color)

			color = Color(255, 140, 180, 255)

			local plateau_soul_power = state.soul_power - state.soul_power % COST_SKELETON
			local range = math.min(plateau_soul_power * 2, 1)

			size.x = range * 32
			size.y = 3

			Gui.rect(gui, pos_pixels, size, color)

			for i = 0, 4 do
				size.x = 1

				Gui.rect(gui, pos_pixels, size, Color(255, 0, 0, 0))

				pos_pixels.x = pos_pixels.x + 6.4
			end
		end

		for i, soul in ipairs(state.souls) do
			soul.lifetime = soul.lifetime - dt

			local lerp_value = 1 - soul.lifetime / SOUL_TRAVEL_TIME
			local origin = Vector3Aux.unbox(soul.origin)
			local position = Vector3.lerp(origin, pos_world, lerp_value)

			position.z = position.z + math.sin(lerp_value * math.pi) * 5

			Unit.set_local_position(soul.unit, 0, position)

			if soul.lifetime <= 0 then
				state.soul_power = math.saturate(state.soul_power + soul.amount)

				self:trigger_rpc_event("flow_event", unit, "on_soulpower_acquired")

				if soul.heal then
					state.soul_counter = state.soul_counter + soul.amount

					print(state.soul_counter)

					if state.soul_counter >= COST_SKELETON then
						state.soul_counter = state.soul_counter % COST_SKELETON

						EntityAux.queue_command_master_interface(unit, "i_damage_receiver", "heal", .67)
					end
				end

				local world = self.world_proxy:get_world()

				World.destroy_unit(world, soul.unit)
				table.remove(state.souls, i)
			end
		end

		if not state.can_summon and state.soul_power >= COST_SKELETON then
			state.can_summon = true

			self:trigger_rpc_event("flow_event", unit, "on_soulpower_afford")
		end

		if not state.souls_maxed and state.soul_power == 1 then
			state.souls_maxed = true

			self:trigger_rpc_event("flow_event", unit, "on_soulpower_max")
		end
	end
end

SoulLeechComponent.command_master = function (self, unit, context, command_name, data)
	local state = context.state

	if command_name == "killed_something" then
		if state.disabled then
			return
		end

		local settings = LuaSettingsManager:get_settings_by_settings_path(data.victim_settings_path)
		local soul_multiplier = settings.soul_multiplier or 1
		local soul_gain = INCREMENT_PER_KILL * soul_multiplier
		local eq_state = EntityAux.state(unit, "equipment")
		local slots = eq_state.slots
		local weapon_settings = LuaSettingsManager:get_settings_by_unit(slots.weapon.unit)

		if state.soul_power < 1 then
			local soul = {}
			local world = self.world_proxy:get_world()
			local position = Vector3Aux.unbox(data.victim_position)

			soul.unit = World.spawn_unit(world, "effects/units/necromagus_soul", position)
			soul.lifetime = SOUL_TRAVEL_TIME
			soul.origin = {}
			soul.amount = soul_gain
			soul.heal = weapon_settings.soul_heal

			Vector3Aux.box(soul.origin, position)
			table.insert(state.souls, soul)
		end
	elseif command_name == "disable_soul_leech" then
		state.disabled = true
	elseif command_name == "drain_soul_power" then
		state.soul_power = math.saturate(state.soul_power + INCREMENT_PER_DRAIN)

		self:trigger_rpc_event("flow_event", unit, "on_soulpower_acquired")
	elseif command_name == "clear_soul_power" then
		state.soul_power = 0
	elseif command_name == "use_soul_power" then
		local ability_settings_path = data
		local soul_power = state.soul_power

		if soul_power >= COST_BASE + COST_SKELETON then
			soul_power = soul_power - COST_BASE

			local nr_skeletons = math.floor(math.min(soul_power, 0.5) / COST_SKELETON)

			if soul_power == 1 then
				EntityAux.queue_command_master(unit, "ability", "execute_ability", TempTableFactory:get_map("ability_name", "summon_superskeleton_5", "settings_path", ability_settings_path))
			else
				local ability_name = "summon_skeleton_" .. tostring(nr_skeletons)

				EntityAux.queue_command_master(unit, "ability", "execute_ability", TempTableFactory:get_map("ability_name", ability_name, "settings_path", ability_settings_path))
			end

			PerkManager:increment(unit, "soul_reaper", nr_skeletons)

			state.soul_power = 0
			state.soul_counter = 0

			self:trigger_rpc_event("flow_event", unit, "on_soulpower_emptied")

			state.can_summon = false
			state.souls_maxed = false
		end
	elseif command_name == "debug_set_soul_power" then
		state.soul_power = math.saturate(data)

		self:trigger_rpc_event("flow_event", unit, "on_soulpower_acquired")
	end
end

SoulLeechComponent.rpc_avatar_killed_something = function (self, sender, player_unit, victim_type, victim_settings_path, ability, position)
	local player_info = PlayerManager:get_player_info_by_player_unit(player_unit)

	if not player_info or not player_info.avatar_unit then
		return
	end

	local avatar_unit = player_info.avatar_unit

	if EntityAux.has_component_master(avatar_unit, self.name) and victim_type == "monster" then
		local victim_position = {}

		Vector3Aux.box(victim_position, position)
		EntityAux.queue_command_master(avatar_unit, self.name, "killed_something", {
			victim_position = victim_position,
			victim_settings_path = victim_settings_path,
		})
	end
end

SoulLeechComponent.on_hit_dealt = function (self, unit, hit, component)
	if EntityAux.has_component_master(unit, self.name) then
		EntityAux.queue_command_master(unit, self.name, "hit_dealt", {
			victim_position = hit.position,
		})
	end
end

SoulLeechComponent.on_avatar_exiting_floor = function (self, avatar_unit, player_go_id)
	if EntityAux.has_component_master(avatar_unit, self.name) then
		EntityAux._state_master_raw(avatar_unit, self.name).enable_gui = false
	end
end

SoulLeechComponent.can_summon_skeletons = function (unit)
	return SoulLeechComponent.get_skeleton_amount(unit) > 0
end

SoulLeechComponent.get_skeleton_amount = function (unit)
	local state = EntityAux.state_master(unit, "soul_leech")
	local soul_power = state.soul_power
	local nr_skeletons = math.floor(math.min(soul_power, 0.5) / COST_SKELETON)

	return nr_skeletons
end

SoulLeechComponent.summon_skeletons = function (ability_component, unit, ability)
	EntityAux.command_immediately(unit, "soul_leech", "use_soul_power", ability.static_ability.settings_path)
end

SoulLeechComponent.setup_console_plugin = function (self)
	local plugin = {
		soul_leech = function (argument_array, command_string)
			if argument_array[2] == "set_soul_power" then
				local soul_power = argument_array[3]
				local target = argument_array[4]

				if soul_power and tonumber(soul_power) then
					local msg = {
						message = sprintf("Soul power set to %t", soul_power),
					}

					msg = PluginComponentAux.execute_command(self, "debug_set_soul_power", tonumber(soul_power) / 100, target) or msg

					return msg
				end

				return {
					error = true,
					message = sprintf("Invalid value for <soul_power>! Must be a number between 0 and 100!"),
				}
			end
		end,
	}
	local auto_complete = {
		soul_leech = {
			"set_soul_power",
		},
	}
	local docs = {
		soul_leech = {
			text = "Manages soul power for lilith.",
			set_soul_power = {
				text = "Sets the soul power, value between 0 and 100",
				usage = "set_soul_power <soul_power>",
			},
		},
	}

	return plugin, auto_complete, docs
end
