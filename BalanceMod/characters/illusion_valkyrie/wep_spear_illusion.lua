-- chunkname: @characters/illusion_valkyrie/wep_spear_illusion.lua

local MULTIPLIER = 0.5

return SettingsAux.override_settings("equipment/valkyrie/weapon01", {
	abilities = {
		light_template = {
			events = {
				{
					damage_amount = 11 * MULTIPLIER,
				},
			},
		},
		sword1 = {
			animation = "sword_attack_light1",
			events = {
				{
					damage_amount = 11 * MULTIPLIER,
				},
			},
			on_complete = {
				ability = "sword2",
			},
		},
		sword2 = {
			animation = "sword_attack_light2",
			events = {
				{
					damage_amount = 11 * MULTIPLIER,
				},
			},
			on_complete = {
				ability = "sword3",
			},
		},
		sword3 = {
			animation = "sword_attack_light1",
			events = {
				{
					damage_amount = 11 * MULTIPLIER,
				},
			},
			on_complete = {
				ability = "sword4",
			},
		},
		sword4 = {
			animation = "shield_bash_01",
			events = {
				{
					damage_amount = 11 * MULTIPLIER,
				},
			},
			on_complete = {
				ability = "sword1",
			},
		},
		rocket_girl_from_idle = {
			blockings = "nil",
			rotation_lock_start = 0,
			events = {
				{
					execute = false,
					damage_amount = 30 * MULTIPLIER,
				},
			},
		},
	},
})
