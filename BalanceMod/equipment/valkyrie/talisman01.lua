-- chunkname: @equipment/valkyrie/talisman01.lua
local DAMAGE = 250
local t = {
	icon = "valkyrie_ultimate_01",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "cast",
				type = "talisman",
			},
		},
	},
	abilities = {
		cast = {
			animation = "special_spin_windup",
			cooldown = 15,
			duration = 10,
			ignore_interrupt = true,
			run_until_death = true,
			set_as_busy = true,
			flow_events = {
				{
					event_name = "ultimate_vengeance_windup",
					time = 0,
				},
				{
					event_name = "on_talisman_drawsword",
					time = 10,
				},
				{
					event_name = "on_talisman_complete",
					time = 10,
				},
			},
			events = {
				{
					behind_wall_test = false,
					break_food = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_type = "slash",
					effect_type = "axe",
					event_duration = 6,
					event_start = 8,
					execute = true,
					grow_duration = 6,
					hit_react = "slash_heavy_left",
					on_enter_flow = "ultimate_vengeance_execute",
					origin_type = "base",
					tick_frequency = 6,
					type = "box_growing",
					origin = {
						x = 0,
						y = -1.5,
						z = 0,
					},
					half_extents = {
						x = 5,
						y = 1,
						z = 2,
					},
					max_extents = {
						x = 5,
						y = 4,
						z = 2,
					},
					damage_amount = DAMAGE,
				},
			},
		},
	},
}

return t
