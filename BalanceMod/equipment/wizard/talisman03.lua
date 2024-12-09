-- chunkname: @equipment/wizard/talisman03.lua

local t = {
	icon = "wizard_ultimate_03",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "supershield",
				type = "talisman",
			},
		},
	},
	abilities = {
		supershield = {
			cooldown = {
				duration = 30,
				time = 3,
			},
			on_enter = {
				flow_event = "ultimate_barrier_windup",
			},
			{
				event_name = "on_talisman_activate",
				time = 0,
			},
			{
				event_name = "on_talisman_complete",
				time = 8,
			},
			animation = "ability_talisman_03",
			disable_target_alignment = true,
			duration = 20,
			ignore_aim_direction = true,
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				rotation_speed = 0,
				speed = 0,
			},
			spawn_entities = {
				{
					time = 3,
					unit_path = "ultimate_shield",
					position_offset = {
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
