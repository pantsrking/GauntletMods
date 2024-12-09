-- chunkname: @gameobjects/relics/illusion_ring.lua

local ILLUSION_DURATION = 6

local function SPAWN_2_ILLUSIONS(component, unit, ability)
	local timpani_world = component.world_proxy:get_timpani_world()

	TimpaniWorld.trigger_event(timpani_world, "relic_illusion_ring_activate", unit)

	if not EntityAux.owned(unit) then
		return
	end

	local nr_illusions = 2

	for i = 1, nr_illusions do
		local player_info = PlayerManager:get_player_info_by_avatar(unit)
		local unit_path = player_info and "illusion_" .. player_info.avatar_type or Unit.get_data(unit, "unit_path")
		local position = Unit.local_position(unit, 0)

		position = QueryManager:query_position_in_hollow_disc(position, 0.5, 2, 0.5)

		local rotation = Unit.local_rotation(unit, 0)
		local illusion_unit = component.entity_spawner:spawn_entity(unit_path, position, rotation)

		EntityAux.queue_command_master_interface(illusion_unit, "i_damage_receiver", "set_invincibility", {
			id = "illusion",
			state = "on",
		})
		Unit.set_data(illusion_unit, "owner_unit", unit)

		local illusion_duration = ILLUSION_DURATION + math.random() * 0.5

		Game:delay_action(illusion_duration, function ()
			if Unit.alive(illusion_unit) then
				component.entity_spawner:despawn_entity(illusion_unit)
			end
		end)
	end
end

local function SPAWN_3_ILLUSIONS(component, unit, ability)
	local timpani_world = component.world_proxy:get_timpani_world()

	TimpaniWorld.trigger_event(timpani_world, "relic_illusion_ring_activate", unit)

	if not EntityAux.owned(unit) then
		return
	end

	local nr_illusions = 3

	for i = 1, nr_illusions do
		local player_info = PlayerManager:get_player_info_by_avatar(unit)
		local unit_path = player_info and "illusion_" .. player_info.avatar_type or Unit.get_data(unit, "unit_path")
		local position = Unit.local_position(unit, 0)

		position = QueryManager:query_position_in_hollow_disc(position, 0.5, 2, 0.5)

		local rotation = Unit.local_rotation(unit, 0)
		local illusion_unit = component.entity_spawner:spawn_entity(unit_path, position, rotation)

		EntityAux.queue_command_master_interface(illusion_unit, "i_damage_receiver", "set_invincibility", {
			id = "illusion",
			state = "on",
		})
		Unit.set_data(illusion_unit, "owner_unit", unit)

		local illusion_duration = ILLUSION_DURATION + math.random() * 0.5

		Game:delay_action(illusion_duration, function ()
			if Unit.alive(illusion_unit) then
				component.entity_spawner:despawn_entity(illusion_unit)
			end
		end)
	end
end

local t = {
	icon = "item_illusion_ring",
	item_id = "relic_illusion_ring",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "illusion_1",
				type = "relic_1",
			},
			{
				to = "illusion_2",
				type = "relic_2",
			},
			{
				to = "illusion_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		illusion_1 = {
			cooldown = 1200,
			duration = 30,
			ignore_interrupt = true,
			run_until_death = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_illusion_ring_reset",
			},
			flow_events = {
				{
					event_name = "on_relic_activate",
					time = 0,
				},
			},
			on_enter = {
				custom_callback = SPAWN_2_ILLUSIONS,
			},
		},
		illusion_2 = {
			inherit_from = "illusion_1",
			on_enter = {
				custom_callback = SPAWN_3_ILLUSIONS,
			},
		},
		illusion_3 = {
			cooldown = 1050,
			inherit_from = "illusion_2",
		},
	},
}

return t
