-- chunkname: @gameobjects/relics/firetrail_boots.lua

local DURATION = 3
local DURATION_LONG = 4
local t = {
	icon = "item_firetrail_boots",
	item_id = "relic_firetrail_boots",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "firetrail_boots_1",
				type = "relic_1",
			},
			{
				to = "firetrail_boots_2",
				type = "relic_2",
			},
			{
				to = "firetrail_boots_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		firetrail_boots_data = {
			ability_data = true,
			enemy_collisions = "disable",
			cooldown = 1200,
			ignore_interrupt = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_enter = {
				timpani_event = "relic_firetrail_ring_activate",
			},
			on_exit = {
				timpani_event = "relic_firetrail_ring_deactivate",
			},
			on_cooldowned = {
				timpani_event = "relic_firetrail_ring_reset",
			},
		},
		firetrail_event_data = {
			event_data = true,
			event_duration = 90,
			event_start = 1,
			flow_event_effect_unit_spawned = "firetrail_boots_activate",
			target_type = "self",
			unit_path = "gameobjects/relics/relic_effects",
			on_exit_custom = function (event_handler, event)
				Unit.flow_event(event.unit, "firetrail_boots_deactivate")
			end,
		},
		firetrail_boots_1 = {
			inherit_from = "firetrail_boots_data",
			duration = DURATION * 30,
			events = {
				{
					inherit_from = "firetrail_event_data",
					event_duration = DURATION * 30,
					status_effects = {
						swiftness = {
							speed_modifier = 1,
							duration = DURATION,
						},
					},
				},
			},
			spawn_entities = {
				{
					condition_mover_on_ground = true,
					time = 1,
					time_interval = 5,
					unit_path = "firetrail_area",
				},
			},
		},
		firetrail_boots_2 = {
			inherit_from = "firetrail_boots_1",
			duration = DURATION_LONG * 30,
			events = {
				{
					inherit_from = "firetrail_event_data",
					event_duration = DURATION_LONG * 30,
					status_effects = {
						swiftness = {
							speed_modifier = 1,
							duration = DURATION_LONG,
						},
					},
				},
			},
		},
		firetrail_boots_3 = {
			cooldown = 900,
			inherit_from = "firetrail_boots_2",
		},
	},
}

return t
