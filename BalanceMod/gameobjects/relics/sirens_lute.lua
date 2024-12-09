-- chunkname: @gameobjects/relics/sirens_lute.lua

local t = {
	icon = "item_sirens_lute",
	item_id = "relic_sirens_lute",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "sirens_lute_1",
				type = "relic_1",
			},
			{
				to = "sirens_lute_2",
				type = "relic_2",
			},
			{
				to = "sirens_lute_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		sirens_lute_data = {
			ability_data = true,
			cooldown = 450,
			duration = 250,
			ignore_aim_direction = false,
			ignore_interrupt = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_sirens_lute_reset",
			},
			events = {
				{
					event_duration = 1,
					event_start = 1,
					flow_event_effect_unit_spawned = "sirens_lute_activate",
					radius = 3.3,
					type = "sphere",
					unit_path = "gameobjects/relics/relic_effects",
					origin = {
						x = 0,
						y = 3,
						z = 0,
					},
					status_effects = {
						charmed = {
							duration = 10,
						},
						haste = {
							duration = 10,
							speed_modifier = 1,
						},
					},
				},
			},
		},
		sirens_lute_1 = {
			inherit_from = "sirens_lute_data",
			events = {
				{},
			},
		},
		sirens_lute_2 = {
			inherit_from = "sirens_lute_data",
			events = {
				{
					status_effects = {
						charmed = {
							duration = 15,
						},
						haste = {
							duration = 15,
							speed_modifier = 1,
						},
					},
				},
			},
		},
		sirens_lute_3 = {
			cooldown = 300,
			inherit_from = "sirens_lute_data",
			events = {
				{},
			},
		},
	},
}

return t
