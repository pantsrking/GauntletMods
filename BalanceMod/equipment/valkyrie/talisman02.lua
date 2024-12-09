-- chunkname: @equipment/valkyrie/talisman02.lua

local t = {
	icon = "valkyrie_ultimate_02",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "cast",
				type = "talisman",
			},
		},
	},
	abilities = {
		heal_event_data = {
			event_data = true,
			event_duration = 1,
			event_start = 1,
			heal_amount = 2,
			target_type = "allies",
			target_predicates = {
				closure(StateAux.predicate_has_component, "avatar"),
			},
		},
		cast = {
			animation = "ability_talisman_02",
			cooldown = 195,
			duration = 40,
			ignore_interrupt = true,
			flow_events = {
				{
					event_name = "on_talisman_activate",
					time = 0,
				},
				{
					event_name = "on_talisman_complete",
					time = 15,
				},
				{
					event_name = "on_talisman_drawsword",
					time = 32,
				},
			},
			events = {
				{
					event_duration = 1,
					event_start = 16,
				},
				{
					damage_type = "ice",
					effect_type = "ice",
					event_duration = 240,
					event_start = 1,
					on_enter_flow = "ultimate_aegis_execute",
					target_type = "allies",
					target_predicates = {
						closure(StateAux.predicate_has_component, "avatar"),
					},
					status_effects = {
						invincible = {
							duration = 8,
						},
					},
				},
			},
			on_exit = {
				ability = "aegis_of_valhalla",
			},
		},
		aegis_of_valhalla = {
			duration = 240,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			events = {
				{
					event_start = 30,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 60,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 90,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 120,
					inherit_from = "heal_event_data",
				},
			},
		},
	},
}

return t
