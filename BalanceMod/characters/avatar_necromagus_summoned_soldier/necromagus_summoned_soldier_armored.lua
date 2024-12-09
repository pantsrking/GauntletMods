-- chunkname: @characters/avatar_necromagus_summoned_soldier/necromagus_summoned_soldier_armored.lua

local DAMAGE = 6
local t = SettingsAux.override_settings("characters/avatar_necromagus_summoned_soldier/necromagus_summoned_soldier", {
	hitpoints = 65,
	scale_info = {
		scale = 1.1,
		variation = 0.05,
	},
	abilities = {
		slash = {
			duration = 30,
			events = {
				{
					event_duration = 1,
					event_start = 8,
					type = "box",
					damage_amount = DAMAGE,
					origin = {
						x = 0,
						y = 0.5,
						z = 0,
					},
					half_extents = {
						x = 0.4,
						y = 1.1,
						z = 0.5,
					},
				},
			},
		},
	},
})

return t
