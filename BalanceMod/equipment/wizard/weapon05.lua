-- chunkname: @equipment/wizard/weapon05.lua

return SettingsAux.override_settings("equipment/wizard/weapon01", {
	item_type = "weapon",
	abilities = {
		serpentine_event_data = {
			amplitude = 40,
			angular_frequency = 3,
			damage_amount = 0,
			event_data = true,
			event_start = 1,
			inherit_from = "projectile_ability_event",
			max_distance = 14,
			power = 9999,
			radius = 0.15,
			speed = 30,
			type = "projectile_serpent",
			unit_path = "spell_serpentine_projectile",
			origin = {
				x = -0.3,
				y = 0.5,
				z = 0,
			},
		},
		serpentine = {
			animation = "attack_serpentine",
			disable_target_alignment = true,
			duration = 19,
			enemy_collisions = "disable",
			override_mover_filter = "level_bound_mover",
			cooldown = {
				duration = 180,
				time = 3,
			},
			ui_info = {
				material = "frost_serpents_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_frost_serpents_windup",
			},
			on_exit = {
				flow_event = "ability_frost_serpents_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				rotation_speed = 0,
				speed = 0,
			},
			events = {
				{
					can_be_blocked = false,
					damage_amount = 8,
					event_duration = 15,
					event_start = 3,
					hit_react = "fire_bolt",
					max_distance = 12,
					on_enter_flow = "ability_frost_serpents_fire",
					origin_type = "center",
					type = "box_sweep",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 1,
						y = 1,
						z = 1,
					},
					status_effects = {
						burning = {
							damage_per_second = 4,
							duration = 12,
							interval = 0.5,
						},
					},
				},
			},
			cancel_to = {
				custom = 18,
				interact = 18,
				navigation = 18,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
			movements = {
				{
					translation = 12,
					window = {
						3,
						18,
					},
				},
			},
			invincibilities = {
				{
					window = {
						3,
						18,
					},
				},
			},
		},
		fire_bolt = {
			animation = "attack_firebolt",
			duration = 25,
			cooldown = {
				duration = 15,
				time = 3,
			},
			ui_info = {
				material = "frost_bolt_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_frost_bolt_windup",
			},
			on_exit = {
				flow_event = "ability_frost_bolt_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				rotation_speed = 0,
				speed = 4.5,
			},
			events = {
				{
					block_damage = 0,
					damage_amount = 32,
					damage_hit_delay = 1,
					damage_type = "fire",
					effect_type = "firebolt",
					event_start = 3,
					hit_react = "fire_bolt",
					inherit_from = "projectile_ability_event",
					on_enter_flow = "ability_frost_bolt_fire",
					radius = 0.4,
					speed = 30,
					unit_path = "spell_frost_bolt_projectile",
					status_effects = {
						frozen = true,
					},
				},
			},
			buffer_to = {
				custom = 10,
			},
			cancel_to = {
				custom = 12,
				interact = 22,
				navigation = 22,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
		},
		fireball = {
			animation = "attack_firebomb",
			disable_target_alignment = true,
			duration = 32,
			cooldown = {
				duration = 60,
				time = 10,
			},
			ui_info = {
				material = "frost_bomb_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_frost_bomb_windup",
			},
			on_exit = {
				flow_event = "ability_frost_bomb_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 1.5,
				rotation_speed = 0.4 * math.pi,
			},
			events = {
				{
					block_damage = 1,
					damage_amount = 0,
					damage_hit_delay = 1,
					damage_type = "fire",
					effect_type = "firebolt",
					event_start = 10,
					hit_react = "poke",
					inherit_from = "projectile_ability_event",
					on_enter_flow = "ability_frost_bomb_fire",
					power = 9999,
					radius = 0.15,
					speed_multiplier = 3,
					type = "projectile_lob",
					unit_path = "spell_frost_bomb_projectile",
					vertical_angle = 60,
					construct_target_position = {
						distance_max = 10,
						distance_min = 10,
					},
					on_event_complete = {
						ability = "fireball_explosion",
					},
				},
			},
			buffer_to = {
				custom = 25,
			},
			cancel_to = {
				custom = 31,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
		},
		fireball_explosion = {
			duration = 15,
			flow_events = {
				{
					event_name = "explode",
					time = 15,
				},
			},
			events = {
				{
					behind_wall_test = true,
					breaker = true,
					damage_amount = 16,
					damage_hit_delay = 2,
					damage_type = "fire",
					event_duration = 1,
					event_start = 0,
					hit_react = "frost",
					ignore_rotation = true,
					origin_type = "center",
					radius = 3,
					stagger_origin_type = "query",
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0.75,
					},
					status_effects = {
						chilled = {
							duration = 5,
							speed_modifier = -0.8,
						},
					},
				},
			},
		},
		murderball = {
			combo_end = 60,
			disable_target_alignment = true,
			duration = 60,
			animation_events = {
				{
					event_name = "attack_demoncleave_windup",
					time = 0,
				},
				{
					event_name = "attack_demoncleave_execute",
					time = 14,
				},
			},
			cooldown = {
				duration = 180,
				time = 3,
			},
			on_enter = {
				flow_event = "ability_special_windup",
			},
			on_exit = {
				flow_event = "ability_special_exit",
			},
			on_cooldowned = {
				timpani_event = "warrior_ability_cooldown",
			},
			ui_info = {
				material = "warrior_action_demoncleave",
				type = "special",
			},
			events = {
				{
					angle = 0,
					backup_unit_path = "special_demoncleave_projectile",
					behind_wall_test = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_amount = 16,
					damage_type = "slash",
					effect_type = "axe",
					event_duration = 1,
					event_start = 12,
					hit_react = "poke",
					max_distance = 10,
					on_enter_flow = "ability_special_execute",
					power = 9999,
					radius = 0.5,
					speed = 15,
					tick_frequency = 60,
					type = "projectile_grounded",
					on_enter_custom = CREATE_EVENT_UNIT,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_event_complete = {
						ability = "murderball_return",
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						21,
					},
				},
			},
			movements = {
				{
					translation = 0.2,
					window = {
						16,
						20,
					},
				},
			},
			buffer_to = {
				heavy = 10,
				light = 10,
				special = 10,
				whirlwind = 10,
			},
			cancel_to = {
				heavy = 20,
				interact = 20,
				light = 20,
				navigation = 20,
				rush_aim = 20,
				special = 20,
				whirlwind = 20,
			},
		},
		murderball_return = {
			combo_end = 60,
			duration = 60,
			cooldown = {
				duration = 180,
				time = 3,
			},
			events = {
				{
					behind_wall_test = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_amount = 200,
					damage_hit_delay = 3,
					damage_type = "spear",
					effect_type = "spear",
					event_duration = 8,
					event_start = 0,
					execute = true,
					hit_react = "slash_heavy_left",
					on_enter_flow = "ability_special_execute",
					radius = 2,
					stagger_origin_type = "character",
					type = "sphere",
					origin = {
						y = 0,
						z = 0,
						x = -0,
					},
				},
				{
					angle = 0,
					backup_unit_path = "special_demoncleave_projectile",
					behind_wall_test = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_type = "slash",
					effect_type = "axe",
					event_duration = 1,
					event_start = 0,
					execute = true,
					hit_react = "smash",
					max_distance = 15,
					power = 9999,
					radius = 0.5,
					speed = 20,
					tick_frequency = 60,
					type = "projectile_homing",
					use_caster_as_target = true,
					on_enter_custom = ASSIGN_STORED_EVENT_UNIT,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					damage_amount = DEMONCLEAVE_DAMAGE,
				},
			},
			invincibilities = {
				{
					window = {
						0,
						21,
					},
				},
			},
			movements = {
				{
					translation = 0.2,
					window = {
						16,
						20,
					},
				},
			},
			buffer_to = {
				heavy = 10,
				light = 10,
				special = 10,
				whirlwind = 10,
			},
			cancel_to = {
				heavy = 30,
				interact = 30,
				light = 30,
				navigation = 30,
				rush_aim = 30,
				special = 30,
				whirlwind = 30,
			},
		},
	},
})
