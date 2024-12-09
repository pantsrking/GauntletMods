-- chunkname: @equipment/valkyrie/weapon03.lua

local SWEEP_DAMAGE = 50
local SWEEP_RADIUS = 4.5

return SettingsAux.override_settings("equipment/valkyrie/weapon01", {
	combo = {
		abilities = {
			defense = true,
			heavy = true,
			light = true,
			melee_blocked = true,
			special = true,
		},
		combo_transitions = {
			{
				to = "sword1",
				type = "light",
			},
			{
				to = "rocket_girl_from_idle",
				type = "heavy",
			},
			{
				to = "crescent_sweep",
				type = "special",
			},
			{
				to = "shield_bash",
				type = "melee_blocked",
			},
		},
	},
	abilities = {
		crescent_sweep = {
			disable_target_alignment = false,
			duration = 35,
			enemy_collisions = "disable",
			inherit_from = "default_data",
			override_mover_filter = "level_bound_mover",
			set_motion_max_step_down = 20,
			cooldown = {
				duration = 180,
				time = 5,
			},
			ui_info = {
				material = "valkyrie_action_crescentsweep",
				type = "special",
			},
			animation_events = {
				{
					event_name = "shield_bash_01",
					time = 0,
				},
				{
					event_name = "special_spin_windup",
					time = 12,
				},
			},
			target_alignment = {
				keyboard = {
					max_angle = 1,
					radius = 1,
				},
				pad = {
					max_angle = 15,
					radius = 8,
				},
			},
			flow_events = {
				{
					event_name = "ability_special_windup",
					time = 1,
				},
			},
			on_exit = {
				flow_event = "ability_special_exit",
			},
			events = {
				{
					behind_wall_test = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_amount = 0,
					damage_type = "spear",
					effect_type = "spear",
					event_duration = 8,
					event_start = 5,
					hit_react = "thrust_heavy",
					stagger_origin_type = "character",
					type = "sphere",
					origin = {
						y = 0,
						z = 0,
						x = -0,
					},
					radius = SWEEP_RADIUS,
				},
				{
					behind_wall_test = true,
					break_food = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_hit_delay = 3,
					damage_type = "spear",
					effect_type = "spear",
					event_duration = 8,
					event_start = 17,
					execute = true,
					hit_react = "slash_heavy_left",
					on_enter_flow = "ability_special_execute",
					stagger_origin_type = "character",
					type = "sphere",
					damage_amount = SWEEP_DAMAGE,
					origin = {
						y = 0,
						z = 0,
						x = -0,
					},
					radius = SWEEP_RADIUS,
				},
			},
			invincibilities = {
				{
					window = {
						0,
						20,
					},
				},
			},
			buffer_to = {
				heavy = 24,
				light = 19,
			},
			cancel_to = {
				defense = 21,
				heavy = 21,
				interact = 21,
				light = 21,
				navigation = 21,
			},
			combo_transitions = {
				{
					to = "sword1",
					type = "light",
				},
				{
					to = "rocket_girl_from_idle",
					type = "heavy",
				},
				{
					type = "defense",
				},
			},
		},
	},
})
