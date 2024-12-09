-- chunkname: @gameobjects/relics/firetrail_area_tier3.lua

local t = {
	abilities = {
		trailblazer = {
			duration = 300,
			flow_events = {
				{
					event_name = "on_expired",
					time = 300,
				},
			},
			events = {
				{
					event_duration = 300,
				},
			},
		},
	},
}

t.on_created_by_ability = function (unit, spawn_info)
	if EntityAux.owned(unit) then
		local command = TempTableFactory:get_map("ability_name", "trailblazer", "owner_unit", spawn_info.owner_unit)

		EntityAux.queue_command_master(unit, "ability", "execute_ability", command)
	end
end

return t
