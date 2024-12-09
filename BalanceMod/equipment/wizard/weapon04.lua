-- chunkname: @equipment/wizard/weapon04.lua

return SettingsAux.override_settings("equipment/wizard/weapon01", {
	item_type = "weapon",
	spells = {
		matter_astral = "void_chain",
		matter_energy = "void_burst",
		matter_matter = "void_shield",
	},
	abilities = {
		void_chain = {
			animation = "attack_chainlightning_idle",
			Duration = 6,
			mode = "infinite",
			ui_info = {
				material = "void_chain_icon",
				type = "special",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 4,
			},
			on_enter = {
				flow_event = "ability_chain_idle_enter",
			},
			on_exit = {
				animation_event = "cast_done",
				flow_event = "ability_chain_idle_exit",
			},
			events = {
				{
					behind_wall_test = true,
					damage_amount = 1,
					event_start = 3,
					hit_react = "burning_hit",
					refresh_hitlist_time = 2.1,
					type = "box",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 3.5,
						y = 3.5,
						z = 0,
					},
					status_effects = {
						slowed = {
							duration = 0.6,
							speed_modifier = -0.8,
						},
					},
				},
			},
		},
		void_burst = {
			animation = "attack_barrage",
			disable_target_alignment = true,
			duration = 15,
			cooldown = {
				duration = 240,
				time = 5,
			},
			ui_info = {
				material = "void_burst_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_burst_windup",
			},
			on_exit = {
				flow_event = "ability_burst_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 3,
			},
			events = {
				{
					damage_amount = 0,
					damage_hit_delay = 4,
					damage_type = "lightning",
					event_duration = 4,
					event_start = 0,
					hit_react = "vacuum",
					inherit_from = "nil",
					on_enter_flow = "ability_burst_fire",
					radius = 8,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					status_effects = {
						slowed = {
							duration = 5,
							speed_modifier = -0.7,
						},
					},
				},
			},
			buffer_to = {
				custom = 15,
			},
			cancel_to = {
				custom = 20,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
		},
		void_shield = {
			animation = "attack_staticfield",
			cancel_status_effects = false,
			duration = 5,
			ui_info = {
				material = "void_shield_icon",
				type = "special",
			},
			cooldown = {
				duration = 360,
				time = 3,
			},
			override_movespeed = {
				speed = 3,
			},
			on_enter = {
				flow_event = "ability_shield_windup",
			},
			on_exit = {
				flow_event = "ability_shield_done",
			},
			flow_events = {
				{
					event_name = "ability_shield_fire",
					time = 3,
				},
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			events = {
				{
					event_duration = 1,
					event_start = 1,
					target_type = "self",
					target_predicates = {
						closure(StateAux.predicate_has_component, "avatar"),
					},
					status_effects = {
						invisible = {
							duration = 5.5,
						},
					},
				},
			},
		},
	},
})
