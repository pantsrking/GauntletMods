-- chunkname: @equipment/elf/weapon04.lua

local DAMAGE_SHADOWSHOT = 5
local DAMAGE_SHADOWSHOT_BURN = 8

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
				to = "shadow_bomb",
				type = "drop_bomb",
			},
			{
				to = "shadow_shot",
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
			cooldown = 150,
			duration = 1,
			on_cooldowned = {
				timpani_event = "elf_ability_cooldown",
			},
			ui_info = {
				type = "special",
				material = function (player_info, progress)
					local material_name = "elf_action_shadow_bomb"
					local avatar_unit = player_info.avatar_unit

					if avatar_unit then
						local avatar_state = EntityAux.state(avatar_unit, "avatar")

						material_name = progress == 1 and avatar_state.windup_amount > 0 and "elf_action_shadow_shot" or "elf_action_shadow_bomb"
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
		shadow_bomb = {
			animation = "potion_throw",
			duration = 6,
			ignore_interrupt = true,
			events = {
				{
					event_duration = 2,
					event_start = 3,
					target_type = "self",
					unit_path = "special_shadow_bomb",
					status_effects = {
						invisible = {
							duration = 4,
						},
					},
				},
				{
					damage_amount = 10,
					event_duration = 1,
					event_start = 1,
					hit_react = "thrust",
					radius = 4,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
		shadow_shot = {
			animation = "attack_magic",
			duration = 15,
			effect_type = "arrow_charged",
			ignore_aim_direction = true,
			inherit_from = "default_data",
			events = {
				{
					event_duration = 1,
					event_start = 2,
					hit_react = "thrust_heavy",
					inherit_from = "default_event_data",
					on_enter_flow = "ability_magicshot",
					power = 1,
					radius = 0.01,
					speed = 75,
					unit_path = "special_shadow_shot",
					damage_amount = DAMAGE_SHADOWSHOT,
					status_effects = {
						slowed = {
							duration = 0.5,
							speed_modifier = -0.8,
						},
					},
					on_valid_hit = {
						ability = "shadow_burn",
						set_event_unit_as_caster = true,
						use_last_hit_as_target = true,
					},
				},
			},
		},
		shadow_burn = {
			duration = 16,
			on_enter = {
				flow_event = "burn_start",
			},
			on_exit = {
				flow_event = "burn_stop",
			},
			events = {
				{
					break_food = true,
					event_duration = 1,
					event_start = 1,
					hit_react = "poke",
					stagger_origin_type = "no_change",
					target_type = "target_unit",
					damage_amount = DAMAGE_SHADOWSHOT_BURN,
					loop = {
						count = 14,
						frequency = 1,
					},
				},
				{
					break_food = true,
					event_duration = 1,
					event_start = 15,
					hit_react = "poke",
					ignore_rotation = true,
					node = "j_attach",
					stagger_origin_type = "no_change",
					type = "box",
					damage_amount = DAMAGE_SHADOWSHOT_BURN,
					origin = {
						x = 0,
						y = 0,
						z = -0,
					},
					half_extents = {
						x = 0.2,
						y = 0.2,
						z = 2,
					},
					on_event_complete = {
						ability = "shadowburn_explosion",
					},
				},
			},
		},
		shadowburn_explosion = {
			duration = 1,
			ignore_interrupt = true,
			on_exit_flow = {
				flow_event = "remove_arrow",
			},
			events = {
				{
					damage_amount = 25,
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
	},
})
