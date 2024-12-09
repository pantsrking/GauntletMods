-- chunkname: @equipment/wizard/talisman01.lua

local DAMAGE = 75
local t = {
	icon = "wizard_ultimate_01",
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
			animation = "ability_talisman_01",
			cooldown = 22,
			duration = 10,
			ignore_interrupt = true,
			run_until_death = true,
			set_as_busy = true,
			flow_events = {
				{
					event_name = "ultimate_arcaneblast_windup",
					time = 0,
				},
			},
			events = {},
			invincibilities = {
				{
					window = {
						0,
						20,
					},
				},
			},
			on_exit = {
				ability = "arcaneblast",
			},
		},
		arcaneblast = {
			duration = 20,
			ignore_interrupt = true,
			run_until_death = true,
			set_as_busy = true,
			events = {
				{
					damage_hit_delay = 2,
					event_duration = 1,
					event_start = 1,
					hit_react = "shockwave",
					on_enter_flow = "ultimate_arcaneblast_explode",
					radius = 9,
					type = "sphere",
					damage_amount = DAMAGE,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
	},
}

return t
