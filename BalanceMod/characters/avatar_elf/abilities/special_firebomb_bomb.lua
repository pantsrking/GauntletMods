-- chunkname: @characters/avatar_elf/abilities/special_firebomb_bomb.lua

local DAMAGE_VAULTSHOT = 40
local t = {
	abilities = {
		magic_bomb_explode = {
			duration = 5,
			ignore_interrupt = true,
			events = {
				{
					behind_wall_test = true,
					break_food = true,
					breaker = false,
					event_duration = 2,
					event_start = 3,
					hit_react = "spiketrap",
					ignore_rotation = true,
					on_enter_flow = "on_explode",
					origin_type = "center",
					radius = 2.7,
					stagger_origin_type = "query",
					type = "sphere",
					damage_amount = DAMAGE_VAULTSHOT,
					faction = {
						"good",
					},
					status_effects = {
						burning = true,
					},
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

t.on_created_by_ability = function (unit, parent_ability)
	if EntityAux.owned(unit) then
		local owner = parent_ability.owner_unit
		local command = TempTableFactory:get_map("ability_name", "magic_bomb_explode", "owner_unit", owner)

		EntityAux.queue_command_master(unit, "ability", "execute_ability", command)
	end
end

return t
