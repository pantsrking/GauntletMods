-- chunkname: @gameobjects/relics/crystallized_chaos.lua

local t = {
	icon = "item_crystallized_chaos",
	item_id = "relic_crystallized_chaos",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "crystallized_chaos_1",
				type = "relic_1",
			},
			{
				to = "crystallized_chaos_2",
				type = "relic_2",
			},
			{
				to = "crystallized_chaos_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		teleport = {
			duration = 91,
			set_as_busy = false,
			on_enter = {
				custom_callback = function (component, unit, ability)
					local world = component.world_proxy:get_world()
					local source_effect = "effects/relic_crystalized_chaos_source"

					ability.source_fx_id = World.create_particles(world, source_effect, Unit.world_position(unit, 0))

					World.link_particles(world, ability.source_fx_id, unit, 0, Matrix4x4.from_quaternion_position(Quaternion.identity(), Vector3(0, 0, 3)), "stop")

					local destination_effect = "effects/relic_crystalized_chaos_destination"

					ability.destination_fx_id = World.create_particles(world, destination_effect, Unit.world_position(ability.target_unit, 0))

					World.link_particles(world, ability.destination_fx_id, ability.target_unit, 0, Matrix4x4.from_quaternion_position(Quaternion.identity(), Vector3(0, 0, 3)), "stop")
				end,
			},
			on_exit = {
				custom_callback = function (component, unit, ability)
					local world = component.world_proxy:get_world()

					World.destroy_particles(world, ability.destination_fx_id)
					World.destroy_particles(world, ability.source_fx_id)
				end,
			},
			events = {
				{
					damage_amount = 100,
					damage_type = "barrel_explosion",
					event_duration = 1,
					event_start = 90,
					hit_react = "crush",
					stagger_origin_type = "character",
					target_type = "target_unit",
					on_enter_custom = function (ability_event_handler, event)
						local avatar_unit = event.owner_unit

						Unit.flow_event(avatar_unit, "timejump_cast")

						if not EntityAux.owned(avatar_unit) then
							return
						end

						if not Unit.alive(event.target_unit) then
							return
						end

						local center = Unit.world_position(avatar_unit, 0)
						local jitter_position = Vector3.zero()
						local destination = Unit.world_position(event.target_unit, 0)
						local snapped_pos = QueryManager:snap_to_navgrid(destination, 1, 2, -50, 50, false) or destination

						EntityAux.queue_command_master(avatar_unit, "motion", "set_position", snapped_pos)
						EntityAux.queue_command_master(avatar_unit, "avatar", "force_state_change", "select_action")

						local ability_component = ability_event_handler.ability_component
					end,
					on_event_complete = {
						ability = "teleport_blast",
					},
				},
			},
		},
		teleport_shielded = {
			inherit_from = "teleport",
			events = {
				{},
				{
					event_duration = 1,
					event_start = 1,
					target_type = "self",
					status_effects = {
						invincible = {
							duration = 3.033333333333333,
						},
					},
				},
			},
		},
		teleport_blast = {
			duration = 5,
			on_enter = {
				custom_callback = function (component, unit, ability)
					local effect = "effects/relic_crystalized_chaos_explode"
					local world = component.world_proxy:get_world()

					ability.shielding_id = World.create_particles(world, effect, Unit.world_position(unit, 0))
				end,
			},
			events = {
				{
					damage_amount = 10,
					damage_type = "lightning",
					event_duration = 1,
					event_start = 1,
					flow_event_effect_unit_spawned = "crystallized_chaos_teleport",
					hit_react = "thrust_heavy",
					radius = 4,
					stagger_origin_type = "character",
					type = "sphere",
					unit_path = "gameobjects/relics/relic_effects",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
		crystallized_chaos_1 = {
			cooldown = 30,
			duration = 10,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_crystallized_chaos_reset",
			},
			flow_events = {
				{
					event_name = "on_relic_activate",
					time = 0,
				},
			},
			on_enter = {
				custom_callback = function (component, unit, ability)
					local world = component.world_proxy:get_world()
					local source_effect = "effects/relic_crystalized_chaos_activate"

					ability.source_fx_id = World.create_particles(world, source_effect, Unit.world_position(unit, 0))

					World.link_particles(world, ability.source_fx_id, unit, 0, Matrix4x4.from_quaternion_position(Quaternion.identity(), Vector3(0, 0, 3)), "stop")
				end,
			},
			events = {
				{
					event_duration = 0,
					event_start = 1,
					flow_event_effect_unit_spawned = "crystallized_chaos_start",
					target_range = 20,
					target_type = "random_enemy",
					unit_path = "gameobjects/relics/relic_effects",
					target_predicates = {
						closure(StateAux.predicate_has_component, "navigation"),
						StateAux.predicate_line_of_walk_to_target,
					},
					on_valid_hit = {
						ability = "teleport",
						broadcast_ability = true,
						inherit_hitlist = true,
						use_caster_as_origin = true,
						use_last_hit_as_target = true,
						custom_callback = function (event_handler, event, hit)
							AbilityBuildingBlocks.set_cooldown(30, event_handler.ability_component, event.caster_unit, nil, event.parent_ability)
						end,
					},
				},
			},
		},
		crystallized_chaos_2 = {
			inherit_from = "crystallized_chaos_1",
			events = {
				{
					on_valid_hit = {
						ability = "teleport_shielded",
					},
				},
			},
		},
		crystallized_chaos_3 = {
			inherit_from = "crystallized_chaos_2",
			events = {
				{
					on_valid_hit = {
						custom_callback = function (event_handler, event, hit)
							AbilityBuildingBlocks.set_cooldown(24, event_handler.ability_component, event.caster_unit, nil, event.parent_ability)
						end,
					},
				},
			},
		},
	},
}

return t
