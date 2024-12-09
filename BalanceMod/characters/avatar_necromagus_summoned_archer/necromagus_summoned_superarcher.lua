-- chunkname: @characters/avatar_necromagus_summoned_archer/necromagus_summoned_superarcher.lua

local DAMAGE = 15
local t = SettingsAux.override_settings("characters/avatar_necromagus_summoned_archer/necromagus_summoned_archer", {
	abilities = {
		shoot_windup = {
			animation = "attack_shoot_windup",
			duration = 10,
			execute = true,
			target_type = "target_unit",
			flow_events = {},
			on_complete = {
				ability = "shoot",
			},
		},
		shoot = {
			animation = "attack_shoot",
			clear_target_unit = true,
			duration = 20,
			rotation_lock_start = 0,
			flow_events = {
				{
					event_name = "on_shoot",
					time = 0,
				},
				{
					event_name = "on_done",
					time = 30,
				},
			},
			events = {
				{
					damage_type = "pierce",
					unit_path = "necromagus_summoned_superarcher_arrow",
					damage_amount = DAMAGE,
				},
			},
		},
	},
})

return t
