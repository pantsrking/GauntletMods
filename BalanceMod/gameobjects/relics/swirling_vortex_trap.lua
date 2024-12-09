-- chunkname: @gameobjects/relics/swirling_vortex_trap.lua

local VORTEX_STARTUP_DURATION = 8
local t = {
	lifetime = 7,
	faction = {
		"good",
	},
	motion_info = {
		acceleration = 10000,
		constrained_by_ground = false,
		default_motion_state = "force_based",
		mass = 1000,
		movespeed = 3,
	},
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "swirling_vortex",
				type = "relic_1",
			},
			{
				to = "swirling_vortex_2",
				type = "relic_2",
			},
			{
				to = "swirling_vortex",
				type = "relic_3",
			},
		},
	},
	abilities = {
		swirling_vortex = {
			disable_target_alignment = true,
			duration = 300,
			events = {
				{
					event_start = 0,
					origin_type = "center",
					type = "box",
					unit_path = "relic_twister_windup",
					event_duration = VORTEX_STARTUP_DURATION,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 0.5,
						y = 0.5,
						z = 0.5,
					},
				},
				{
					event_duration = 300,
					origin_type = "center",
					type = "box",
					unit_path = "relic_twister_small",
					event_start = VORTEX_STARTUP_DURATION,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 0.5,
						y = 0.5,
						z = 0.5,
					},
				},
				{
					breaker = true,
					damage_amount = 10,
					event_duration = 360,
					friendly_fire = false,
					hit_react = "swirling_vortex",
					origin_type = "center",
					radius = 2,
					refresh_hitlist_time = 45,
					stagger_origin_modifier = "inverse_direction",
					stagger_origin_type = "query",
					type = "sphere",
					event_start = VORTEX_STARTUP_DURATION,
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

local function spawn(component, unit, context)
	context.state.ready_to_hunt_time = _G.GAME_TIME + VORTEX_STARTUP_DURATION / 15

	local stat_creditor_go_id = Unit.get_data(unit, "stat_creditor_go_id")
	local command = TempTableFactory:get_map("ability_name", "swirling_vortex", "stat_creditor_go_id", stat_creditor_go_id)

	EntityAux.queue_command_master(unit, "ability", "execute_ability", command)
end

local function hunt_enter(component, unit, context)
	EntityAux.queue_command_master(unit, "motion", "set_max_speed", context.settings.motion_info.movespeed)

	context.state.time_to_die = _G.GAME_TIME + context.settings.lifetime / 30
end

local function hunting(component, unit, context, dt)
	local settings = context.settings
	local motion_info = settings.motion_info
	local force = UnitAux.unit_forward(unit) * motion_info.acceleration * motion_info.mass

	EntityAux.queue_command_master(unit, "motion", "add_force", force)
end

local function is_dead(component, unit, context)
	local state = context.state

	return _G.GAME_TIME >= state.time_to_die
end

local function explode(component, unit, context)
	component.entity_spawner:despawn_entity(unit)
end

local function is_ready_to_hunt(component, unit, context)
	return _G.GAME_TIME >= context.state.ready_to_hunt_time
end

t.start_state = "spawn"

t.states = function (component)
	return {
		dummy = StateCommonBuilder.build_skip_state(component, "spawn"),
		spawn = {
			on_enter = {
				closure(spawn, component),
			},
			update = {},
			pre_transitions = {},
			post_transitions = {
				{
					next_state = "hunt",
					action = closure(is_ready_to_hunt, component),
				},
			},
			on_exit = {},
		},
		hunt = {
			on_enter = {
				closure(hunt_enter, component),
			},
			update = {
				closure(hunting, component),
			},
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
