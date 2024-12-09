-- chunkname: @equipment/elf/talisman01.lua
local CONJURE_DURATION = 30
local DAMAGE_ARROW = 330
local DAMAGE_BLAST = 34
local t = {
	icon = "elf_ultimate_01",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "ultrashot",
				type = "talisman",
			},
		},
	},
	abilities = {
		ultrashot = {
			allow_elf_special = false,
			disable_target_alignment = true,
			duration = 30,
			ignore_aim_direction = true,
			ignore_shock = true,
			animation_events = {
				{
					event_name = "ultimate_hypersniper",
					time = 1,
				},
			},
			override_movespeed = {
				speed = 1.5,
				rotation_speed = 0.2 * math.pi,
			},
			invincibilities = {
				{
					window = {
						0,
					CONJURE_DURATION,
					},
				},
			},
			on_enter = {
				flow_event = "ultimate_hypersniper_windup",
			},
			events = {
				{
					angle = 0,
					behind_wall_test = true,
					collision_filter = "damageable_and_wall",
					damage_despite_blocking = true,
					damage_hit_delay = 1,
					event_duration = 1,
					event_start = 21,
					execute = true,
					head_shot = true,
					hit_react = "smash",
					on_enter_flow = "ultimate_hypersniper_fire",
					power = 1000,
					radius = 0.5,
					speed = 200,
					stagger_origin_type = "direction",
					type = "projectile",
					unit_path = "ultimate_hypersniper",
					damage_amount = DAMAGE_ARROW,
					ignore_block = {
						damage_receiver = true,
					},
					origin = {
						x = 0,
						y = 0.5,
						z = -0.1,
					},
				},
				{
					damage_hit_delay = 2,
					event_duration = 1,
					event_start = 21,
					hit_react = "shockwave",
					radius = 3,
					type = "sphere",
					damage_amount = DAMAGE_BLAST,
					origin = {
						x = 0,
						y = 3,
						z = 0,
					},
				},
			},
			buffer_to = {
				heavy = 0,
				light = 0,
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
	},
}

return t
