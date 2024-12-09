-- chunkname: @equipment/wizard/weapon02.lua

local DAMAGE_FIRE_BEAM = 3.3
local DAMAGE_FIRE_BEAM_MAX = 8
local REFRESH_FIRE_BEAM = 2
local TIME_TO_MAX_FIRE_BEAM = 8
local DAMAGE_FIRE_FLASH = 50
local DAMAGE_FIRE_ORB_BURST = 20

return SettingsAux.override_settings("equipment/wizard/weapon01", {
	item_type = "weapon",
	spells = {
		astral_astral = "sinister_beam_windup",
		astral_energy = "sinister_flash",
		astral_matter = "sinister_orb",
	},
	abilities = {
		sinister_beam_windup = {
			animation = "attack_beam_windup",
			duration = 8,
			inherit_from = "beam_windup",
			cooldown = {
				duration = 8,
				time = 8,
			},
			ui_info = {
				material = "sinister_beam_icon",
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
			combo_transitions = {
				{
					to = "sinister_beam",
					type = "end",
				},
				{
					to = "beam_cancel",
					type = "custom_released",
				},
			},
		},
		sinister_beam = {
			animation = "attack_beam",
			disable_target_alignment = true,
			duration = -1,
			ignore_aim_direction = true,
			mode = "infinite",
			override_movespeed = {
				speed = 0,
				rotation_speed = 0.14 * math.pi,
			},
			on_enter = {
				flow_event = "ability_beam_cast",
			},
			events = {
				{
					behind_wall_test = "relative_caster",
					break_food = true,
					damage_type = "fire",
					event_start = 0,
					hit_react = "poke",
					node = "root",
					radius = 2.5,
					type = "sphere",
					origin = {
						x = 0,
						y = 4,
						z = 0,
					},
					damage_amount = DAMAGE_FIRE_BEAM,
					refresh_hitlist_time = REFRESH_FIRE_BEAM,
			status_effects = {
				burning = {
						damage_per_second = 3,
						duration = 1.5,
						interval = 0.3,
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
		sinister_flash = {
			animation = "attack_iceshards",
			disable_target_alignment = true,
			duration = 21,
			cooldown = {
				duration = 150,
				time = 5,
			},
			ui_info = {
				material = "sinister_flash_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_flash_windup",
			},
			on_exit = {
				animation_event = "move",
				flow_event = "ability_flash_windup_done",
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
					break_food = true,
					damage_despite_blocking = true,
					damage_type = "fire",
					event_duration = 1,
					event_start = 5,
					hit_react = "fire_bolt",
					on_enter_flow = "ability_flash_fire",
					stagger_origin_type = "character",
					type = "box",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 3,
						y = 3.2,
						z = 2,
					},
					ignore_block = {
						status_receiver = true,
					},
					damage_amount = DAMAGE_FIRE_FLASH,
					status_effects = {
						burning = {
							damage_per_second = 4,
							duration = 4,
							interval = 0.75,
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
		sinister_orb = {
			animation = "attack_chillorb",
			duration = 30,
			inherit_from = "orb_of_winter",
			cooldown = {
				duration = 600,
				time = 15,
			},
			ui_info = {
				material = "sinister_orb_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_orb_windup",
			},
			on_exit = {
				flow_event = "ability_orb_exit",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			events = {
				{
					block_damage = 1,
					damage_amount = 0,
					damage_type = "fire",
					effect_type = "firebolt",
					event_start = 15,
					hit_react = "poke",
					max_distance = 10,
					on_enter_flow = "ability_orb_fire",
					power = 9999,
					radius = 1.5,
					speed = 10,
					unit_path = "spell_sinister_orb_projectile",
					origin = {
						x = 0,
						y = 1,
						z = 0,
					},
					on_event_complete = {
						ability = "sinister_orb_hover",
					},
					status_effects = {
						burning = {
							damage_per_second = 4,
							duration = 5,
							interval = 0.75,
						},
						chilled = "nil",
					},
				},
			},
		},
		sinister_orb_burst = {
			break_food = true,
			damage_hit_delay = 2,
			damage_type = "fire",
			event_data = true,
			event_duration = 1,
			hit_react = "poke",
			on_enter_flow = "orb_burst",
			radius = 6,
			type = "sphere",
			unit_path = "spell_sinister_orb_burst",
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			damage_amount = DAMAGE_FIRE_ORB_BURST,
		},
		sinister_orb_hover = {
			duration = 361,
			events = {
				{
					event_duration = 361,
					event_start = 1,
					unit_path = "spell_sinister_orb_hover",
				},
				{
					event_start = 0,
					inherit_from = "sinister_orb_burst",
				},
				{
					event_start = 60,
					inherit_from = "sinister_orb_burst",
				},
				{
					event_start = 120,
					inherit_from = "sinister_orb_burst",
				},
				{
					event_start = 180,
					inherit_from = "sinister_orb_burst",
				},
				{
					event_start = 240,
					inherit_from = "sinister_orb_burst",
				},
				{
					event_start = 300,
					inherit_from = "sinister_orb_burst",
				},
				{
					event_start = 360,
					inherit_from = "sinister_orb_burst",
				},
			},
		},
	},
})
