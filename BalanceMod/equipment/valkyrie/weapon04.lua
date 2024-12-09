-- chunkname: @equipment/valkyrie/weapon04.lua

local DAMAGE_THROW = 18
local DAMAGE_INTERCEPT = 15

return SettingsAux.override_settings("equipment/valkyrie/weapon01", {
	combo = {
		combo_transitions = {
			{
				to = "sword1",
				type = "light",
			},
			{
				to = "throw_spear",
				type = "heavy",
			},
			{
				to = "intercept",
				type = "special",
			},
			{
				to = "shield_bash",
				type = "melee_blocked",
			},
		},
	},
	abilities = {
		default_data = {
			ability_data = true,
			combo_transitions = {
				{
					to = "sword1",
					type = "light",
				},
				{
					to = "throw_spear",
					type = "heavy",
				},
				{
					to = "intercept",
					type = "special",
				},
				{
					type = "defense",
				},
			},
		},
		throw_spear = {
			animation = "ability_spear_throw",
			duration = 48,
			inherit_from = "default_data",
			target_alignment_type = "ranged",
			flow_events = {
				{
					event_name = "ability_throw_spear_windup",
					time = 1,
				},
				{
					event_name = "ability_spear_thrust_stop",
					time = 21,
				},
			},
			on_exit = {
				flow_event = "ability_spear_thrust_stop",
			},
			target_locking = {
				keyboard = {
					angle_to_lose_target = 5,
					max_angle = 5,
					extents = {
						x = 4,
						y = 10,
						z = 6,
					},
				},
				pad = {
					angle_to_lose_target = 10,
					max_angle = 15,
					extents = {
						x = 4,
						y = 10,
						z = 6,
					},
				},
			},
			events = {
				{
					angle = 0,
					behind_wall_test = true,
					break_block = true,
					break_food = true,
					collision_filter = "damageable_and_wall",
					damage_hit_delay = 1,
					damage_type = "slash",
					event_duration = 1,
					event_start = 5,
					execute = false,
					head_shot = true,
					hit_react = "thrust",
					on_enter_flow = "ability_throw_spear_launch",
					power = 2,
					radius = 0.1,
					speed = 40,
					stagger_origin_type = "direction",
					tick_frequency = 60,
					type = "projectile",
					unit_path = "projectile_spear",
					damage_amount = DAMAGE_THROW,
					origin = {
						x = 0,
						y = 0.5,
						z = -0.1,
					},
				},
			},
			buffer_to = {
				heavy = 6,
				light = 6,
				special = 6,
			},
			cancel_to = {
				defense = 10,
				heavy = 10,
				interact = 10,
				light = 10,
				navigation = 11,
				special = 10,
			},
			on_exit = {
				flow_event = "ability_throw_spear_return",
			},
		},
		intercept = {
			animation = "ability_dash_bash",
			duration = 61,
			inherit_from = "default_data",
			cooldown = {
				duration = 90,
				time = 5,
			},
			ui_info = {
				material = "valkyrie_action_intercept",
				type = "special",
			},
			flow_events = {
				{
					event_name = "ability_special_windup",
					time = 0,
				},
			},
			events = {
				{
					break_food = true,
					breaker = true,
					event_duration = 1,
					event_start = 9,
					hit_react = "shockwave",
					on_enter_flow = "ability_special_execute",
					origin_type = "center",
					radius = 3,
					type = "sphere",
					damage_amount = DAMAGE_INTERCEPT,
					origin = {
						x = 0,
						y = 1,
						z = 0,
					},
				},
			},
			movements = {
				{
					translation = 5.4,
					window = {
						0,
						7,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						7,
					},
				},
			},
			cancel_to = {
				defense = 11,
				heavy = 11,
				interact = 11,
				light = 11,
				navigation = 11,
				special = 11,
			},
		},
	},
})
