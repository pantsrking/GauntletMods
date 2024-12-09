-- chunkname: @equipment/valkyrie/talisman03.lua

local t = {
	icon = "valkyrie_ultimate_03",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "valkyrie_squad",
				type = "talisman",
			},
		},
	},
	abilities = {
		valkyrie_squad = {
			animation = "ability_talisman_01",
			cooldown = 45,
			duration = 45,
			ignore_interrupt = true,
			run_until_death = true,
			set_as_busy = false,
			on_cooldowned = {
				timpani_event = "relic_illusion_ring_reset",
			},
			flow_events = {
				{
					event_name = "ultimate_valkyries_execute",
					time = 0,
				},
				{
					event_name = "on_talisman_complete",
					time = 13,
				},
				{
					event_name = "on_talisman_drawsword",
					time = 28,
				},
			},
			spawn_entities = {
				{
					spawn_info_key = "default",
					time = 14,
					unit_path = "valkyrie_summoned_valkyrie",
					position_offset = {
						x = 0,
						y = 2,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 16,
					unit_path = "valkyrie_summoned_valkyrie",
					position_offset = {
						x = 2,
						y = -1,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 17,
					unit_path = "valkyrie_summoned_valkyrie",
					position_offset = {
						x = -2,
						y = -1,
						z = 0,
					},
				},
			},
			events = {
				{
					damage_amount = 16,
					damage_hit_delay = 1,
					event_duration = 1,
					event_start = 11,
					hit_react = "shockwave",
					radius = 3,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
			cancel_to = {
				defense = 0,
				heavy = 16,
				interact = 16,
				light = 16,
				navigation = 16,
			},
		},
	},
}

return t
