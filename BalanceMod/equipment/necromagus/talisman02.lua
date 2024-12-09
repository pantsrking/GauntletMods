-- chunkname: @equipment/necromagus/talisman02.lua

local DAMAGE = 20
local t = {
	icon = "necromagus_ultimate_02",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "souleater_cast",
				type = "talisman",
			},
		},
	},
	abilities = {
		souleater_cast = {
			animation_driven_movement = "true",
			duration = 44,
			ignore_interrupt = true,
			target_alignment_type = "ranged",
			on_cooldowned = {
				timpani_event = "necromagus_ability_cooldown",
			},
			animation_events = {
				{
					event_name = "windup",
					time = 1,
				},
				{
					event_name = "attack_charged",
					time = 20,
				},
			},
			flow_events = {
				{
					event_name = "ultimate_remnant_windup",
					time = 0,
				},
			},
			spawn_entities = {
				{
					spawn_info_key = "default",
					time = 1,
					unit_path = "ultimate_remnant",
					position_offset = {
						x = 0,
						y = 2,
						z = 0,
					},
				},
			},
			buffer_to = {
				heavy = 4,
				light = 4,
			},
			cancel_to = {
				heavy = 10,
				interact = 13,
				light = 10,
				navigation = 13,
			},
			invincibilities = {
				{
					window = {
						0,
						8,
					},
				},
			},
		},
	},
}

return t
