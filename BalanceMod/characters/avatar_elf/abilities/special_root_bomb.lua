-- chunkname: @characters/avatar_elf/abilities/special_root_bomb.lua

local t = {
	abilities = {
		root_pulse_event = {
			behind_wall_test = false,
			breaker = true,
			damage_amount = 0,
			damage_hit_delay = 3,
			damage_type = "pierce",
			event_data = true,
			event_duration = 2,
			hit_react = "poke",
			ignore_rotation = true,
			on_enter_flow = "ability_root_pulse",
			origin_type = "center",
			radius = 5,
			stagger_origin_type = "query",
			type = "sphere",
			faction = {
				"good",
			},
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			status_effects = {
				rooted = {
					duration = 3,
				},
			},
		},
		magic_bomb_explode = {
			duration = 121,
			ignore_interrupt = true,
			events = {
				{
					event_start = 30,
					inherit_from = "root_pulse_event",
				},
				{
					event_start = 60,
					inherit_from = "root_pulse_event",
				},
				{
					event_start = 90,
					inherit_from = "root_pulse_event",
				},
				{
					event_start = 120,
					inherit_from = "root_pulse_event",
				},
				

			},
			on_exit = {
				flow_event = "on_expired",
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
