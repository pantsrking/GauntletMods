-- chunkname: @equipment/warrior/talisman01.lua
local CONJURE_DURATION = 40
local DAMAGE = 220
local t = {
	icon = "warrior_ultimate_01",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "potion_throw",
				type = "talisman",
			},
		},
	},
	abilities = {
		potion_throw = {
			animation = "ability_talisman_01",
			cooldown = 17,
			disable_target_alignment = true,
			duration = 40,
			ignore_interrupt = true,
			flow_events = {
				{
					event_name = "ultimate_throw_windup",
					time = 1,
				},
			},
			invincibilities = {
				{
					window = {
						0,
					CONJURE_DURATION,
					},
				},
			},
			events = {
				{
					damage_type = "fire",
					event_start = 10,
					on_enter_flow = "ultimate_throw_launch",
					radius = 0.15,
					speed_multiplier = 3,
					type = "projectile_lob",
					unit_path = "potion_projectile",
					vertical_angle = 60,
					construct_target_position = {
						distance_max = 9,
						distance_min = 9,
					},
					origin = {
						x = 0,
						y = 1,
						z = 0.9,
					},
					on_event_complete = {
						ability = "potion_explosion",
					},
				},
			},
			cancel_to = {
				defense = 0,
				heavy = 16,
				interact = 16,
				light = 16,
				navigation = 16,
			},
		},
		potion_explosion = {
			duration = 4,
			events = {
				{
					damage_hit_delay = 2,
					event_duration = 2,
					event_start = 1,
					hit_react = "shockwave",
					radius = 7,
					type = "sphere",
					damage_amount = DAMAGE,
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

return t
