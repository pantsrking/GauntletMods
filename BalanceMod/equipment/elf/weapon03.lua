-- chunkname: @equipment/elf/weapon03.lua

local DAMAGE_VAULTSHOT = 30
local DAMAGE_MORTARSHOT = 100
local DAMAGE_MORTARSHOT_EXPLOSION = 10
local DAMAGE_CLUSTERBOMB = 10

return SettingsAux.override_settings("equipment/elf/weapon01", {
	combo = {
		abilities = {
			custom = true,
			defense = true,
			drop_bomb = true,
			heavy = true,
			light = true,
			magic_shot = true,
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
				to = "vault_shot",
				type = "drop_bomb",
			},
			{
				to = "mortar_shot",
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
					local material_name = "elf_action_mortar_bomb"
					local avatar_unit = player_info.avatar_unit

					if avatar_unit then
						local avatar_state = EntityAux.state(avatar_unit, "avatar")

						material_name = progress == 1 and avatar_state.windup_amount > 0 and "elf_action_mortar_shot" or "elf_action_mortar_bomb"
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
		vault_shot = {
			animation = "special_vault_shot",
			duration = 35,
			enemy_collisions = "disable",
			ignore_interrupt = true,
			override_movespeed = {
				duration = 25,
				speed = 0,
				rotation_speed = 0 * math.pi,
			},
			flow_events = {
				{
					event_name = "ability_vault",
					time = 1,
				},
				{
					event_name = "ability_vault_land",
					time = 18,
				},
			},
			spawn_entities = {
				{
					time = 7,
					unit_path = "special_firebomb_bomb",
				},
			},
			movements = {
				{
					translation = 5,
					window = {
						0,
						17,
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
			override_mover_filters = {
				{
					filter = "level_bound_mover",
					time = 0,
				},
				{
					time = 15,
				},
			},
			buffer_to = {
				defense = 12,
			},
			cancel_to = {
				defense = 18,
				light = 30,
			},
			on_exit = {
				animation_event = "move",
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
			},
		},
		mortar_shot = {
			animation = "attack_magic",
			disable_target_alignment = true,
			duration = 15,
			effect_type = "arrow_charged",
			ignore_aim_direction = true,
			inherit_from = "default_data",
			events = {
				{
					block_damage = 1,
					damage_hit_delay = 1,
					damage_type = "fire",
					effect_type = "firebolt",
					event_start = 2,
					hit_react = "poke",
					on_enter_flow = "ability_fireball_fire",
					power = 100,
					radius = 0.15,
					speed_multiplier = 3,
					type = "projectile_lob",
					unit_path = "special_firebomb_shot",
					vertical_angle = 40,
					damage_amount = DAMAGE_MORTARSHOT,
					construct_target_position = {
						distance_max = 15,
						distance_min = 15,
					},
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_event_complete = {
						ability = "mortar_shot_explosion",
						set_event_unit_as_caster = true,
					},
				},
			},
		},
		mortar_shot_explosion = {
			duration = 4,
			events = {
				{
					event_duration = 2,
					event_start = 1,
					hit_react = "explosion",
					radius = 1,
					type = "sphere",
					damage_amount = DAMAGE_MORTARSHOT_EXPLOSION,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
				{
					angle = 0,
					block_damage = 1,
					break_food = true,
					damage_hit_delay = 1,
					damage_type = "fire",
					effect_type = "firebolt",
					event_start = 1,
					hit_react = "poke",
					on_enter_flow = "ability_fireball_fire",
					power = 9999,
					radius = 0.15,
					speed_multiplier = 3,
					type = "projectile_lob",
					unit_path = "special_firebomb_shot_mini",
					vertical_angle = 60,
					construct_target_position = {
						distance_max = 5,
						distance_min = 3,
					},
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					loop = {
						count = 6,
						frequency = 0,
						increments = {
							angle = 60,
							speed_multiplier = 0.5,
						},
					},
					on_event_complete = {
						ability = "clusterbomb_explosion",
						set_event_unit_as_caster = true,
					},
				},
			},
		},
		clusterbomb_explosion = {
			duration = 4,
			events = {
				{
					break_food = true,
					event_duration = 2,
					event_start = 1,
					hit_react = "thrust",
					radius = 2,
					type = "sphere",
					damage_amount = DAMAGE_CLUSTERBOMB,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					status_effects = {
						burning = true,
					},
				},
			},
		},
	},
})
