-- chunkname: @gameobjects/relics/ghost_orb.lua

local t = {
	icon = "item_ghost_orb",
	item_id = "relic_ghost_orb",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "ghostorb_1",
				type = "relic_1",
			},
			{
				to = "ghostorb_2",
				type = "relic_2",
			},
			{
				to = "ghostorb_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		ghostorb_ability_data = {
			ability_data = true,
			enemy_collisions = "disable",
			ignore_aim_direction = true,
			ignore_interrupt = true,
			interrupt_current_combo = true,
			override_mover_filter = "level_bound_mover",
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_ghost_orb_reset",
			},
		},
		ethereal_event = {
			event_data = true,
			event_duration = 1,
			event_start = 1,
			flow_event_effect_unit_spawned = "ghostorb_activate",
			target_type = "allies",
			unit_path = "gameobjects/relics/relic_effects",
			target_predicates = {
				closure(StateAux.predicate_has_component, "avatar"),
				partial(StateAux.predicate_within_range, 0, 5),
			},
			on_exit_custom = function (event_handler, event)
				Unit.flow_event(event.unit, "ghostorb_deactivate")
			end,
		},
		ghostorb_1 = {
			cooldown = 1200,
			duration = 180,
			inherit_from = "ghostorb_ability_data",
			events = {
				{
					inherit_from = "ethereal_event",
					status_effects = {
						invisible = {
							duration = 6,
						},
					},
				},
			},
		},
		ghostorb_2 = {
			duration = 300,
			inherit_from = "ghostorb_1",
			events = {
				{
					status_effects = {
						invisible = {
							duration = 12,
						},
					},
				},
			},
		},
		ghostorb_3 = {
			cooldown = 900,
			inherit_from = "ghostorb_2",
		},
	},
}

return t
