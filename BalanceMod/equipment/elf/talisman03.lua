-- chunkname: @equipment/elf/talisman03.lua

local DAMAGE = 16
local t = {
	icon = "elf_ultimate_03",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "wisps_cast",
				type = "talisman",
			},
		},
	},
	abilities = {
		wisps_cast = {
			animation = "ability_talisman_02",
			cooldown = 24,
			duration = 45,
			set_as_busy = false,
			flow_events = {
				{
					event_name = "ultimate_wisps_windup",
					time = 0,
				},
			},
			events = {
				{
					angular_frequency = 1,
					behind_wall_test = "relative_caster",
					collision_filter = "damageable_only",
					damage_type = "pierce",
					event_duration = 360,
					event_start = 20,
					follow_caster = true,
					friendly_fire = false,
					hit_react = "push",
					is_dependant_on_caster = true,
					max_time = 360,
					power = 10000,
					radius = 0.6,
					refresh_hitlist_time = 10,
					stagger_origin_type = "direction",
					start_radius = 3,
					stop_radius = 3,
					type = "projectile_spiral",
					unit_path = "ultimate_wisp_projectile",
					damage_amount = DAMAGE,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					loop = {
						count = 3,
						frequency = 10,
						increments = {},
					},
				},
			},
		},
	},
}

return t
