-- chunkname: @equipment/wizard/weapon01.lua

local DAMAGE_FIRE_BOLT = 15
local DAMAGE_FIRE_BOMB = 0
local DAMAGE_FIRE_BOMB_EXPLOSION = 40
local DAMAGE_FIRE_SERPENTS = 8
local DAMAGE_LIGHTNING_CHAIN = 18
local DAMAGE_LIGHTNING_BURST = 15
local DAMAGE_ICE_BEAM = 3.3
local REFRESH_ICE_BEAM = 2
local TIME_TO_MAX_ICE_BEAM = 1
local DAMAGE_ICE_FLASH = 0
local t = {
	item_type = "weapon",
	combo = {
		abilities = {
			custom = true,
		},
		combo_transitions = {
			{
				type = "custom",
			},
		},
	},
	abilities = {
		conjured_spell_event = {
			angle = 0,
			damage_amount = 16,
			event_data = true,
			event_duration = 1,
			event_start = 0,
			hit_react = "poke",
			max_distance = 20,
			radius = 0.2,
			speed = 25,
			stagger_origin_type = "direction",
			type = "projectile",
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
		},
		windup_generic = {
			animation = "windup",
			disable_target_alignment = true,
			duration = 18,
			ignore_aim_direction = false,
			override_movespeed = {
				speed = 6.5,
			},
			buffer_to = {
				custom_released = 0,
			},
			cancel_to = {
				custom_released = 9,
				defense = 0,
			},
		},
		beam_windup = {
			animation = "attack_beam_windup",
			duration = 15,
			inherit_from = "windup_generic",
			cooldown = {
				duration = 8,
				time = 8,
			},
			ui_info = {
				material = "ice_beam_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_beam_windup",
			},
			on_exit = {
				flow_event = "ability_beam_windup_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			events = {
				{
					event_duration = 8,
					event_start = 0,
				},
			},
			override_movespeed = {
				speed = 0,
				rotation_speed = 0.12 * math.pi,
			},
			cancel_to = {
				custom_released = 0,
			},
			combo_transitions = {
				{
					to = "beam",
					type = "end",
				},
				{
					to = "beam_cancel",
					type = "custom_released",
				},
			},
		},
		beam = {
			animation = "attack_beam",
			disable_target_alignment = true,
			duration = -1,
			ignore_aim_direction = true,
			mode = "infinite",
			on_enter = {
				flow_event = "ability_beam_cast",
			},
			override_movespeed = {
				speed = 0,
				rotation_speed = 0.12 * math.pi,
			},
			events = {
				{
					angle_end = 0,
					angle_start = 0,
					beam_effect = "effects/wep_wizard_ice_beam",
					beam_effect_hit_unit = "spell_ice_beam_hit",
					break_food = true,
					damage_type = "ice",
					event_start = 0,
					hit_react = "frost",
					length_max = 20,
					length_min = 0,
					node = "j_l_hand_attach",
					node_use_root_rotation = true,
					pass_through_damageable = false,
					type = "swipe",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_enter_custom = CommonEventsAux.beam_on_enter,
					custom_update = CommonEventsAux.beam_update,
					on_exit_custom = CommonEventsAux.beam_on_exit,
					damage_amount = DAMAGE_ICE_BEAM,
					refresh_hitlist_time = REFRESH_ICE_BEAM,
					status_effects = {
						chilled = {
							duration = 3,
							speed_modifier = -1,
						},
					},
				},
			},
			on_exit = {
				animation_event = "attack_beam_winddown",
				flow_event = "ability_beam_done",
			},
			cancel_to = {
				custom_released = 0,
			},
			combo_transitions = {
				{
					to = "",
					type = "custom_released",
				},
			},
		},
		beam_cancel = {
			animation = "attack_beam_winddown",
			duration = 1,
			on_enter = {
				flow_event = "ability_beam_cancel",
			},
			cancel_to = {
				custom = 0,
			},
			combo_transitions = {
				{
					to = "beam_windup",
					type = "custom",
				},
			},
		},
		projectile_ability_event = {
			angle = 0,
			damage_hit_delay = 1,
			event_data = true,
			event_duration = 1,
			event_start = 2,
			hit_react = "poke",
			max_distance = 18,
			power = 0,
			radius = 0.25,
			speed = 25,
			stagger_origin_type = "direction",
			type = "projectile",
			damage_amount = {
				14,
				20,
			},
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
		},
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
				material = "fire_serpents_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_serpents_cast",
			},
			on_exit = {
				flow_event = "ability_serpents_done",
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
					event_duration = 15,
					event_start = 3,
					hit_react = "fire_bolt",
					max_distance = 12,
					on_enter_flow = "ability_serpents_fire",
					origin_type = "center",
					type = "box_sweep",
					damage_amount = DAMAGE_FIRE_SERPENTS,
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
		chain_lightning_idle = {
			aim_towards_target_unit = false,
			animation = "attack_chainlightning_idle",
			mode = "infinite",
			ui_info = {
				material = "lightning_chain_icon",
				type = "special",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 4.5,
			},
			on_enter = {
				flow_event = "ability_chain_idle_enter",
				custom_callback = function (component, unit, ability)
					if EntityAux.owned(unit) then
						local ability_state = EntityAux._state_master_raw(unit, "ability")

						ability_state.chain_lightning_hitlist = {}
					end
				end,
			},
			on_exit = {
				animation_event = "cast_done",
				flow_event = "ability_chain_idle_exit",
			},
			events = {
				{
					event_start = 7,
					inherit_from = "chain_lightning_event_data",
				},
			},
		},
		chain_lightning_event_data = {
			behind_wall_test = true,
			block_damage = 1,
			break_food = true,
			collision_filter = "damageable_only",
			damage_hit_delay = 3,
			damage_type = "lightning",
			effect_type = "none",
			event_data = true,
			event_duration = 1,
			hit_react = "poke",
			node = "j_l_hand_attach",
			node_use_root_rotation = true,
			origin_type = "base",
			stagger_origin_type = "query",
			type = "box",
			wall_collision_filter = "wall_only",
			damage_amount = DAMAGE_LIGHTNING_CHAIN,
			query_filters = {
				only_closest = true,
			},
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			half_extents = {
				x = 3,
				y = 4.5,
				z = 3,
			},
			on_valid_hit = {
				ability = "chain_lightning_jump1",
				max_steps = 5,
				set_event_as_done = true,
				set_hit_unit_as_hitlist = true,
				custom_callback = function (event_handler, event, hit)
					if event.caster_unit and EntityAux.owned(event.caster_unit) then
						if EntityAux.has_component_master(event.caster_unit, "avatar") then
							local name = event.parent_ability.static_ability.name

							if name == "chain_lightning_idle" then
								local avatar_state = EntityAux._state_master_raw(event.caster_unit, "avatar")

								if not avatar_state.chainlightning_valid_hit then
									AbilityBuildingBlocks.set_cooldown(1, event_handler.ability_component, event.caster_unit, nil, event.parent_ability)
								end

								avatar_state.chainlightning_valid_hit = true
							end
						end

						local ability_state = EntityAux._state_master_raw(event.caster_unit, "ability")
						local data = ability_state.chain_lightning_hitlist

						if #data == 0 then
							event_handler.ability_component:trigger_rpc_event("rpc_span_lightning", event.caster_unit, event.caster_unit, hit.unit)
						else
							local prior_unit = data[#data]
							local hit_unit = hit.unit

							event_handler.ability_component:trigger_rpc_event("rpc_span_lightning", event.caster_unit, prior_unit, hit.unit)
						end

						ability_state.chain_lightning_hitlist[#data + 1] = hit.unit
					end
				end,
			},
		},
		chain_lightning = {
			animation = "attack_chainlightning",
			duration = 10,
			override_movespeed = {
				speed = 1.5,
			},
			on_enter = {
				custom_callback = function (component, unit, ability)
					if EntityAux.owned(unit) then
						local ability_state = EntityAux._state_master_raw(unit, "ability")

						ability_state.chain_lightning_hitlist = {}
					end
				end,
			},
			events = {
				{
					event_start = 2,
					inherit_from = "chain_lightning_event_data",
				},
			},
		},
		chain_lightning_jump1 = {
			animation = "nil",
			duration = 8,
			inherit_from = "chain_lightning",
			on_enter = "nil",
			events = {
				{
					event_start = 2,
					on_enter_flow = "ability_chain_fire",
					on_event_complete = "nil",
					on_valid_hit = {
						ability = "chain_lightning_jump2",
					},
				},
			},
		},
		chain_lightning_jump2 = {
			inherit_from = "chain_lightning_jump1",
			events = {
				{
					on_enter_flow = "ability_chain_bounce",
					on_valid_hit = {
						ability = "chain_lightning_jump3",
					},
				},
			},
		},
		chain_lightning_jump3 = {
			inherit_from = "chain_lightning_jump1",
			events = {
				{
					on_enter_flow = "ability_chain_bounce",
					on_valid_hit = {
						ability = "chain_lightning_jump3",
					},
				},
			},
		},
		ice_shards = {
			animation = "attack_iceshards",
			disable_target_alignment = true,
			duration = 25,
			cooldown = {
				duration = 115,
				time = 10,
			},
			ui_info = {
				material = "ice_flash_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_flash_windup",
			},
			on_exit = {
				animation_event = "move",
				flow_event = "ability_flash_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 1.5,
				rotation_speed = 0.6 * math.pi,
			},
			events = {
				{
					damage_despite_blocking = true,
					damage_type = "punch",
					event_duration = 1,
					event_start = 8,
					hit_react = "poke",
					on_enter_flow = "ability_flash_fire",
					stagger_origin_type = "character",
					type = "box",
					unit_path = "spell_ice_flash",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 3,
						y = 3,
						z = 2,
					},
					ignore_block = {
						status_receiver = true,
					},
					damage_amount = DAMAGE_ICE_FLASH,
					status_effects = {
						frozen = true,
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
		fire_bolt = {
			animation = "attack_firebolt",
			duration = 31,
			cooldown = {
				duration = 15,
				time = 3,
			},
			ui_info = {
				material = "fire_bolt_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_firebolt_cast",
			},
			on_exit = {
				flow_event = "ability_firebolt_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 5,
			},
			events = {
				{
					block_damage = 0,
					break_food = true,
					damage_hit_delay = 1,
					damage_type = "fire",
					effect_type = "firebolt",
					event_start = 3,
					hit_react = "fire_bolt",
					inherit_from = "projectile_ability_event",
					on_enter_flow = "ability_firebolt_fire",
					radius = 0.4,
					speed = 30,
					unit_path = "spell_fire_bolt_projectile",
					damage_amount = DAMAGE_FIRE_BOLT,
					origin = {
						x = 0,
						y = 0.5,
						z = 0,
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
		barrage_event = {
			breaker = true,
			damage_type = "lightning",
			event_data = true,
			event_duration = 4,
			stagger_origin_type = "character",
			type = "box",
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			half_extents = {
				x = 1.5,
				y = 1.5,
				z = 0.5,
			},
		},
		barrage = {
			animation = "attack_barrage",
			disable_target_alignment = true,
			duration = 5,
			cooldown = {
				duration = 30,
				time = 5,
			},
			ui_info = {
				material = "lightning_burst_icon",
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
					break_food = true,
					damage_hit_delay = 0,
					event_duration = 1,
					event_start = 4,
					hit_react = "shockwave",
					inherit_from = "barrage_event",
					on_enter_flow = "ability_burst_fire",
					damage_amount = DAMAGE_LIGHTNING_BURST,
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
		orb_of_winter = {
			animation = "attack_chillorb",
			disable_target_alignment = true,
			duration = 30,
			cooldown = {
				duration = 750,
				time = 10,
			},
			ui_info = {
				material = "ice_orb_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_orb_windup",
			},
			on_exit = {
				flow_event = "ability_orb_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 1.5,
				rotation_speed = 0.15 * math.pi,
			},
			events = {
				{
					block_damage = 1,
					damage_amount = 0,
					damage_type = "punch",
					effect_type = "firebolt",
					event_start = 10,
					hit_react = "poke",
					inherit_from = "projectile_ability_event",
					max_distance = 10,
					on_enter_flow = "ability_orb_fire",
					power = 9999,
					radius = 1.5,
					speed = 10,
					unit_path = "spell_ice_orb_projectile",
					origin = {
						x = 0,
						y = 1,
						z = 0,
					},
					on_event_complete = {
						ability = "orb_of_winter_hover",
					},
					status_effects = {
						chilled = {
							duration = 1.5,
							speed_modifier = -.9,
						},
					},
				},
			},
			buffer_to = {
				custom = 55,
			},
			cancel_to = {
				custom = 60,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
		},
		orb_of_winter_hover = {
			duration = 300,
			events = {
				{
					behind_wall_test = true,
					damage_amount = 0,
					event_duration = 300,
					event_start = 0,
					ignore_rotation = true,
					origin_type = "center",
					refresh_hitlist_time = 30,
					type = "box",
					unit_path = "spell_ice_orb_hover",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 5,
						y = 5,
						z = 1,
					},
					status_effects = {
						chilled = {
							duration = 1.5,
							speed_modifier = -.9,
						},
					},
				},
			},
		},
		fireball = {
			animation = "attack_firebomb",
			disable_target_alignment = true,
			duration = 30,
			cooldown = {
				duration = 60,
				time = 10,
			},
			ui_info = {
				material = "fire_bomb_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_bomb_windup",
			},
			on_exit = {
				flow_event = "ability_bomb_done",
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
					damage_hit_delay = 1,
					damage_type = "fire",
					effect_type = "firebolt",
					event_start = 10,
					hit_react = "poke",
					inherit_from = "projectile_ability_event",
					on_enter_flow = "ability_bomb_fire",
					power = 9999,
					radius = 0.15,
					speed_multiplier = 3,
					type = "projectile_lob",
					unit_path = "spell_fire_bomb_projectile",
					vertical_angle = 60,
					damage_amount = DAMAGE_FIRE_BOMB,
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
					break_food = true,
					breaker = true,
					damage_hit_delay = 2,
					damage_type = "fire",
					event_duration = 1,
					event_start = 0,
					hit_react = "shockwave",
					ignore_rotation = true,
					origin_type = "center",
					radius = 3,
					stagger_origin_type = "query",
					type = "sphere",
					damage_amount = DAMAGE_FIRE_BOMB_EXPLOSION,
					origin = {
						x = 0,
						y = 0,
						z = 0.75,
					},
				},
			},
		},
		lightning_shield = {
			animation = "attack_staticfield",
			disable_target_alignment = true,
			duration = 20,
			ignore_aim_direction = true,
			ui_info = {
				material = "lightning_shield_icon",
				type = "special",
			},
			cooldown = {
				duration = 600,
				time = 3,
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
			override_movespeed = {
				rotation_speed = 0,
				speed = 0,
			},
			spawn_entities = {
				{
					time = 3,
					unit_path = "spell_lightning_shield",
					position_offset = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
	},
	spells = {
		astral_astral = "beam_windup",
		astral_energy = "ice_shards",
		astral_matter = "orb_of_winter",
		energy_astral = "serpentine",
		energy_energy = "fire_bolt",
		energy_matter = "fireball",
		matter_astral = "chain_lightning_idle",
		matter_energy = "barrage",
		matter_matter = "lightning_shield",
	},
}

return t
