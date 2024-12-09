-- chunkname: @equipment/warrior/weapon04.lua

local DEMONCLEAVE_DAMAGE = 85

return SettingsAux.override_settings("equipment/warrior/weapon01", {
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
				to = "demoncleave",
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
					to = "demoncleave",
					type = "special",
				},
				{
					to = "rush_aim",
					type = "rush_aim",
				},
			},
		},
		demoncleave = {
			combo_end = 60,
			disable_target_alignment = true,
			duration = 60,
			inherit_from = "default_data",
			animation_events = {
				{
					event_name = "attack_demoncleave_windup",
					time = 0,
				},
				{
					event_name = "attack_demoncleave_execute",
					time = 14,
				},
			},
			cooldown = {
				duration = 180,
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
				material = "warrior_action_demoncleave",
				type = "special",
			},
			events = {
				{
					damage_amount = 0,
					event_duration = 0,
					event_start = 0,
					hit_react = "smash",
					radius = 2,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
				{
					behind_wall_test = true,
					break_food = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_type = "cleave",
					effect_type = "axe",
					event_duration = 7,
					event_start = 16,
					execute = true,
					grow_duration = 5,
					hit_react = "slash_heavy_right",
					on_enter_flow = "ability_special_execute",
					origin_type = "base",
					power = 9999,
					tick_frequency = 60,
					type = "box_growing",
					origin = {
						x = 0,
						y = -0.5,
						z = 0,
					},
					half_extents = {
						x = 1.5,
						y = 1,
						z = 2,
					},
					max_extents = {
						x = 1.5,
						y = 4,
						z = 2,
					},
					damage_amount = DEMONCLEAVE_DAMAGE,
				},
			},
			invincibilities = {
				{
					window = {
						0,
						21,
					},
				},
			},
			movements = {
				{
					translation = 0.2,
					window = {
						16,
						20,
					},
				},
			},
			buffer_to = {
				heavy = 10,
				light = 10,
				special = 10,
				whirlwind = 10,
			},
			cancel_to = {
				heavy = 20,
				interact = 20,
				light = 20,
				navigation = 20,
				rush_aim = 20,
				special = 20,
				whirlwind = 20,
			},
		},
	},
})
