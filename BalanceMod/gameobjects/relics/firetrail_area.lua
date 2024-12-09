-- chunkname: @gameobjects/relics/firetrail_area.lua

local t = {
	abilities = {
		trailblazer = {
			duration = 90,
			flow_events = {
				{
					event_name = "on_expired",
					time = 90,
				},
			},
			events = {
				{
					can_be_blocked = false,
					damage_type = "fire",
					event_duration = 90,
					event_start = 0,
					friendly_fire = false,
					hit_react = "burning_hit",
					origin_type = "center",
					refresh_hitlist_time = 55,
					type = "box",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 0.75,
						y = 0.75,
						z = 0.75,
					},
					faction = {
						"good",
					},
					status_effects = {
						burning = {
							damage_per_second = 3,
							duration = 4,
							interval = 0.5,
						},
					},
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
