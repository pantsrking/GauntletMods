-- chunkname: @characters/avatar_necromagus_summoned_ghost/necromagus_summoned_ghost.lua

local LIFETIME = 100
local DAMAGE = 22
local t = SettingsAux.override_settings("characters/ghost_enemy_base", {
	always_full_update_ai = true,
	bloodtype = "ethereal",
	default_mover_collision_filter = "enemy_mover_no_player",
	discovery_disabled = true,
	enemy_type = "ghost",
	hitpoints = 1,
	migrated_state = "hunt",
	movespeed = 15,
	name = "loc_enemy_ghost",
	refresh_target_time = 0.25,
	stopping_power = 0.25,
	use_simple_mover = false,
	faction = {
		"good",
	},
	spawn_info = {
		default = {
			animation = "awaken",
			duration = 10,
			invincibility_duration = 7.5,
			wakeup_delay = 0,
		},
		reanimated = {
			animation = "reanimate",
			duration = 30,
		},
	},
	animation_variables = {
		"move_speed",
	},
	motion_info = {
		acceleration = 23,
		default_motion_state = "force_based",
		mass = 10,
		movespeed_max = 15,
		movespeed_min = 15,
	},
	abilities = {
		idle = {
			mode = "infinite",
			events = {
				{
					collision_filter = "damageable_only",
					event_duration = 1,
					event_start = 0,
					hit_react = "thrust_heavy",
					set_no_faction_as_ally = true,
					type = "box",
					damage_amount = DAMAGE,
					origin = {
						x = 0,
						y = -0.9,
						z = 0,
					},
					half_extents = {
						x = 0.5,
						y = 0.7,
						z = 0.5,
					},
				},
			},
		},
	},
})

t.on_created_by_ability = function (unit, parent_ability)
	if EntityAux.owned(unit) then
		local stat_creditor_go_id = AbilityAux.get_stat_creditor_go_id(parent_ability.owner_unit)

		Unit.set_data(unit, "stat_creditor_go_id", stat_creditor_go_id)
	end
end

t.on_entity_registered = function (unit)
	if EntityAux.owned(unit) then
		local command = TempTableFactory:get_map("ability_name", "spawn", "ability_event_listeners", nil)

		EntityAux.queue_command_master(unit, "ability", "execute_ability", command)

		local time_in_seconds = LIFETIME - 1 + math.random() * 2

		Game.scheduler:delay_action(time_in_seconds, function ()
			if Unit.alive(unit) then
				EntityAux.call_interface(unit, "i_hit_receiver", "hit", {
					damage_amount = 99999,
					settings = {
						hit_react = "push",
					},
					modifiers = {},
					direction = Vector3Aux.box_temp(-UnitAux.unit_forward(unit)),
					position = Vector3Aux.box_temp(Unit.world_position(unit, 0)),
					random_seed = math.random() * 1000,
				})
			end
		end)
	end
end

t.on_death_authorative = function (unit, is_local_hit, hit, component)
	component:trigger_rpc_event("rpc_destroy_ghost", unit, "death_fx")
end

t.on_hit = function (unit, hit, component)
	local victim = hit.unit
	local victim_settings = LuaSettingsManager:get_settings_by_unit(victim)

	if victim_settings and not FactionComponent.are_allies_unit(unit, victim) then
		EntityEventModifierManager:unregister_modifier(unit, "on_hit_dealt", "ghost")
		component:trigger_rpc_event("flow_event", unit, "attack_fx")
		component:trigger_rpc_event("rpc_destroy_ghost", unit, "death_fx")
	end
end

t.on_entity_registered = function (unit)
	EntityEventModifierManager:register_modifier(unit, "on_hit_dealt", "ghost", t.on_hit)
end

t.on_created_by_ability = function (unit, parent_ability)
	if EntityAux.owned(unit) then
		local stat_creditor_go_id = AbilityAux.get_stat_creditor_go_id(parent_ability.owner_unit)
		local command = {
			ability_name = "idle",
			stat_creditor_go_id = stat_creditor_go_id,
		}

		EntityAux.queue_command_master(unit, "ability", "execute_ability", command)
	end
end

t.states = function (component)
	local cache_component_states = closure(StateGhost.cache_component_states, component)

	return {
		setup = StateCommonBuilder.build_skip_state(component, t.start_state),
		spawn = StateCommonBuilder.build_spawn_state(component, function ()
			return
		end),
		select_action = StateCommonBuilder.build_skip_state(component, "hunt"),
		roaming = StateCommonBuilder.build_skip_state(component, "hunt"),
		idle = StateCommonBuilder.build_skip_state(component, "hunt"),
		hunt = {
			on_enter = {},
			update = {
				closure(StateGhost.select_target, component),
				closure(StateGhost.move_towards_target, component),
			},
			post_transitions = {},
			on_exit = {},
		},
	}, cache_component_states
end

return t
