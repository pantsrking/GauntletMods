-- chunkname: @gameobjects/relics/swirling_vortex.lua

local t = {
	icon = "item_swirling_vortex",
	item_id = "relic_swirling_vortex",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "vortex_1",
				type = "relic_1",
			},
			{
				to = "vortex_2",
				type = "relic_2",
			},
			{
				to = "vortex_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		vortex_data = {
			ability_data = true,
			cooldown = 1200,
			duration = 70,
			ignore_interrupt = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_swirling_vortex_reset",
			},
		},
		vortex_1 = {
			inherit_from = "vortex_data",
			spawn_entities = {
				{
					time = 0,
					unit_path = "swirling_vortex_trap",
					position_offset = {
						x = 0,
						y = 3,
						z = 0,
					},
				},
			},
		},
		vortex_2 = {
			inherit_from = "vortex_data",
			spawn_entities = {
				{
					time = 0,
					unit_path = "swirling_vortex_trap_tier2",
					position_offset = {
						x = 0,
						y = 3,
						z = 0,
					},
				},
			},
		},
		vortex_3 = {
			cooldown = 900,
			inherit_from = "vortex_data",
			spawn_entities = {
				{
					time = 0,
					unit_path = "swirling_vortex_trap_tier3",
					position_offset = {
						x = 0,
						y = 3,
						z = 0,
					},
				},
			},
		},
	},
}

return t
