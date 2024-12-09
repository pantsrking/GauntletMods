-- chunkname: @gameobjects/relics/eye_of_dur.lua

local t = {
	icon = "item_eye_of_dur",
	item_id = "relic_eye_of_dur",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "eye_of_dur_1",
				type = "relic_1",
			},
			{
				to = "eye_of_dur_2",
				type = "relic_2",
			},
			{
				to = "eye_of_dur_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		eye_of_dur_data = {
			cooldown = 1500,
			duration = 70,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_eye_of_dur_reset",
			},
		},
		eye_of_dur_1 = {
			inherit_from = "eye_of_dur_data",
			spawn_entities = {
				{
					time = 0,
					unit_path = "relic_gargoyle",
					position_offset = {
						x = 0,
						y = 3,
						z = 0,
					},
				},
			},
		},
		eye_of_dur_2 = {
			inherit_from = "eye_of_dur_1",
			spawn_entities = {
				{
					time = 0,
					unit_path = "relic_gargoyle_tier2",
					position_offset = {
						x = 0,
						y = 3,
						z = 0,
					},
				},
			},
		},
		eye_of_dur_3 = {
			cooldown = 1200,
			inherit_from = "eye_of_dur_2",
		},
	},
}

return t
