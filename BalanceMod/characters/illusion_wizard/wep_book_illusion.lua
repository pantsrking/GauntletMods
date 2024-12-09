-- chunkname: @characters/illusion_wizard/wep_book_illusion.lua

local MULTIPLIER = 1
local DAMAGE_FIRE_BOLT = 20
local DAMAGE_FIRE_BOMB = 0
local DAMAGE_FIRE_BOMB_EXPLOSION = 32
local DAMAGE_FIRE_SERPENTS = 8
local DAMAGE_LIGHTNING_CHAIN = 20
local DAMAGE_LIGHTNING_BURST = 10
local DAMAGE_ICE_BEAM = 1
local DAMAGE_ICE_BEAM_MAX = 6
local REFRESH_ICE_BEAM = 2
local TIME_TO_MAX_ICE_BEAM = 8
local DAMAGE_ICE_FLASH = 0

return SettingsAux.override_settings("equipment/wizard/weapon01", {
	abilities = {
		beam = {
			events = {
				{
					damage_amount = DAMAGE_ICE_BEAM * MULTIPLIER,
				},
			},
		},
		chain_lightning = {
			events = {
				{
					damage_amount = DAMAGE_LIGHTNING_CHAIN * MULTIPLIER,
				},
			},
		},
		chain_lightning_jump1 = {
			events = {
				{
					damage_amount = DAMAGE_LIGHTNING_CHAIN * MULTIPLIER,
				},
			},
		},
		chain_lightning_jump2 = {
			events = {
				{
					damage_amount = DAMAGE_LIGHTNING_CHAIN * MULTIPLIER,
				},
			},
		},
		chain_lightning_jump3 = {
			events = {
				{
					damage_amount = DAMAGE_LIGHTNING_CHAIN * MULTIPLIER,
				},
			},
		},
		barrage = {
			events = {
				{
					damage_amount = DAMAGE_LIGHTNING_BURST * MULTIPLIER,
				},
			},
		},
		fire_bolt = {
			events = {
				{
					damage_amount = DAMAGE_FIRE_BOLT * MULTIPLIER,
				},
			},
		},
		fireball_explosion = {
			events = {
				{
					damage_amount = DAMAGE_FIRE_BOMB_EXPLOSION * MULTIPLIER,
				},
			},
		},
	},
})
