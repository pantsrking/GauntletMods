-- chunkname: @characters/illusion_wizard/illusion_wizard.lua

local t = SettingsAux.override_settings("characters/avatar_wizard/wizard", {
	always_full_update_ai = true,
	avatar_type = "illusion_wizard",
	disable_health_bar = true,
	global_ability_cooldown = 0.3,
	hitpoints = 1,
	preferred_distance_max = 10,
	preferred_distance_min = 3,
	refresh_target_time = 0.75,
	shadow_blob = "nil",
	use_simple_mover = false,
	weapon_path = "characters/illusion_wizard/wep_book_illusion",
	rotationspeed = 5 * math.tau,
	rotation_info = {
		idle = {
			{
				angle_limit = 45,
				rotation_speed = 5 * math.tau,
			},
			{
				snap_rotation = true,
				rotation_speed = 10 * math.tau,
			},
		},
		move = {
			{
				angle_limit = 45,
				rotation_speed = 5 * math.tau,
			},
			{
				snap_rotation = true,
				rotation_speed = 10 * math.tau,
			},
		},
	},
	resistances = {
		all = "immune",
	},
	move_settings = {
		max_state_duration = 1,
		max_state_variation = 0,
		min_state_duration = 0.2,
		min_state_variation = 0,
	},
	motion_info = {
		constrained_by_ground = true,
	},
	ability_selection = {
		chain_lightning = {
			cooldown = 0,
			custom = true,
			max_distance = 15,
			min_distance = 0,
			weight = 1,
		},
		fire_bolt = {
			cooldown = 0,
			custom = true,
			max_distance = 15,
			min_distance = 0,
			weight = 2,
		},
		fireball = {
			cooldown = .6,
			custom = true,
			max_distance = 15,
			min_distance = 0,
			weight = 1,
		}
	},
})

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
				closure(StateCommon.move_towards_target_advanced, component),
				closure(StateCommonCharacter.update_move_speed, component),
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
			on_enter = {},
			update = {
				closure(StateCommon.select_target_player, component),
				closure(StateCommonIllusion.rotate_aim, component),
				closure(StateCommonIllusion.update_combo, component),
			},
			pre_transitions = {},
			post_transitions = {
				{
					next_state = "select_action",
					action = closure(StateCommon.has_lost_target, component),
				},
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
				closure(StateCommonIllusion.attack_exit_ranged, component),
			},
		},
	}, cache_component_states
end

return t
