-- chunkname: @equipment/necromagus/weapon03.lua

return SettingsAux.override_settings("equipment/necromagus/weapon01", {
	soul_heal = 1,
	combo = {
		abilities = {
			custom = true,
			defense = true,
			dodge_death = true,
			heavy = true,
			light = true,
			special = true,
		},
		combo_transitions = {
			{
				to = "seeker_left",
				type = "light",
			},
			{
				to = "summon_heavy",
				type = "heavy",
			},
			{
				to = "try_summon_skeletons",
				type = "special",
			},
			{
				to = "tumble",
				type = "defense",
			},
			{
				to = "dodge_death",
				type = "dodge_death",
			},
			{
				type = "custom",
			},
		},
	},
	abilities = {
		try_summon_skeletons = {
			ui_info = {
				material = "necromagus_action_dominate",
				type = "special",
			},
		},
		summon_skeleton_1 = {
			duration = 15,
			spawn_entities = "nil",
			events = {
				{
					event_duration = 1,
					event_start = 1,
					flow_event_effect_unit_spawned = "sirens_lute_activate",
					radius = 3.5,
					type = "sphere",
					unit_path = "gameobjects/relics/relic_effects",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					status_effects = {
						charmed = {
							duration = 3,
						},
					},
				},
				{
					damage_amount = 0,
					damage_hit_delay = 1,
					event_duration = 1,
					event_start = 1,
					hit_react = "thrust",
					radius = 3,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_2 = {
			inherit_from = "summon_skeleton_1",
			spawn_entities = "nil",
			events = {
				{
					flow_event_effect_unit_spawned = "sirens_lute_activate",
					unit_path = "gameobjects/relics/relic_effects",
					status_effects = {
						charmed = {
							duration = 5,
						},
					},
				},
			},
		},
		summon_skeleton_3 = {
			inherit_from = "summon_skeleton_2",
			spawn_entities = "nil",
			events = {
				{
					flow_event_effect_unit_spawned = "sirens_lute_activate",
					unit_path = "gameobjects/relics/relic_effects",
					status_effects = {
						charmed = {
							duration = 7.5,
						},
					},
				},
			},
		},
		summon_skeleton_4 = {
			inherit_from = "summon_skeleton_3",
			spawn_entities = "nil",
			events = {
				{
					flow_event_effect_unit_spawned = "sirens_lute_activate",
					unit_path = "gameobjects/relics/relic_effects",
					status_effects = {
						charmed = {
							duration = 10,
						},
					},
				},
			},
		},
		summon_skeleton_5 = {
			inherit_from = "summon_skeleton_4",
			spawn_entities = "nil",
			events = {
				{
					flow_event_effect_unit_spawned = "sirens_lute_activate",
					unit_path = "gameobjects/relics/relic_effects",
					status_effects = {
						charmed = {
							duration = 15,
						},
					},
				},
			},
		},
		summon_superskeleton_5 = {
			inherit_from = "summon_skeleton_5",
			spawn_entities = "nil",
			events = {
				{
					flow_event_effect_unit_spawned = "sirens_lute_activate",
					unit_path = "gameobjects/relics/relic_effects",
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
	},
})
