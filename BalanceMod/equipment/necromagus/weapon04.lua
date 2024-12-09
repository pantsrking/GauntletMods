-- chunkname: @equipment/necromagus/weapon04.lua

local DAMAGE_DARKBOLT = 20
local DAMAGE_DARKBOLT_EXPLOSION = 7

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
				to = "shadowbolt",
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
		default_data = {
			ability_data = true,
			combo_transitions = {
				{
					to = "seeker_left",
					type = "light",
				},
				{
					to = "shadowbolt",
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
			},
		},
		shadowbolt = {
			animation = "attack_bolt",
			duration = 30,
			inherit_from = "default_data",
			rotation_lock_start = 20,
			target_alignment_type = "ranged",
			target_locking = {
				keyboard = {
					angle_to_lose_target = 5,
					max_angle = 5,
					extents = {
						x = 4,
						y = 10,
						z = 6,
					},
				},
				pad = {
					angle_to_lose_target = 10,
					max_angle = 15,
					extents = {
						x = 4,
						y = 10,
						z = 6,
					},
				},
			},
			events = {
				{
					angle = 0,
					damage_type = "pierce",
					effect_type = "fire",
					event_start = 8,
					friendly_fire = false,
					hit_react = "thrust",
					radius = 0.4,
					speed = 30,
					stagger_origin_type = "direction",
					type = "projectile",
					unit_path = "characters/avatar_necromagus/abilities/heavy_shadowbolt",
					damage_amount = DAMAGE_DARKBOLT,
					origin = {
						x = 0.3,
						y = 1,
						z = 0,
					},
					status_effects = {
						chilled = {
							duration = 5,
							speed_modifier = -.5,
						},
					},
					on_event_complete = {
						ability = "shadowbolt_explode",
					},
				},
			},
			buffer_to = {
				heavy = 6,
				light = 6,
			},
			cancel_to = {
				defense = 0,
				heavy = 14,
				interact = 14,
				light = 14,
				navigation = 15,
			},
		},
		shadowbolt_explode = {
			duration = 3,
			events = {
				{
					break_food = true,
					event_duration = 1,
					event_start = 0,
					hit_react = "poke",
					radius = 3.5,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					damage_amount = DAMAGE_DARKBOLT_EXPLOSION,
					status_effects = {
						chilled = true,
					},
				},
			},
		},
		try_summon_skeletons = {
			ui_info = {
				material = "necromagus_action_ghosts",
				type = "special",
			},
		},
		summon_skeleton_1 = {
			duration = 100,
			spawn_entities = "nil",
			events = {
				{
					event_start = 1,
					inherit_from = "spawn_ghosts_event",
				},
			},
		},
		summon_skeleton_2 = {
			inherit_from = "summon_skeleton_1",
			spawn_entities = "nil",
			events = {
				{},
				{
					event_start = 8,
					inherit_from = "spawn_ghosts_event",
				},
			},
		},
		summon_skeleton_3 = {
			inherit_from = "summon_skeleton_2",
			spawn_entities = "nil",
			events = {
				{},
				{},
				{
					event_start = 16,
					inherit_from = "spawn_ghosts_event",
				},
			},
		},
		summon_skeleton_4 = {
			inherit_from = "summon_skeleton_3",
			spawn_entities = "nil",
			events = {
				{},
				{},
				{},
				{
					event_start = 24,
					inherit_from = "spawn_ghosts_event",
				},
			},
		},
		summon_skeleton_5 = {
			inherit_from = "summon_skeleton_4",
			spawn_entities = "nil",
			events = {
				{},
				{},
				{},
				{},
				{
					event_start = 32,
					inherit_from = "spawn_ghosts_event",
				},
			},
		},
		summon_superskeleton_5 = {
			spawn_entities = "nil",
			events = {
				{
					inherit_from = "spawn_ghosts_mega_event",
				},
				{
					inherit_from = "spawn_ghosts_mega_event",
				},
				{
					inherit_from = "spawn_ghosts_mega_event",
				},
				{
					inherit_from = "spawn_ghosts_mega_event",
				},
				{
					inherit_from = "spawn_ghosts_mega_event",
				},
			},
		},
		spawn_ghosts_event = {
			event_data = true,
			event_duration = 1,
			spawn_entities = {
				{
					unit_path = "necromagus_summoned_ghost",
					random_position_offset = {
						max_radius = 4,
						min_radius = 2,
						unit_radius = 0.5,
					},
				},
				{
					unit_path = "necromagus_summoned_ghost",
					random_position_offset = {
						max_radius = 4,
						min_radius = 2,
						unit_radius = 0.5,
					},
				},
			},
		},
		spawn_ghosts_mega_event = {
			event_data = true,
			event_duration = 1,
			spawn_entities = {
				{
					unit_path = "necromagus_summoned_ghost",
					random_position_offset = {
						max_radius = 4,
						min_radius = 2,
						unit_radius = 0.5,
					},
				},
				{
					unit_path = "necromagus_summoned_ghost",
					random_position_offset = {
						max_radius = 4,
						min_radius = 2,
						unit_radius = 0.5,
					},
				},
				{
					unit_path = "necromagus_summoned_ghost",
					random_position_offset = {
						max_radius = 4,
						min_radius = 2,
						unit_radius = 0.5,
					},
				},
				{
					unit_path = "necromagus_summoned_ghost",
					random_position_offset = {
						max_radius = 4,
						min_radius = 2,
						unit_radius = 0.5,
					},
				},
			},
		},
	},
})
