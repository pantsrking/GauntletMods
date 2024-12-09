-- chunkname: @equipment/warrior/weapon11.lua

local DAMAGE_MEGASMASH_CORE = 90
local DAMAGE_MEGASMASH_SHOCKWAVE = 25

return SettingsAux.override_settings("equipment/warrior/weapon01", {
	combo = {
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
				to = "megasmash",
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
					to = "megasmash",
					type = "special",
				},
				{
					to = "rush_aim",
					type = "rush_aim",
				},
			},
		},
		light1 = {
			animation = "attack_light1",
			inherit_from = "light_template",
			events = {
				{
					hit_react = "hammerswing_left",
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
					hit_react = "hammerswing_right",
				},
			},
			combo_transitions = {
				{
					to = "light3",
					type = "light",
				},
			},
		},
		light4 = {
			events = {
				{
					hit_react = "hammerswing_heavy",
				},
			},
		},
		light7 = {
			events = {
				{
					hit_react = "hammerswing_heavy",
				},
			},
		},
		smash = {
			events = {
				{
					damage_type = "punch",
					hit_react = "thrust",
				},
				{
					damage_type = "punch",
					hit_react = "crush",
					inherit_from = "default_event_data",
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
					on_enter_flow = "ability_leapattack_impact",
					origin_type = "center",
					radius = 1.5,
					type = "sphere",
					origin = {
						x = 0,
						y = 1,
						z = 0,
					},
				},
			},
		},
		megasmash = {
			animation = "attack_leap",
			duration = 70,
			enemy_collisions = "disable",
			inherit_from = "default_data",
			override_mover_filter = "level_bound_mover",
			cooldown = {
				duration = 240,
				time = 20,
			},
			ui_info = {
				material = "warrior_action_groundslam",
				type = "special",
			},
			flow_events = {
				{
					event_name = "ability_special_windup",
					time = 1,
				},
			},
			events = {
				{
					damage_type = "cleave",
					event_duration = 1,
					event_start = 21,
					execute = true,
					hit_react = "crush",
					inherit_from = "default_event_data",
					damage_amount = DAMAGE_MEGASMASH_CORE,
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
				{
					behind_wall_test = true,
					break_food = true,
					breaker = true,
					damage_type = "punch",
					event_duration = 2,
					event_start = 22,
					hit_react = "knockback_hit",
					ignore_rotation = true,
					on_enter_flow = "ability_special_execute",
					origin_type = "center",
					radius = 5.5,
					stagger_origin_type = "query",
					type = "sphere",
					damage_amount = DAMAGE_MEGASMASH_SHOCKWAVE,
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
			cancel_to = {
				heavy = 25,
				interact = 26,
				light = 25,
				navigation = 26,
				rush_aim = 25,
			},
			invincibilities = {
				{
					window = {
						0,
						23,
					},
				},
			},
			movements = {
				{
					translation = 4,
					window = {
						0,
						20,
					},
				},
			},
		},
		rush = {
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
					to = "leapsmash",
					type = "special",
				},
				{
					to = "rush_slide",
					type = "end",
				},
			},
		},
		rush_slide = {
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
					to = "leapsmash",
					type = "special",
				},
			},
		},
		leapattack = {
			on_enter = {
				flow_event = "ability_leapattack_start",
			},
			events = {
				{
					damage_type = "cleave",
					event_duration = 1,
					event_start = 20,
					execute = true,
					hit_react = "crush",
					inherit_from = "default_event_data",
					on_enter_flow = "ability_leapattack_impact",
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
				{
					breaker = true,
					breaker_light = true,
					damage_amount = 0,
					damage_type = "cleave",
					event_duration = 1,
					event_start = 20,
					hit_react = "thrust_heavy",
					inherit_from = "default_event_data",
					origin_type = "center",
					radius = 2,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
		rush_slash = {
			events = {
				{
					hit_react = "shockwave",
				},
			},
		},
		leapsmash = {
			animation = "attack_leap",
			duration = 70,
			ui_info = {
				material = "warrior_action_cleave",
				type = "special",
			},
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
					event_start = 20,
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
			cancel_to = {
				defense = 0,
				heavy = 25,
				interact = 26,
				light = 25,
				navigation = 26,
			},
		},
	},
})
