-- chunkname: @gameobjects/relics/freeze_ring.lua

local t = {
	icon = "item_freeze_ring",
	item_id = "relic_freeze_ring",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "freeze_ring_1",
				type = "relic_1",
			},
			{
				to = "freeze_ring_2",
				type = "relic_2",
			},
			{
				to = "freeze_ring_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		default_data = {
			ability_data = true,
			cooldown = 600,
			duration = 70,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_freeze_ring_reset",
			},
		},
		default_event_data = {
			breaker = false,
			damage_amount = 0,
			damage_type = "ice",
			event_data = true,
			event_duration = 1,
			event_start = 1,
			flow_event_effect_unit_spawned = "freeze_ring_explode",
			friendly_fire = false,
			origin_type = "center",
			type = "sphere",
			unit_path = "gameobjects/relics/relic_effects",
			ignore_block = {
				status_receiver = true,
			},
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
		},
		freeze_ring_1 = {
			inherit_from = "default_data",
			events = {
				{
					inherit_from = "default_event_data",
					radius = 5,
					status_effects = {
						frozen = {
							duration = 4,
						},
					},
				},
			},
		},
		freeze_ring_2 = {
			inherit_from = "freeze_ring_1",
			events = {
				{
					status_effects = {
						frozen = {
							duration = 4,
						},
						chilled = {
							duration = 4,
							speed_modifier = -0.3,
						},
					},
				},
			},
		},
		freeze_ring_3 = {
			cooldown = 450,
			inherit_from = "freeze_ring_2",
		},
	},
}

return t
