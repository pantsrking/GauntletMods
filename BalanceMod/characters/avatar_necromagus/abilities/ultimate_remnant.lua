-- chunkname: @characters/avatar_necromagus/abilities/ultimate_remnant.lua

local TAUNT_DURATION = 0.5
local TAUNT_COMMAND = {
	duration = TAUNT_DURATION,
}
local t = {
	hitpoints = 300,
	lifetime = 450,
	time_before_decay = 4,
	faction = {
		"good",
	},
	scale_info = {
		scale = 1.15,
		variation = 0.05,
	},
	abilities = {
		taunt = {
			mode = "infinite",
			events = {
				{
					damage_amount = 0,
					event_duration = 1,
					event_start = 1,
					hit_react = "poke",
					on_enter_flow = "ability_special_execute",
					origin_type = "center",
					radius = 7,
					refresh_hitlist_time = 10,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_valid_hit = {
						custom_callback = function (event_handler, event, hit)
							local hit_unit = hit.unit

							if EntityAux.has_component_master(hit_unit, "enemy") then
								TAUNT_COMMAND.target_unit = event.caster_unit

								EntityAux.call_master(hit_unit, "enemy", "set_target_unit", TAUNT_COMMAND)
							end
						end,
					},
				},
			},
		},
		explode = {
			duration = 5,
			run_until_death = true,
			events = {
				{
					damage_amount = 50,
					event_duration = 1,
					event_start = 1,
					hit_react = "explosion",
					on_enter_flow = "explode",
					origin_type = "center",
					radius = 6,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
	},
}

t.on_created_by_ability = function (unit, parent_ability)
	local stat_creditor_go_id = AbilityAux.get_stat_creditor_go_id(parent_ability.owner_unit)

	Unit.set_data(unit, "stat_creditor_go_id", stat_creditor_go_id)
end

t.on_death_authorative = function (unit, is_local_hit, hit, component)
	if EntityAux.owned(unit) then
		EntityAux.queue_command_master(unit, "ability", "interrupt", true)

		local stat_creditor_go_id = Unit.get_data(unit, "stat_creditor_go_id")

		EntityAux.queue_command_master(unit, "ability", "execute_ability", TempTableFactory:get_map("ability_name", "explode", "stat_creditor_go_id", stat_creditor_go_id))
	end
end

local function active_enter(component, unit, context)
	local owner = Unit.get_data(unit, "owner_unit")
	local command = TempTableFactory:get_map("ability_name", "taunt", "ability_event_listeners", nil, "owner_unit", owner)

	EntityAux.queue_command_master(unit, "ability", "execute_ability", command)

	context.state.time_to_die = _G.GAME_TIME + context.settings.lifetime / 30
end

local function is_dead(component, unit, context)
	local state = context.state
	local ttd = state.time_to_die
	local gt = _G.GAME_TIME

	return _G.GAME_TIME >= state.time_to_die
end

local function explode(component, unit, context)
	EntityAux.call_master_interface(unit, "i_damage_receiver", "deathplane")
end

t.start_state = "setup"

t.states = function (component)
	return {
		setup = StateCommonBuilder.build_skip_state(component, "hunt"),
		hunt = {
			on_enter = {
				closure(active_enter, component),
			},
			update = {},
			pre_transitions = {
				{
					next_state = "dead",
					action = closure(is_dead, component),
				},
			},
			post_transitions = {},
			on_exit = {},
		},
		dead = {
			on_enter = {
				closure(explode, component),
			},
			update = {},
			post_transitions = {},
			on_exit = {},
		},
	}
end

return t
