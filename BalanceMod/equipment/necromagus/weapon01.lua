-- chunkname: @equipment/necromagus/weapon01.lua

local DAMAGE_LIGHT = 6
local DAMAGE_GHOSTWALK = 3
local t = {
	item_type = "weapon",
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
		default_data = {
			ability_data = true,
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
			},
		},
		seeker_data = {
			ability_data = true,
			duration = 20,
			inherit_from = "default_data",
			events = {
				{
					angle = 0,
					collision_filter = "damageable_and_wall",
					event_duration = 1,
					event_start = 2,
					max_distance = 4,
					speed = 50,
					tick_frequency = 60,
					type = "projectile_grounded",
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
					on_event_complete = {
						ability = "strike_left",
					},
				},
			},
			buffer_to = {
				heavy = 8,
				light = 8,
			},
			cancel_to = {
				defense = 0,
				heavy = 11,
				interact = 11,
				light = 11,
				navigation = 12,
			},
		},
		seeker_left = {
			animation = "attack_left",
			inherit_from = "seeker_data",
			events = {
				{
					on_event_complete = {
						ability = "strike_left",
					},
				},
			},
			combo_transitions = {
				{
					to = "seeker_right",
					type = "light",
				},
			},
		},
		seeker_right = {
			animation = "attack_right",
			inherit_from = "seeker_data",
			events = {
				{
					on_event_complete = {
						ability = "strike_right",
					},
				},
			},
			combo_transitions = {
				{
					to = "seeker_left",
					type = "light",
				},
			},
		},
		light_template = {
			disable_target_alignment = true,
			duration = 20,
			inherit_from = "default_data",
			events = {
				{
					behind_wall_test = true,
					break_food = true,
					damage_type = "slash",
					effect_type = "axe",
					event_duration = 5,
					event_start = 6,
					stagger_origin_type = "character",
					type = "box_sweep",
					damage_amount = DAMAGE_LIGHT,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 1.4,
						y = 1.4,
						z = 0.5,
					},
				},
			},
			spawn_units = {
				{
					time = 1,
					unit_path = "skeleton_light",
					position_offset = {
						x = 0,
						y = -1,
						z = -1,
					},
					custom_callback = function (spawn_info, ability_component, unit, spawned_unit)
						Unit.animation_event(spawned_unit, spawn_info.animation)
						Unit.flow_event(spawned_unit, spawn_info.flow_event)
					end,
				},
			},
			buffer_to = {
				heavy = 8,
				light = 8,
			},
			cancel_to = {
				defense = 0,
				heavy = 11,
				interact = 11,
				light = 11,
				navigation = 12,
			},
		},
		strike_left = {
			inherit_from = "light_template",
			flow_events = {
				{
					event_name = "ability_attack_light",
					time = 8,
				},
			},
			events = {
				{
					hit_react = "slash_left",
				},
			},
			spawn_units = {
				{
					animation = "spawn_attack_left",
					flow_event = "slash_left",
				},
			},
		},
		strike_right = {
			inherit_from = "light_template",
			flow_events = {
				{
					event_name = "ability_attack_light",
					time = 8,
				},
			},
			events = {
				{
					hit_react = "slash_right",
				},
			},
			spawn_units = {
				{
					animation = "spawn_attack_right",
					flow_event = "slash_right",
				},
			},
		},
		try_summon_skeletons = {
			animation = "attack_heavy",
			duration = 40,
			inherit_from = "default_data",
			ui_info = {
				material = "necromagus_action_soldiers",
				type = "special",
			},
			requirement = function (unit, action)
				return SoulLeechComponent.can_summon_skeletons(unit)
			end,
			on_enter = {
				custom_callback = SoulLeechComponent.summon_skeletons,
			},
			cancel_to = {
				defense = 0,
				heavy = 22,
				interact = 20,
				light = 22,
				navigation = 24,
			},
		},
		summon_skeleton_1 = {
			duration = 15,
			ignore_interrupt = true,
			run_until_death = true,
			on_enter = {
				flow_event = "ability_summon_1",
			},
			spawn_entities = {
				{
					snap_to_grid = true,
					spawn_info_key = "default",
					time = 0,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 0,
						y = 2,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_2 = {
			inherit_from = "summon_skeleton_1",
			on_enter = {
				flow_event = "ability_summon_2",
			},
			spawn_entities = {
				{},
				{
					snap_to_grid = true,
					spawn_info_key = "default",
					time = 7,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = -1,
						y = 1.5,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_3 = {
			inherit_from = "summon_skeleton_2",
			on_enter = {
				flow_event = "ability_summon_3",
			},
			spawn_entities = {
				{},
				{},
				{
					snap_to_grid = true,
					spawn_info_key = "default",
					time = 5,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 1,
						y = 1.5,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_4 = {
			inherit_from = "summon_skeleton_3",
			on_enter = {
				flow_event = "ability_summon_4",
			},
			spawn_entities = {
				{},
				{},
				{},
				{
					snap_to_grid = true,
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = -2,
						y = 1,
						z = 0,
					},
				},
			},
		},
		summon_skeleton_5 = {
			inherit_from = "summon_skeleton_4",
			on_enter = {
				flow_event = "ability_summon_5",
			},
			spawn_entities = {
				{},
				{},
				{},
				{},
				{
					snap_to_grid = true,
					spawn_info_key = "default",
					time = 12,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 2,
						y = 1,
						z = 0,
					},
				},
			},
		},
		summon_superskeleton_5 = {
			inherit_from = "summon_skeleton_5",
			on_enter = {
				flow_event = "ability_summon_max",
			},
			spawn_entities = {
				{
					unit_path = "necromagus_summoned_soldier_armored",
				},
				{
					unit_path = "necromagus_summoned_soldier_armored",
				},
				{
					unit_path = "necromagus_summoned_soldier_armored",
				},
				{
					unit_path = "necromagus_summoned_soldier_armored",
				},
				{
					unit_path = "necromagus_summoned_soldier_armored",
				},
			},
		},
		summon_heavy = {
			animation = "attack_heavy",
			construct_target_position = true,
			cooldown = 30,
			disable_target_alignment = true,
			duration = 40,
			inherit_from = "default_data",
			on_enter = {
				flow_event = "on_summon_ranged_start",
			},
			on_exit = {
				flow_event = "on_summon_ranged_stop",
			},
			flow_events = {
				{
					event_name = "ability_attack_heavy",
					time = 5,
				},
			},
			events = {
				{
					behind_wall_test = true,
					breaker = true,
					damage_amount = 0,
					event_duration = 1,
					event_start = 3,
					hit_react = "default_hit_below",
					origin_type = "center",
					radius = 1.5,
					stagger_origin_type = "character",
					type = "sphere",
					origin = {
						x = 0,
						y = 1,
						z = 0,
					},
				},
			},
			spawn_entities = {
				{
					check_offset_against_wall = true,
					rotate_towards_target = true,
					spawn_info_key = "cleave",
					time = 0,
					unit_path = "skeleton_heavy",
					position_offset = {
						x = 0,
						y = 1,
						z = 0,
					},
				},
			},
			buffer_to = {
				heavy = 6,
				light = 6,
			},
			cancel_to = {
				defense = 0,
				heavy = 12,
				interact = 10,
				light = 12,
				navigation = 14,
			},
		},
		rush_aim = {
			animation = "attack_beam",
			disable_target_alignment = true,
			duration = -1,
			ignore_aim_direction = true,
			on_enter = {
				flow_event = "ability_rush_windup",
			},
		},
		dodge_death = {
			animation = "die",
			duration = 30,
			ignore_interrupt = true,
			ignore_shock = true,
			on_enter = {
				flow_event = "dodge_death_start",
				custom_callback = function (ability_component, unit, ability)
					if EntityAux.owned(unit) then
						local command = TempTableFactory:get_map("hidden", {
							duration = 4,
						})

						EntityAux.call_master(unit, "status_receiver", "add_status_effect", command)
					end
				end,
			},
			invincibilities = {
				{
					window = {
						0,
						60,
					},
				},
			},
			on_exit = {
				ability = "rise_again",
			},
		},
		rise_again = {
			animation = "attack_heavy",
			duration = 30,
			ignore_interrupt = true,
			ignore_shock = true,
			on_enter = {
				flow_event = "dodge_death_stop",
			},
			spawn_entities = {
				{
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = -2,
						y = 0,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = -1.5,
						y = 1.5,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 12,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 0,
						y = 2,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 1.5,
						y = 1.5,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 2,
						y = 0,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 1.5,
						y = -1.5,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 13,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = 0,
						y = -2,
						z = 0,
					},
				},
				{
					spawn_info_key = "default",
					time = 10,
					unit_path = "necromagus_summoned_soldier",
					position_offset = {
						x = -1.5,
						y = -1.5,
						z = 0,
					},
				},
			},
			events = {
				{
					behind_wall_test = true,
					breaker = true,
					event_duration = 1,
					event_start = 0,
					hit_react = "explosion",
					origin_type = "center",
					radius = 4,
					stagger_origin_type = "character",
					type = "sphere",
					damage_amount = DAMAGE_RISEAGAIN,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						30,
					},
				},
			},
		},
		tumble = {
			aim_towards_movement_keyboard = false,
			animation = "ability_dash",
			combo_end = 60,
			construct_target_position = true,
			disable_target_alignment = true,
			duration = 60,
			enemy_collisions = "disable",
			inherit_from = "default_data",
			movements_forward = "towards_target",
			rotate_towards_aim_direction = false,
			rotation_lock_start = 0,
			set_motion_max_step_down = 20,
			cooldown = {
				duration = 30,
				time = 1,
			},
			flow_events = {
				{
					event_name = "ability_levitate_start",
					time = 1,
				},
				{
					event_name = "ability_levitate_land",
					time = 15,
				},
				{
					event_name = "ability_levitate_stop",
					time = 35,
				},
			},
			on_exit = {
				flow_event = "ability_levitate_exit",
			},
			on_enter = {
				custom_callback = function (ability_component, unit, ability)
					local direction = Vector3Aux.unbox(ability.stored_forward)
					local forward = UnitAux.unit_forward(unit)
					local dash_angle = Vector3.angle_z(forward, direction)

					dash_angle = math.clamp(math.deg(dash_angle), -180, 180)

					local dash_angle_variable = Unit.animation_find_variable(unit, "dash_angle")

					Unit.animation_set_variable(unit, dash_angle_variable, dash_angle)
				end,
			},
			events = {
				{
					behind_wall_test = true,
					breaker_light = true,
					collision_filter = "damageable_only",
					damage_type = "punch",
					effect_type = "axe",
					event_duration = 20,
					event_start = 1,
					hit_react = "thrust",
					tick_frequency = 60,
					type = "box_sweep",
					damage_amount = DAMAGE_GHOSTWALK,
					origin = {
						x = 0,
						y = 0.1,
						z = 0,
					},
					half_extents = {
						x = 0.45,
						y = 0.85,
						z = 0.5,
					},
					status_effects = {
						chilled = true,
					},
					on_valid_hit = {
						custom_callback = function (ability_event_handler, event, hit)
							local caster_unit = event.caster_unit

							if EntityAux.owned(caster_unit) and hit.unit and EntityAux.has_component(hit.unit, "faction") then
								local state = EntityAux.state(hit.unit, "faction")

								if FactionComponent.is_evil(state.faction) and EntityAux.has_interface(hit.unit, "i_damage_receiver") then
									PerkManager:increment(caster_unit, "vampiric_touch", 1)
									EntityAux.queue_command_master(caster_unit, "soul_leech", "drain_soul_power")
								end
							end
						end,
					},
				},
			},
			override_mover_filters = {
				{
					filter = "level_bound_mover",
					time = 0,
				},
				{
					time = 20,
				},
			},
			movements = {
				{
					translation = 7,
					window = {
						0,
						15,
					},
				},
				{
					translation = 1.5,
					window = {
						15,
						35,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						15,
					},
				},
			},
			buffer_to = {
				defense = 30,
				heavy = 30,
				light = 30,
			},
			cancel_to = {
				defense = 25,
				heavy = 25,
				interact = 25,
				light = 25,
				navigation = 25,
			},
		},
	},
}

return t
