-- chunkname: @gameobjects/relics/swirling_vortex_trap_tier2.lua

local t = SettingsAux.override_settings("gameobjects/relics/swirling_vortex_trap", {
	abilities = {
		swirling_vortex = {
			events = {
				{},
				{
					unit_path = "relic_twister",
				},
				{
					damage_amount = 15,
					radius = 3.5,
				},
			},
		},
	},
})

return t
