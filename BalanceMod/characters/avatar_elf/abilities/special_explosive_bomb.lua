-- chunkname: @characters/avatar_elf/abilities/special_explosive_bomb.lua

local DAMAGE_EXPLOSION = 40
local t = {
	abilities = {
		magic_bomb_explode = {
			duration = 61,
			ignore_interrupt = true,
			events = {
				{
					behind_wall_test = true,
					break_food = true,
					breaker = true,
					damage_hit_delay = 3,
					event_duration = 2,
					event_start = 61,
					hit_react = "explosion",
					ignore_rotation = true,
					origin_type = "center",
					radius = 6,
					stagger_origin_type = "query",
					type = "sphere",
					damage_amount = DAMAGE_EXPLOSION,
					faction = {
						"good",
					},
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
			on_exit = {
				flow_event = "on_explode",
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
