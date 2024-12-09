-- chunkname: @gameobjects/relics/golden_feather_turkey.lua

local DURATION = 12
local t = {
	golden_feather_unit = "turkey_gold",
	health_boost = 28,
	ignore_autoaim = true,
	interact_on_contact = true,
	interactable_broadphase_move = true,
	interactable_enable_delay = 0.75,
	stat_type = "food",
	faction = {
		"good",
	},
	lifetime = DURATION * 30,
	motion_info = {
		movespeed = 3,
	},
}

t.interactor_can_interact = function (component, interactor, interactable)
	return true
end

t.interactor_predict_result = function (component, interactor, interactable, can_interact)
	if not can_interact then
		return
	end

	EntityAux.queue_command_master(interactor, "interactor", "add_ignore_interactable", interactable)
	Unit.set_unit_visibility(interactable, false)
	Unit.set_flow_variable(interactable, "interactor", interactor)
	Unit.flow_event(interactable, "on_interact")
end

t.interactable_allow_interact = function (component, interactable, interactor)
	return true
end

t.interactable_interact_result = function (component, interactable, interactor, success)
	if not success then
		return
	end

	if EntityAux.owned(interactable) then
		component.entity_spawner:despawn_entity(interactable)
	end

	if not EntityAux.owned(interactor) then
		Unit.set_unit_visibility(interactable, false)
		Unit.set_flow_variable(interactable, "interactor", interactor)
		Unit.flow_event(interactable, "on_interact")
	end
end

t.interactor_interact_result = function (component, interactor, interactable)
	local settings = LuaSettingsManager:get_settings_by_unit(interactable)

	EntityAux.queue_command_master_interface(interactor, "i_damage_receiver", "heal", settings.health_boost)
	component:trigger_event("on_food_consumed", interactor, settings.health_boost)
end

local function spawn(component, unit, context)
	EntityAux.queue_command_master(unit, "motion", "constrain_to_ground", true)
	EntityAux.queue_command_master(unit, "motion", "constrain_to_mover", true)
	EntityAux.queue_command_master(unit, "motion", "constrain_to_navgrid", true)

	context.state.ready_to_flee_time = _G.GAME_TIME + 0
end

local function hunt_enter(component, unit, context)
	context.state.time_to_die = _G.GAME_TIME + context.settings.lifetime / 30
end

local function fleeing(component, unit, context, dt)
	local state = context.state

	state.refresh_target_timer = (state.refresh_target_timer or 10) - dt

	if not Unit.alive(state.target_unit) or state.refresh_target_timer <= 0 then
		state.refresh_target_timer = 2
		state.target_unit = StateAux.get_closest_alive_target(component, unit, context, 30, true)
	end

	local wanted_velocity
	local settings = context.settings
	local motion_info = settings.motion_info

	if Unit.alive(state.target_unit) then
		local to_target = Unit.world_position(state.target_unit, 0) - Unit.local_position(unit, 0)

		to_target.z = 0

		local wanted_direction = Vector3.normalize(-to_target)

		wanted_velocity = wanted_direction * motion_info.movespeed
		wanted_velocity.z = -5

		local directionbox = {}

		Vector3Aux.box(directionbox, wanted_direction)
		EntityAux.queue_command_master(unit, "rotation", "rotate_towards", directionbox)
	else
		wanted_velocity = UnitAux.unit_forward(unit) * motion_info.movespeed
	end

	EntityAux.call_master(unit, "motion", "wanted_velocity", wanted_velocity)
end

local function is_dead(component, unit, context)
	local state = context.state

	return _G.GAME_TIME >= state.time_to_die
end

local function explode(component, unit, context)
	component.entity_spawner:despawn_entity(unit)
end

local function is_ready_to_flee(component, unit, context)
	return _G.GAME_TIME >= context.state.ready_to_flee_time
end

t.start_state = "spawn"

t.states = function (component)
	return {
		spawn = {
			on_enter = {
				closure(spawn, component),
			},
			update = {},
			pre_transitions = {},
			post_transitions = {
				{
					next_state = "flee",
					action = closure(is_ready_to_flee, component),
				},
			},
			on_exit = {},
		},
		flee = {
			on_enter = {
				closure(hunt_enter, component),
			},
			update = {
				closure(fleeing, component),
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
