-- chunkname: @equipment/elf/weapon02.lua

local DAMAGE_PIERCING = 18
local DAMAGE_ROOTSHOT = 5
local DAMAGE_ROOTSHOT_BLAST = 34

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
				to = "root_bomb",
				type = "drop_bomb",
			},
			{
				to = "root_shot",
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
		light_shot = {},
		windup_bow = {},
		sniper_aim = {},
		sniper_shot = {
			events = {
				{
					execute = false,
					hit_react = "thrust",
					power = 10,
					unit_path = "arrow_snipershot_pierce",
					damage_amount = DAMAGE_PIERCING,
				},
			},
		},
		sniper_recovery = {},
		magic_bomb = {
			combo_end = 0,
			cooldown = 240,
			duration = 1,
			on_cooldowned = {
				timpani_event = "elf_ability_cooldown",
			},
			ui_info = {
				type = "special",
				material = function (player_info, progress)
					local material_name = "elf_action_root_bomb"
					local avatar_unit = player_info.avatar_unit

					if avatar_unit then
						local avatar_state = EntityAux.state(avatar_unit, "avatar")

						material_name = progress == 1 and avatar_state.windup_amount > 0 and "elf_action_root_shot" or "elf_action_root_bomb"
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
		root_bomb = {
			duration = 4,
			ignore_interrupt = true,
			spawn_entities = {
				{
					time = 1,
					unit_path = "special_root_bomb",
				},
			},
		},
		root_shot = {
			animation = "attack_magic",
			duration = 15,
			effect_type = "arrow_charged",
			ignore_aim_direction = true,
			inherit_from = "default_data",
			events = {
				{
					break_food = true,
					event_duration = 1,
					event_start = 2,
					hit_react = "thrust_heavy",
					inherit_from = "default_event_data",
					on_enter_flow = "ability_magicshot",
					power = 1,
					radius = 0.01,
					speed = 75,
					unit_path = "special_root_shot",
					damage_amount = DAMAGE_ROOTSHOT,
					on_event_complete = {
						ability = "root_shot_explosion",
					},
				},
			},
		},
		root_shot_explosion = {
			duration = 4,
			events = {
				{
					behind_wall_test = true,
					breaker = false,
					can_be_blocked = false,
					damage_type = "pierce",
					event_duration = 2,
					event_start = 1,
					hit_react = "spiketrap",
					stagger_origin_type = "query",
					type = "box",
					damage_amount = DAMAGE_ROOTSHOT_BLAST,
					status_effects = {
						rooted = {
							duration = 5,
						},
					},
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 2,
						y = 8,
						z = 1,
					},
				},
			},
		},
		tumble = {},
	},
})
