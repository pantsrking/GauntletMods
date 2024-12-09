-- chunkname: @gameobjects/relics/boots_of_ranadam.lua

local SPEED_MODIFIER = 0.5
local t = {
	icon = "item_boots_of_ranadam",
	item_id = "relic_boots_of_ranadam",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "ranadam_1",
				type = "relic_1",
			},
			{
				to = "ranadam_2",
				type = "relic_2",
			},
			{
				to = "ranadam_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		speed_boost_ability = {
			ability_data = true,
			cooldown = 1200,
			duration = 210,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_boots_of_ranadam_reset",
			},
		},
		speed_boost_event = {
			event_data = true,
			event_duration = 210,
			event_start = 1,
			flow_event_effect_unit_spawned = "windwalker_tier1_activate",
			target_type = "self",
			unit_path = "gameobjects/relics/relic_effects",
			status_effects = {
				haste = {
					duration = 7,
					speed_modifier = 0.5,
				},
			},
			on_enter = {
				flow_event = "on_haste_started",
			},
			on_exit = {
				flow_event = "on_haste_stopped",
			},
			on_exit_custom = function (event_handler, event)
				Unit.flow_event(event.unit, "windwalker_deactivate")
			end,
		},
		slow_event = {
			event_data = true,
			event_duration = 210,
			event_start = 1,
			origin_type = "center",
			radius = 2.5,
			refresh_hitlist_time = 30,
			type = "sphere",
			status_effects = {
				slowed = {
					duration = 1,
					speed_modifier = -0.6,
				},
			},
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
		},
		ranadam_1 = {
			inherit_from = "speed_boost_ability",
			events = {
				{
					inherit_from = "speed_boost_event",
				},
			},
		},
		ranadam_2 = {
			inherit_from = "ranadam_1",
			events = {
				{
					inherit_from = "speed_boost_event",
				},
				{
					inherit_from = "slow_event",
				},
			},
		},
		ranadam_3 = {
			cooldown = 1110,
			inherit_from = "ranadam_2",
		},
	},
}

return t
