-- chunkname: @equipment/warrior/weapon01.lua

local DAMAGE_LIGHT = 10
local DAMAGE_LIGHT_COMBO_1 = 30
local DAMAGE_LIGHT_COMBO_2 = 30
local DAMAGE_SPIN = 5
local DAMAGE_SPIN_FINISH = 5
local DAMAGE_SMASH = 35
local SPIN_DURATION = 75
local DAMAGE_RUSH = 5
local t = {
	item_type = "weapon",
	combo = {
		abilities = {
			custom = true,
			heavy = true,
			light = true,
			rush = true,
			rush_aim = true,
			special = true,
		},
		combo_transitions = {
			{
				to = "light1",
				type = "light",
			},
			{
				to = "smash_windup",
				type = "heavy",
			},
			{
				to = "spin",
				type = "special",
			},
			{
				to = "rush_aim",
				type = "rush_aim",
			},
			{
				to = "rush",
				type = "rush",
			},
			{
				type = "custom",
			},
		},
	},
	abilities = {
		default_data = {
			ability_data = true,
			combo_transitions = {
				{
					to = "light1",
					type = "light",
				},
				{
					to = "smash_windup",
					type = "heavy",
				},
				{
					to = "spin",
					type = "special",
				},
				{
					to = "rush_aim",
					type = "rush_aim",
				},
			},
		},
		default_event_data = {
			behind_wall_test = true,
			damage_type = "slash",
			effect_type = "axe",
			event_data = true,
			event_duration = 1,
			event_start = 5,
			stagger_origin_type = "character",
			type = "box_sweep",
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			half_extents = {
				x = 1.4,
				y = 0.9,
				z = 0.5,
			},
		},
		light_template = {
			disable_target_alignment = true,
			duration = 70,
			inherit_from = "default_data",
			events = {
				{
					break_food = true,
					collision_filter = "damageable_and_wall",
					event_duration = 2,
					event_start = 9,
					inherit_from = "default_event_data",
					damage_amount = DAMAGE_LIGHT,
				},
			},
			buffer_to = {
				heavy = 8,
				light = 8,
			},
			cancel_to = {
				heavy = 12,
				interact = 12,
				light = 12,
				navigation = 14,
				rush_aim = 1,
			},
			movements = {
				{
					translation = 0.8,
					window = {
						6,
						8,
					},
				},
			},
		},
		light1 = {
			animation = "attack_light1",
			inherit_from = "light_template",
			events = {
				{
					hit_react = "slash_left",
				},
			},
			combo_transitions = {
				{
					to = "light2",
					type = "light",
				},
			},
		},
		light2 = {
			animation = "attack_light2",
			inherit_from = "light_template",
			events = {
				{
					hit_react = "slash_right",
				},
			},
			combo_transitions = {
				{
					to = "light3",
					type = "light",
				},
			},
		},
		light3 = {
			inherit_from = "light1",
			combo_transitions = {
				{
					to = "light4",
					type = "light",
				},
			},
		},
		light4 = {
			animation = "attack_light_sweep",
			inherit_from = "light2",
			flow_events = {
				{
					event_name = "ability_light_sweep",
					time = 9,
				},
			},
			events = {
				{
					event_duration = 4,
					hit_react = "slash_heavy_left",
					origin_type = "center",
					damage_amount = DAMAGE_LIGHT_COMBO_1,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 1.6,
						y = 1.1,
						z = 0.5,
					},
				},
			},
			movements = {},
			cancel_to = {
				heavy = 13,
				interact = 14,
				light = 13,
				navigation = 14,
				rush_aim = 0,
			},
			combo_transitions = {
				{
					to = "light5",
					type = "light",
				},
			},
		},
		light5 = {
			inherit_from = "light2",
			combo_transitions = {
				{
					to = "light6",
					type = "light",
				},
			},
		},
		light6 = {
			inherit_from = "light1",
			combo_transitions = {
				{
					to = "light7",
					type = "light",
				},
			},
		},
		light7 = {
			animation = "attack_light_finish",
			duration = 61,
			inherit_from = "light4",
			flow_events = {
				{
					event_name = "ability_light_finish",
					time = 9,
				},
			},
			events = {
				{
					event_duration = 4,
					hit_react = "slash_heavy_right",
					origin_type = "center",
					radius = 2.3,
					type = "sphere",
					damage_amount = DAMAGE_LIGHT_COMBO_2,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
			cancel_to = {
				heavy = 19,
				interact = 19,
				light = 19,
				navigation = 19,
				rush_aim = 0,
			},
			movements = {},
			combo_transitions = {
				{
					to = "light1",
					type = "light",
				},
			},
		},
		light8 = {
			animation = "attack_light_finish_smash",
			duration = 69,
			inherit_from = "light_template",
			flow_events = {
				{
					event_name = "ability_light_finish_smash",
					time = 23,
				},
			},
			events = {
				{
					behind_wall_test = true,
					breaker = true,
					damage_amount = 128,
					damage_hit_delay = 3,
					damage_type = "fire",
					event_duration = 2,
					event_start = 23,
					hit_react = "explosion",
					ignore_rotation = true,
					origin_type = "center",
					radius = 4.5,
					stagger_origin_type = "query",
					type = "sphere",
					faction = {
						"good",
					},
					origin = {
						x = 0,
						y = 0,
						z = 0.8,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						23,
					},
				},
			},
			cancel_to = {
				heavy = 13,
				interact = 14,
				light = 35,
				navigation = 14,
				rush_aim = 0,
			},
			movements = {
				{
					translation = 0.8,
					window = {
						7,
						15,
					},
				},
			},
			combo_transitions = {
				{
					to = "light1",
					type = "light",
				},
			},
		},
		smash_windup = {
			animation = "smash_windup",
			duration = 4,
			target_alignment = {
				keyboard = {
					max_angle = 1,
					radius = 1,
				},
				pad = {
					max_angle = 15,
					radius = 6,
				},
			},
			movements = {
				{
					translation = 0.5,
					type = "slide",
					window = {
						0,
						6,
					},
				},
			},
			cancel_to = {
				light_released = 0,
			},
			combo_transitions = {
				{
					to = "smash",
					type = "end",
				},
				{
					to = "spin",
					type = "special",
				},
			},
		},
		smash = {
			animation = "attack_heavy1",
			duration = 41,
			ignore_aim_direction = true,
			inherit_from = "default_data",
			target_alignment = {
				keyboard = {
					max_angle = 1,
					radius = 1,
				},
				pad = {
					max_angle = 15,
					radius = 6,
				},
			},
			events = {
				{
					collision_filter = "damageable_and_wall",
					damage_amount = 0,
					damage_type = "punch",
					event_duration = 10,
					event_start = 0,
					hit_react = "thrust",
					inherit_from = "default_event_data",
					tick_frequency = 60,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 0.4,
						y = 0.55,
						z = 0.5,
					},
				},
				{
					break_food = true,
					damage_type = "cleave",
					event_duration = 1,
					event_start = 16,
					execute = true,
					hit_react = "smash",
					inherit_from = "default_event_data",
					damage_amount = DAMAGE_SMASH,
					origin = {
						x = 0,
						y = -0.5,
						z = 0,
					},
					half_extents = {
						x = 0.25,
						y = 1.2,
						z = 0.5,
					},
				},
				{
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_amount = 0,
					damage_type = "punch",
					event_duration = 1,
					event_start = 16,
					hit_react = "thrust_heavy",
					inherit_from = "default_event_data",
					origin = {
						x = 0,
						y = -0.5,
						z = 0,
					},
					half_extents = {
						x = 1,
						y = 1.2,
						z = 0.5,
					},
				},
			},
			buffer_to = {
				heavy = 17,
				light = 13,
			},
			cancel_to = {
				heavy = 20,
				interact = 20,
				light = 19,
				navigation = 20,
				rush_aim = 19,
			},
			hero_invincibilities = {
				{
					type = "projectile",
					value = true,
					window = {
						0,
						20,
					},
				},
			},
			movements = {
				{
					translation = 0.2,
					window = {
						1,
						3,
					},
				},
				{
					translation = 1.2,
					window = {
						3,
						16,
					},
				},
			},
		},
		spin = {
			animation = "attack_whirlwind_light",
			disable_target_alignment = true,
			enemy_collisions = "disable",
			inherit_from = "default_data",
			override_mover_filter = "level_bound_mover",
			duration = SPIN_DURATION,
			override_movespeed = {
				speed = 2,
				rotation_speed = 0.1 * math.pi,
			},
			cooldown = {
				duration = 300,
				time = 3,
			},
			on_enter = {
				flow_event = "ability_special_windup",
			},
			on_exit = {
				flow_event = "ability_special_exit",
			},
			on_cooldowned = {
				timpani_event = "warrior_ability_cooldown",
			},
			ui_info = {
				material = "warrior_action_spin",
				type = "special",
			},
			events = {
				{
					behind_wall_test = true,
					break_food = true,
					collision_filter = "damageable_only",
					damage_type = "slash",
					effect_type = "axe",
					event_start = 0,
					hit_react = "whirlwind",
					radius = 2.2,
					refresh_hitlist_time = 3,
					type = "sphere",
					event_duration = SPIN_DURATION,
					damage_amount = DAMAGE_SPIN,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						SPIN_DURATION + 10,
					},
				},
			},
			movements = {
				{
					translation = 8,
					window = {
						0,
						SPIN_DURATION,
					},
				},
			},
			combo_transitions = {
				{
					to = "spin_recovery",
					type = "end",
				},
			},
		},
		spin_recovery = {
			animation = "whirlwind_light_exit",
			combo_end = 43,
			disable_target_alignment = true,
			duration = 43,
			ignore_aim_direction = true,
			inherit_from = "default_data",
			override_movespeed = {
				duration = 11,
				speed = 1,
				rotation_speed = 0.1 * math.pi,
			},
			events = {
				{
					behind_wall_test = true,
					break_food = true,
					collision_filter = "damageable_only",
					damage_type = "slash",
					effect_type = "axe",
					event_duration = 1,
					event_start = 0,
					hit_react = "thrust_heavy",
					radius = 3,
					type = "sphere",
					damage_amount = DAMAGE_SPIN_FINISH,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						6,
					},
				},
			},
			buffer_to = {
				heavy = 0,
				light = 0,
				special = 0,
			},
			cancel_to = {
				heavy = 12,
				interact = 13,
				light = 12,
				navigation = 13,
				rush_aim = 12,
				special = 12,
			},
			movements = {
				{
					translation = 2,
					type = "slide",
					window = {
						0,
						10,
					},
				},
			},
		},
		rush_aim = {
			animation = "slam",
			disable_target_alignment = true,
			mode = "infinite",
			on_enter = {
				flow_event = "ability_rush_windup",
			},
		},
		rush = {
			combo_end = 20,
			disable_target_alignment = true,
			duration = 20,
			enemy_collisions = "disable",
			ignore_aim_direction = true,
			ignore_shock = true,
			inherit_from = "default_data",
			override_mover_filter = "level_bound_mover",
			on_enter = {
				flow_event = "ability_rush_go",
			},
			on_exit = {
				flow_event = "ability_rush_stop",
			},
			events = {
				{
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_type = "punch",
					event_duration = 20,
					event_start = 0,
					hit_react = "tackle",
					on_enter_flow = "rush_start",
					on_exit_flow = "rush_stop",
					perk = "furious_charge",
					tick_frequency = 30,
					type = "box_sweep",
					damage_amount = DAMAGE_RUSH,
					origin = {
						x = 0,
						y = 0.1,
						z = 0,
					},
					half_extents = {
						x = 0.35,
						y = 0.75,
						z = 0.5,
					},
				},
			},
			movements = {
				{
					translation = 9,
					window = {
						0,
						20,
					},
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
			animation_events = {
				{
					event_name = "rush_start",
					time = 0,
				},
			},
			buffer_to = {
				heavy = 0,
				light = 0,
			},
			cancel_to = {
				heavy = 3,
				light = 3,
			},
			combo_transitions = {
				{
					to = "rush_slash",
					type = "light",
				},
				{
					to = "leapattack",
					type = "heavy",
				},
				{
					to = "rush_slide",
					type = "end",
				},
			},
			target_alignment = {
				keyboard = {
					max_angle = 30,
					radius = 20,
				},
				pad = {
					max_angle = 30,
					radius = 20,
				},
			},
		},
		rush_slide = {
			disable_target_alignment = true,
			duration = 10,
			enemy_collisions = "disable",
			ignore_aim_direction = true,
			override_mover_filter = "level_bound_mover",
			events = {
				{
					breaker = true,
					breaker_light = true,
					damage_amount = 0,
					event_duration = 10,
					event_start = 0,
					hit_react = "tackle",
					on_enter_flow = "rush_slide_start",
					on_exit_flow = "rush_slide_stop",
					perk = "furious_charge",
					type = "box",
					origin = {
						x = 0,
						y = 0.1,
						z = 0,
					},
					half_extents = {
						x = 0.35,
						y = 0.65,
						z = 0.5,
					},
				},
			},
			cancel_to = {
				heavy = 0,
				light = 0,
			},
			combo_transitions = {
				{
					to = "rush_slash",
					type = "light",
				},
				{
					to = "leapattack",
					type = "heavy",
				},
			},
			movements = {
				{
					translation = 2,
					type = "slide",
					window = {
						0,
						10,
					},
				},
			},
			animation_events = {
				{
					event_name = "rush_stop",
					time = 0,
				},
			},
		},
		rush_slash = {
			animation = "attack_light_sweep",
			ignore_aim_direction = true,
			inherit_from = "light2",
			flow_events = {
				{
					event_name = "ability_light_sweep",
					time = 9,
				},
			},
			events = {
				{
					event_duration = 4,
					hit_react = "slash_heavy_left",
					origin_type = "center",
					damage_amount = DAMAGE_LIGHT_COMBO_1,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 1.6,
						y = 1.1,
						z = 0.5,
					},
				},
			},
			movements = {
				{
					translation = 2,
					window = {
						0,
						6,
					},
				},
			},
			cancel_to = {
				heavy = 13,
				interact = 14,
				light = 13,
				navigation = 14,
				rush_aim = 13,
			},
			combo_transitions = {
				{
					to = "light5",
					type = "light",
				},
			},
		},
		leapattack = {
			animation = "attack_leap",
			combo_end = 40,
			disable_target_alignment = true,
			duration = 40,
			enemy_collisions = "disable",
			ignore_aim_direction = true,
			inherit_from = "default_data",
			override_mover_filter = "level_bound_mover",
			on_enter = {
				flow_event = "ability_leapattack_start",
			},
			events = {
				{
					break_food = true,
					damage_type = "cleave",
					event_duration = 1,
					event_start = 20,
					execute = true,
					hit_react = "smash",
					inherit_from = "default_event_data",
					on_enter_flow = "ability_leapattack_impact",
					damage_amount = DAMAGE_SMASH,
					origin = {
						x = 0,
						y = 0.5,
						z = 0,
					},
					half_extents = {
						x = 0.25,
						y = 1,
						z = 0.5,
					},
				},
			},
			movements = {
				{
					translation = 5,
					window = {
						0,
						20,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						22,
					},
				},
			},
			buffer_to = {
				heavy = 20,
				light = 20,
			},
			cancel_to = {
				heavy = 24,
				interact = 27,
				light = 24,
				navigation = 27,
				rush_aim = 24,
			},
		},
	},
}

return t
