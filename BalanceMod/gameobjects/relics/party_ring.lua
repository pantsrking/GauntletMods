-- chunkname: @gameobjects/relics/party_ring.lua

local ILLUSION_DURATION = 15
local t = {
	icon = "item_illusion_ring",
	item_id = "relic_party_ring",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "start_illusion",
				type = "relic_1",
			},
			{
				to = "start_illusion",
				type = "relic_2",
			},
			{
				to = "start_illusion",
				type = "relic_3",
			},
		},
	},
	abilities = {
		start_illusion = {
			cooldown = 900,
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
				custom_callback = function (component, unit, ability)
					local timpani_world = component.world_proxy:get_timpani_world()

					TimpaniWorld.trigger_event(timpani_world, "relic_illusion_ring_activate", unit)

					if not EntityAux.owned(unit) then
						return
					end

					local hero_table = {
						"warrior",
						"valkyrie",
						"wizard",
						"elf",
					}
					local player_info = PlayerManager:get_player_info_by_avatar(unit)

					for i, hero in ipairs(hero_table) do
						if hero ~= player_info.avatar_type then
							local unit_path = "illusion_" .. hero
							local loadout = DefaultLoadout[hero]
							local loadout_ids = {
								weapon = loadout.weapon[1].item_id,
							}
							local position = Unit.local_position(unit, 0)

							position = QueryManager:query_position_in_hollow_disc(position, 0.5, 2, 0.5)

							local rotation = Unit.local_rotation(unit, 0)
							local setup_info = {
								loadout_ids = loadout_ids,
							}
							local illusion_unit = component.entity_spawner:spawn_entity(unit_path, position, rotation, nil, setup_info)

							EntityAux.queue_command_master_interface(illusion_unit, "i_damage_receiver", "set_invincibility", {
								id = "illusion",
								state = "on",
							})
							Game:delay_action(ILLUSION_DURATION, function ()
								if Unit.alive(illusion_unit) then
									Unit.flow_event(illusion_unit, "on_ethereal_stopped")
									component.entity_spawner:despawn_entity(illusion_unit)
								end
							end)
						end
					end
				end,
			},
		},
	},
}

return t
