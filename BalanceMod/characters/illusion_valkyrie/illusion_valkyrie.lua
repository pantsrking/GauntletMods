-- chunkname: @characters/illusion_valkyrie/illusion_valkyrie.lua

local LIFETIME = 10
local t = SettingsAux.override_settings("characters/avatar_valkyrie/valkyrie", {
	always_full_update_ai = true,
	avatar_type = "illusion_valkyrie",
	disable_health_bar = true,
	fixed_prediction_rotation_speed = "nil",
	global_ability_cooldown = 0.1,
	hitpoints = 1,
	refresh_target_time = 0.75,
	shadow_blob = "nil",
	use_simple_mover = false,
	weapon_path = "characters/illusion_valkyrie/wep_spear_illusion",
	resistances = {
		all = "immune",
	},
	rotationspeed = 10 * math.tau,
	motion_info = {
		constrained_by_ground = true,
	},
	ability_selection = {
		light = {
			cooldown = 0.3,
			max_distance = 4,
			min_distance = 0,
			weight = 5,
		},
		heavy = {
			cooldown = 7,
			max_distance = 6,
			min_distance = 2,
			weight = 2,
		},
	},
})

t.on_entity_registered = function (unit)
	if EntityAux.owned(unit) then
		local time_in_seconds = LIFETIME - 1 + math.random() * 2

		Game.scheduler:delay_action(time_in_seconds, function ()
			if Unit.alive(unit) then
				local entity_spawner = FlowCallbacks.state_game.entity_spawner

				entity_spawner:despawn_entity(unit)
			end
		end)
	end
end

t.on_created_by_ability = function (unit, parent_ability)
	if EntityAux.owned(unit) then
		local owner = parent_ability.owner_unit

		Unit.set_data(unit, "owner_unit", owner)
	end
end

t.states = function (component)
	local cache_component_states = closure(StateCommon.cache_component_states, component)

	return {
		setup = StateCommonBuilder.build_skip_state(component, t.start_state),
		spawn = StateCommonBuilder.build_spawn_state(component, function ()
			return
		end),
		idle = {
			on_enter = {
				closure(StateCommonIllusion.idle_enter, component),
			},
			update = {
				closure(StateCommon.select_target_player, component),
			},
			pre_transitions = {},
			post_transitions = {
				{
					next_state = "battle",
					action = closure(StateCommonIllusion.target_acquired, component),
				},
			},
			on_exit = {},
		},
		select_action = {
			on_enter = {},
			update = {},
			pre_transitions = {},
			post_transitions = {
				{
					next_state = "idle",
					action = closure(StateCommonIllusion.target_lost, component),
				},
				{
					next_state = "battle",
					action = function ()
						return true
					end,
				},
			},
			on_exit = {},
		},
		battle = {
			on_enter = {
				closure(StateCommonIllusion.battle_enter, component),
			},
			update = {
				closure(StateCommon.select_target_player, component),
				closure(StateCommon.move_towards_target, component),
			},
			pre_transitions = {},
			post_transitions = {
				{
					action = closure(StateCommon.has_lost_target, component),
				},
				{
					next_state = "attack",
					action = closure(StateCommonIllusion.select_random_ability, component),
				},
			},
			on_exit = {
				closure(StateCommon.move_towards_target_exit, component),
			},
		},
		attack = {
			on_enter = {
				closure(StateCommonIllusion.attack_enter, component),
			},
			update = {
				closure(StateCommon.select_target_player, component),
				closure(StateCommonIllusion.update_combo, component),
			},
			pre_transitions = {},
			post_transitions = {
				{
					next_state = "attack",
					action = closure(StateCommonIllusion.select_random_ability, component),
				},
				{
					next_state = "select_action",
					action = closure(StateCommonCharacter.attack_should_exit, component),
				},
			},
			on_exit = {
				closure(StateCommonIllusion.attack_exit, component),
			},
		},
	}, cache_component_states
end

return t
