-- chunkname: @equipment/necromagus/weapon02.lua

return SettingsAux.override_settings("equipment/necromagus/weapon01", {
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
				material = "necromagus_action_archers",
				type = "special",
			},
		},
		summon_skeleton_1 = {
			duration = 15,
			spawn_entities = {
				{
					spawn_info_key = "default",
					time = 0,
					unit_path = "necromagus_summoned_archer",
					position_offset = {
						x = 0,
						y = -2,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_2 = {
			inherit_from = "summon_skeleton_1",
			spawn_entities = {
				{},
				{
					spawn_info_key = "default",
					time = 7,
					unit_path = "necromagus_summoned_archer",
					position_offset = {
						x = -1,
						y = -1.5,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_3 = {
			inherit_from = "summon_skeleton_2",
			spawn_entities = {
				{},
				{},
				{
					spawn_info_key = "default",
					time = 5,
					unit_path = "necromagus_summoned_archer",
					position_offset = {
						x = 1,
						y = -1.5,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_4 = {
			inherit_from = "summon_skeleton_3",
			spawn_entities = {
				{},
				{},
				{},
				{
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_archer",
					position_offset = {
						x = -2,
						y = -1,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_5 = {
			inherit_from = "summon_skeleton_4",
			spawn_entities = {
				{},
				{},
				{},
				{},
				{
					spawn_info_key = "default",
					time = 12,
					unit_path = "necromagus_summoned_archer",
					position_offset = {
						x = 2,
						y = -1,
						z = 0,
					},
				},
			},
		},
		summon_superskeleton_5 = {
			inherit_from = "summon_skeleton_5",
			spawn_entities = {
				{
					unit_path = "necromagus_summoned_superarcher",
				},
				{
					unit_path = "necromagus_summoned_superarcher",
				},
				{
					unit_path = "necromagus_summoned_superarcher",
				},
				{
					unit_path = "necromagus_summoned_superarcher",
				},
				{
					unit_path = "necromagus_summoned_superarcher",
				},
			},
		},
	},
})
