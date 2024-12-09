-- chunkname: @equipment/valkyrie/weapon01.lua

local function SET_SHIELD_THROWN(unit, shield_thrown)
	EntityAux.call(unit, "avatar", "set_shield_thrown", shield_thrown)
end

local function ASSIGN_STORED_EVENT_UNIT(ability_event_handler, event)
	local caster_unit = event.caster_unit

	if caster_unit then
		local ability_state = EntityAux._state_raw(caster_unit, "ability")

		event.unit = ability_state.shield_throw_event_unit

		if not Unit.alive(event.unit) then
			event.unit = World.spawn_unit(ability_event_handler.world_proxy:get_world(), event.settings.backup_unit_path)
		end

		ability_state.shield_throw_event_unit = event.unit
	end
end

local function CREATE_EVENT_UNIT(ability_event_handler, event)
	local caster_unit = event.caster_unit

	if caster_unit then
		local ability_state = EntityAux._state_raw(caster_unit, "ability")

		if not Unit.alive(ability_state.shield_throw_event_unit) then
			local position = Unit.world_position(caster_unit, 0) + Vector3.up()
			local rotation = Unit.world_rotation(caster_unit, 0)

			event.unit = World.spawn_unit(ability_event_handler.world_proxy:get_world(), event.settings.backup_unit_path, position, rotation)
			ability_state.shield_throw_event_unit = event.unit
		end
	end
end

local DAMAGE_SWORD_LIGHT = 6
local DAMAGE_SWORD_HEAVY = 30
local DAMAGE_SWORD_FINISH = 30
local DAMAGE_ROCKET_GIRL = 30
local DAMAGE_SHIELD_THROW = 70
local t = {
	item_type = "weapon",
	combo = {
		abilities = {
			defense = true,
			heavy = true,
			light = true,
			melee_blocked = true,
			special = true,
		},
		combo_transitions = {
			{
				to = "sword1",
				type = "light",
			},
			{
				to = "rocket_girl_from_idle",
				type = "heavy",
			},
			{
				to = "shield_throw",
				type = "special",
			},
			{
				to = "shield_bash",
				type = "melee_blocked",
			},
		},
	},
	abilities = {
		default_data = {
			ability_data = true,
			combo_transitions = {
				{
					to = "sword1",
					type = "light",
				},
				{
					to = "rocket_girl_from_idle",
					type = "heavy",
				},
				{
					type = "defense",
				},
			},
		},
		light_template = {
			disable_target_alignment = true,
			duration = 41,
			inherit_from = "default_data",
			flow_events = {
				{
					event_name = "ability_sword_left",
					time = 3,
				},
			},
			events = {
				{
					behind_wall_test = true,
					break_food = true,
					damage_type = "slash",
					effect_type = "axe",
					event_duration = 2,
					event_start = 5,
					stagger_origin_type = "character",
					type = "box_sweep",
					damage_amount = DAMAGE_SWORD_LIGHT,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 1.2,
						y = 1,
						z = 0.5,
					},
				},
			},
			buffer_to = {
				heavy = 3,
				light = 3,
			},
			cancel_to = {
				defense = 9,
				heavy = 9,
				interact = 10,
				light = 9,
				navigation = 10,
			},
			movements = {
				{
					translation = 0.6,
					window = {
						0,
						3,
					},
				},
			},
		},
		sword1 = {
			animation = "sword_attack_light1",
			duration = 60,
			inherit_from = "light_template",
			flow_events = {
				{
					event_name = "ability_sword_left",
					time = 5,
				},
			},
			events = {
				{
					hit_react = "slash_left",
				},
			},
			combo_transitions = {
				{
					to = "sword2",
					type = "light",
				},
			},
		},
		sword2 = {
			animation = "sword_attack_light2",
			duration = 70,
			inherit_from = "light_template",
			flow_events = {
				{
					event_name = "ability_sword_right",
					time = 5,
				},
			},
			events = {
				{
					hit_react = "slash_right",
				},
			},
			combo_transitions = {
				{
					to = "sword3",
					type = "light",
				},
			},
		},
		sword3 = {
			animation = "sword_attack_light1",
			inherit_from = "sword1",
			combo_transitions = {
				{
					to = "sword4",
					type = "light",
				},
			},
		},
		sword4 = {
			animation = "shield_bash_01",
			inherit_from = "sword2",
			flow_events = {
				{
					event_name = "ability_sword_heavy_right",
					time = 5,
				},
			},
			events = {
				{
					hit_react = "slash_heavy_right",
					damage_amount = DAMAGE_SWORD_HEAVY,
					origin = {
						x = 0,
						y = -0.2,
						z = 0,
					},
					half_extents = {
						x = 1.4,
						y = 1.1,
						z = 0.5,
					},
				},
			},
			movements = {},
			cancel_to = {
				defense = 0,
				heavy = 13,
				interact = 14,
				light = 13,
				navigation = 14,
			},
			combo_transitions = {
				{
					to = "sword5",
					type = "light",
				},
			},
		},
		sword5 = {
			inherit_from = "sword1",
			combo_transitions = {
				{
					to = "sword6",
					type = "light",
				},
			},
		},
		sword6 = {
			inherit_from = "sword2",
			combo_transitions = {
				{
					to = "sword7",
					type = "light",
				},
			},
		},
		sword7 = {
			animation = "shield_bash_02",
			duration = 55,
			inherit_from = "sword4",
			flow_events = {
				{
					event_name = "ability_sword_heavy_left",
					time = 5,
				},
			},
			events = {
				{
					hit_react = "slash_heavy_left",
					damage_amount = DAMAGE_SWORD_FINISH,
				},
			},
			movements = {
				{
					translation = 1.2,
					window = {
						0,
						3,
					},
				},
			},
			combo_transitions = {
				{
					to = "sword1",
					type = "light",
				},
			},
		},
		rocket_girl_from_idle = {
			disable_target_alignment = false,
			duration = 55,
			enemy_collisions = "disable",
			inherit_from = "default_data",
			override_mover_filter = "level_bound_mover",
			set_motion_max_step_down = 20,
			animation_events = {
				{
					event_name = "attack_spear_windup",
					time = 0,
				},
				{
					event_name = "attack_heavy1",
					time = 15,
				},
			},
			target_alignment = {
				keyboard = {
					max_angle = 1,
					radius = 1,
				},
				pad = {
					max_angle = 15,
					radius = 8,
				},
			},
			flow_events = {
				{
					event_name = "ability_spear_thrust_windup",
					time = 2,
				},
			},
			on_exit = {
				flow_event = "ability_spear_thrust_stop",
			},
			events = {
				{
					behind_wall_test = true,
					break_food = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_type = "spear",
					effect_type = "spear",
					event_duration = 8,
					event_start = 15,
					execute = true,
					hit_react = "thrust_heavy",
					on_enter_flow = "ability_spear_thrust",
					stagger_origin_type = "character",
					tick_frequency = 60,
					type = "box_sweep",
					damage_amount = DAMAGE_ROCKET_GIRL,
					origin = {
						y = 1,
						z = 0,
						x = -0,
					},
					half_extents = {
						x = 0.3,
						y = 1,
						z = 0.5,
					},
				},
			},
			movements = {
				{
					translation = -0.6,
					window = {
						9,
						15,
					},
				},
				{
					translation = 6,
					window = {
						15,
						19,
					},
				},
				{
					translation = 1,
					window = {
						27,
						43,
					},
				},
			},
			invincibilities = {
				{
					window = {
						14,
						20,
					},
				},
			},
			buffer_to = {
				heavy = 20,
				light = 20,
			},
			cooldown = {
				duration = 10,
				time = 18,
			},
			cancel_to = {
				defense = 19,
				heavy = 28,
				interact = 28,
				light = 28,
				navigation = 28,
			},
		},
		shield_throw_event = {
			angle = 0,
			backup_unit_path = "projectile_shield",
			behind_wall_test = true,
			break_food = true,
			breaker = true,
			breaker_light = true,
			damage_type = "slash",
			destroy_event_unit_on_caster_removed = true,
			effect_type = "spear",
			event_data = true,
			event_duration = 2,
			hit_react = "shockwave",
			max_distance = 6,
			max_time = 90,
			on_enter_flow = "on_shield_thrown",
			power = 1,
			radius = 0.3,
			speed = 30,
			stagger_origin_type = "direction",
			type = "projectile",
			damage_amount = DAMAGE_SHIELD_THROW,
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			query_filters = {
				only_closest = true,
			},
			on_enter_custom = ASSIGN_STORED_EVENT_UNIT,
			on_valid_hit = {
				ability = "shield_throw_find_target",
				flow_event = "shield_hit",
				inherit_hitlist = true,
				set_event_as_done = true,
				flow_variables = {
					shield_hit_position = "position",
				},
			},
			on_event_complete = {
				ability = "shield_return",
			},
		},
		shield_throw = {
			animation = "throw",
			animation_driven_movement = "true",
			duration = 44,
			effect_type = "arrow_charged",
			ignore_interrupt = true,
			inherit_from = "default_data",
			target_alignment_type = "ranged",
			cooldown = {
				duration = 180,
				time = 6,
			},
			ui_info = {
				material = "valkyrie_action_shieldthrow",
				type = "special",
			},
			on_cooldowned = {
				timpani_event = "valkyrie_ability_cooldown",
			},
			events = {
				{
					event_start = 7,
					inherit_from = "shield_throw_event",
					on_enter_flow = "ability_shield_throw",
					on_enter_custom = CREATE_EVENT_UNIT,
					on_non_valid_hit = {
						ability = "shield_cancel",
						set_event_as_done = true,
					},
				},
			},
			buffer_to = {
				heavy = 4,
				light = 4,
			},
			cancel_to = {
				heavy = 10,
				interact = 13,
				light = 10,
				navigation = 13,
			},
			invincibilities = {
				{
					window = {
						0,
						8,
					},
				},
			},
			on_enter = {
				custom_callback = function (component, unit, ability)
					SET_SHIELD_THROWN(unit, true)
				end,
			},
		},
		shield_throw_find_target = {
			duration = 1,
			events = {
				{
					backup_unit_path = "projectile_shield",
					behind_wall_test = true,
					collision_filter = "damageable_only",
					destroy_event_unit_on_caster_removed = true,
					event_duration = 1,
					event_start = 0,
					origin_type = "center",
					type = "box",
					query_filters = {
						max_angle = 225,
						only_closest = true,
					},
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 4,
						y = 4,
						z = 4,
					},
					on_enter_custom = ASSIGN_STORED_EVENT_UNIT,
					on_valid_hit = {
						ability = "shield_jump",
						inherit_hitlist = true,
						max_steps = 16,
						set_event_as_done = true,
						use_last_hit_as_target = true,
					},
					on_event_complete = {
						ability = "shield_return",
					},
				},
			},
		},
		shield_jump = {
			duration = 20,
			events = {
				{
					event_start = 0,
					inherit_from = "shield_throw_event",
					speed = 20,
				},
			},
		},
		shield_return = {
			animation = "attack_shield_bash",
			duration = 30,
			never_interrupt = true,
			events = {
				{
					backup_unit_path = "projectile_shield",
					break_food = true,
					breaker = true,
					breaker_light = true,
					damage_type = "spear",
					effect_type = "spear",
					event_duration = 1,
					event_start = 0,
					hit_react = "slash_left",
					power = 9999,
					type = "projectile_homing",
					use_caster_as_target = true,
					damage_amount = DAMAGE_SHIELD_THROW,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_enter_custom = ASSIGN_STORED_EVENT_UNIT,
					on_event_complete = {
						destroy_event_unit = true,
						custom_callback = function (event_handler, event)
							if event.unit then
								Unit.flow_event(event.unit, "on_throw_done")
							end
						end,
					},
					on_exit_custom = function (event_handler, event)
						if event.caster_unit then
							if not EntityAux._state_raw(event.caster_unit, "avatar").in_shop then
								Unit.flow_event(event.caster_unit, "ability_shield_catch")
							end

							if not DamageReceiverComponent.is_alive(event.caster_unit) then
								EntityAux.call_slave(event.caster_unit, "equipment", "drop_weapons", TempTableFactory:get_array("shield"))

								return
							end

							EntityAux.queue_command_slave(event.caster_unit, "animation", "trigger_event_local", "shield_catch")
							SET_SHIELD_THROWN(event.caster_unit, false)
						end
					end,
				},
			},
		},
		shield_cancel = {
			inherit_from = "shield_return",
			events = {
				{
					start_straight_towards_target = true,
				},
			},
		},
		shield_bash = {
			animation = "attack_shield_bash",
			duration = 18,
		},
	},
}

return t
