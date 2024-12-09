-- chunkname: @equipment/elf/weapon01.lua

local DAMAGE_LIGHT = 10
local DAMAGE_SNIPER = 25
local DAMAGE_BOMBSHOT = 40
local elf = {
	item_type = "weapon",
	combo = {
		abilities = {
			custom = true,
			defense = true,
			drop_bomb = true,
			heavy = true,
			light = true,
			magic_shot = true,
			special = true,
		},
		combo_transitions = {
			{
				to = "light_shot",
				type = "light",
			},
			{
				to = "windup_bow",
				type = "heavy",
			},
			{
				to = "drop_bomb",
				type = "drop_bomb",
			},
			{
				to = "magic_shot",
				type = "magic_shot",
			},
			{
				to = "tumble",
				type = "defense",
			},
			{
				to = "magic_bomb",
				type = "special",
			},
			{
				type = "custom",
			},
		},
	},
	abilities = {
		default_data = {
			ability_data = true,
		},
		default_event_data = {
			angle = 0,
			damage_type = "pierce",
			effect_type = "arrow",
			event_data = true,
			event_duration = 1,
			event_start = 0,
			hit_react = "poke",
			power = 1,
			radius = 0.05,
			speed = 80,
			stagger_origin_type = "direction",
			type = "projectile",
			unit_path = "arrow_light",
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
		},
		light_shot_event_data = {
			behind_wall_test = true,
			break_food = true,
			damage_hit_delay = 1,
			damage_type = "weak_shot",
			drag_coefficient = 1,
			effect_type = "arrow",
			event_data = true,
			event_duration = 1,
			event_start = 0,
			inherit_from = "default_event_data",
			max_time = 300,
			power = 1,
			radius = 0.05,
			speed_multiplier = 1.5,
			tick_frequency = 60,
			type = "projectile_lob",
			unit_path = "arrow_light",
			vertical_angle = 0,
			damage_amount = DAMAGE_LIGHT,
			construct_target_position = {
				distance_max = 11,
				distance_min = 10,
			},
			origin = {
				x = 0,
				y = 0.2,
				z = 0.4,
			},
		},
		light_shot = {
			aim_towards_target_unit = false,
			animation = "attack_light",
			duration = 15,
			events = {
				{
					angle = 0,
					inherit_from = "light_shot_event_data",
				},
			},
			override_movespeed = {
				duration = 7,
				speed = 6.5,
			},
			buffer_to = {
				defense = 0,
				heavy = 0,
				light = 5,
			},
			cancel_to = {
				defense = 0,
				heavy = 0,
				light = 7,
			},
			combo_transitions = {
				{
					to = "tumble",
					type = "defense",
				},
				{
					to = "light_shot",
					type = "light",
				},
				{
					to = "windup_bow",
					type = "heavy",
				},
			},
			on_exit = {
				custom_callback = function (component, unit, ability)
					if EntityAux.has_component_master(unit, "avatar") then
						EntityAux._state_master_raw(unit, "avatar").windup_amount = 0
					end
				end,
			},
		},
		windup_bow = {
			animation = "windup",
			cancel_status_effects = false,
			duration = 15,
			ignore_aim_direction = true,
			override_default_target_lock = "target_locking_sniper",
			override_movespeed = {
				speed = 6.5,
			},
			buffer_to = {
				heavy_released = 0,
			},
			cancel_to = {
				defense = 0,
				heavy_released = 5,
			},
			combo_transitions = {
				{
					to = "sniper_aim",
					type = "end",
				},
				{
					to = "tumble",
					type = "defense",
				},
			},
		},
		sniper_aim = {
			cancel_status_effects = false,
			duration = -1,
			ignore_aim_direction = true,
			override_default_target_lock = "target_locking_sniper",
			override_movespeed = {
				rotation_speed = 0,
				speed = 6.5,
			},
			requirement = function (unit, action)
				local state = EntityAux.state_master(unit, "avatar")

				if state then
					return state.held.elf_heavy, "sniper_shot"
				else
					return false, "sniper_shot"
				end
			end,
			cancel_to = {
				defense = 0,
				heavy_released = 0,
			},
			combo_transitions = {
				{
					to = "sniper_shot",
					type = "heavy_released",
				},
				{
					to = "tumble",
					type = "defense",
				},
			},
		},
		sniper_shot = {
			animation = "attack_charged",
			duration = 8,
			ignore_aim_direction = true,
			override_default_target_lock = "target_locking_sniper",
			events = {
				{
					behind_wall_test = true,
					break_block = true,
					break_food = true,
					collision_filter = "damageable_and_wall",
					damage_hit_delay = 1,
					event_duration = 1,
					event_start = 0,
					execute = true,
					head_shot = true,
					hit_react = "headshot",
					inherit_from = "default_event_data",
					on_enter_flow = "ability_snipershot",
					power = 1,
					radius = 0.01,
					speed = 100,
					stagger_origin_type = "direction",
					unit_path = "arrow_snipershot",
					damage_amount = DAMAGE_SNIPER,
					origin = {
						x = 0,
						y = 0.5,
						z = -0.1,
					},
				},
			},
			buffer_to = {
				heavy = 0,
				light = 0,
			},
			cancel_to = {
				defense = 0,
				heavy = 6,
				interact = 3,
				light = 9,
				navigation = 3,
			},
			override_movespeed = {
				lock_rotation = true,
			},
			combo_transitions = {
				{
					to = "light_shot",
					type = "light",
				},
				{
					to = "windup_bow",
					type = "heavy",
				},
				{
					to = "tumble",
					type = "defense",
				},
			},
			on_exit = {
				flow_event = "on_bow_unready",
				custom_callback = function (component, unit, ability)
					if EntityAux.has_component_master(unit, "avatar") then
						EntityAux._state_master_raw(unit, "avatar").windup_amount = 0
					end
				end,
			},
		},
		sniper_recovery = {
			duration = 15,
			on_enter = {
				flow_event = "on_bow_unready",
				custom_callback = function (component, unit, ability)
					if EntityAux.has_component_master(unit, "avatar") then
						EntityAux._state_master_raw(unit, "avatar").windup_amount = 0
					end
				end,
			},
			buffer_to = {
				defense = 0,
				heavy = 0,
				light = 0,
			},
			cancel_to = {
				defense = 0,
				heavy = 0,
				light = 0,
			},
			combo_transitions = {
				{
					to = "windup_bow",
					type = "heavy",
				},
				{
					to = "light_shot",
					type = "light",
				},
				{
					to = "tumble",
					type = "defense",
				},
			},
			override_movespeed = {
				lock_rotation = true,
			},
		},
		magic_bomb = {
			combo_end = 0,
			cooldown = 180,
			duration = 1,
			on_cooldowned = {
				timpani_event = "elf_ability_cooldown",
			},
			ui_info = {
				type = "special",
				material = function (player_info, progress)
					local material_name = "elf_action_explosive_bomb"
					local avatar_unit = player_info.avatar_unit

					if avatar_unit then
						local avatar_state = EntityAux.state(avatar_unit, "avatar")

						material_name = progress == 1 and avatar_state.windup_amount > 0 and "elf_action_explosiveelf_action_explosive_shot" or "elf_action_explosive_bomb"
					end

					return material_name
				end,
			},
			combo_transitions = {
				{
					backup = "drop_bomb",
					held = "heavy",
					to = "magic_shot",
					type = "end",
				},
			},
		},
		drop_bomb = {
			duration = 1,
			set_as_busy = false,
			spawn_entities = {
				{
					time = 1,
					unit_path = "special_explosive_bomb",
				},
			},
		},
		magic_shot = {
			animation = "attack_magic",
			duration = 15,
			effect_type = "arrow_charged",
			ignore_aim_direction = true,
			inherit_from = "default_data",
			events = {
				{
					behind_wall_test = true,
					break_food = false,
					damage_amount = 1,
					event_duration = 1,
					event_start = 2,
					hit_react = "thrust_heavy",
					inherit_from = "default_event_data",
					on_enter_flow = "ability_magicshot",
					power = 1,
					radius = 0.01,
					speed = 50,
					unit_path = "special_explosive_shot",
					on_event_complete = {
						ability = "bombshot_explosion",
						set_event_unit_as_caster = true,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						2,
					},
				},
			},
			buffer_to = {
				defense = 0,
				heavy = 6,
				light = 6,
			},
			cancel_to = {
				defense = 9,
				heavy = 15,
				interact = 15,
				light = 15,
				navigation = 15,
			},
			combo_transitions = {
				{
					to = "light_shot",
					type = "light",
				},
				{
					to = "windup_bow",
					type = "heavy",
				},
				{
					to = "tumble",
					type = "defense",
				},
			},
			override_movespeed = {
				lock_rotation = true,
				speed = 6.5,
			},
		},
		bombshot_explosion = {
			duration = 41,
			ignore_interrupt = true,
			inherit_from = "default_data",
			events = {
				{
					break_food = true,
					damage_hit_delay = 1,
					event_duration = 1,
					event_start = 19,
					hit_react = "explosion",
					ignore_rotation = true,
					on_enter_flow = "explode",
					origin_type = "center",
					share_hitlist = true,
					stagger_origin_type = "query",
					type = "box",
					damage_amount = DAMAGE_BOMBSHOT,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 4,
						y = 4,
						z = 5,
					},
				},
			},
		},
		tumble = {
			aim_towards_movement = true,
			animation = "tumble",
			combo_end = 30,
			disable_target_alignment = true,
			duration = 30,
			enemy_collisions = "disable",
			set_motion_max_step_down = 20,
			cooldown = {
				duration = 15,
				time = 1,
			},
			events = {
				{
					breaker_light = true,
					collision_filter = "damageable_only",
					damage_amount = 0,
					event_duration = 20,
					event_start = 1,
					hit_react = "poke",
					tick_frequency = 60,
					type = "box_sweep",
					origin = {
						x = 0,
						y = 0.1,
						z = 0,
					},
					half_extents = {
						x = 0.35,
						y = 0.65,
						z = 0.5,
					},
				},
			},
			override_mover_filters = {
				{
					filter = "level_bound_mover",
					time = 0,
				},
				{
					time = 15,
				},
			},
			movements = {
				{
					translation = 3,
					window = {
						0,
						5,
					},
				},
				{
					translation = 2,
					window = {
						5,
						10,
					},
				},
				{
					translation = 1,
					window = {
						10,
						15,
					},
				},
				{
					translation = 0.5,
					window = {
						15,
						25,
					},
				},
			},
			invincibilities = {
				{
					window = {
						0,
						10,
					},
				},
			},
			buffer_to = {
				defense = 20,
				heavy = 20,
				light = 20,
			},
			cancel_to = {
				defense = 25,
				heavy = 25,
				interact = 25,
				light = 25,
				navigation = 25,
			},
			combo_transitions = {
				{
					to = "light_shot",
					type = "light",
				},
				{
					require_held = true,
					to = "windup_bow",
					type = "heavy",
				},
				{
					to = "tumble",
					type = "defense",
				},
			},
		},
	},
}

return elf
