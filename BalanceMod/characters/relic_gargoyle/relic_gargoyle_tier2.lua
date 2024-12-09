-- chunkname: @characters/relic_gargoyle/relic_gargoyle_tier2.lua

local t = SettingsAux.override_settings("characters/relic_gargoyle/relic_gargoyle", {
	ability_selection = {
		demon_bolt = {
			cooldown = .8,
			max_distance = 15,
			min_distance = 0.1,
			weight = 1,
		},
	},
})

return t
