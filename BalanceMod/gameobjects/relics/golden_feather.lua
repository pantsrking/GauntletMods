-- chunkname: @gameobjects/relics/golden_feather.lua

local function predicate_can_turn_to_gold(component, unit, context, target_unit)
	local settings = LuaSettingsManager:get_settings_by_unit(target_unit)

	return settings.golden_feather_unit ~= nil
end

local t = {
	icon = "item_golden_feather",
	item_id = "relic_golden_feather",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "golden_feather_1",
				type = "relic_1",
			},
			{
				to = "golden_feather_2",
				type = "relic_2",
			},
			{
				to = "golden_feather_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		execute_transform = {
			duration = 10,
			events = {
				{
					event_duration = 5,
					event_start = 1,
					unit_path = "relic_effects",
					on_effect_unit_spawned = function (event_handler, event)
						Unit.set_flow_variable(event.unit, "target", event.target_unit)
						Unit.flow_event(event.unit, "golden_feather_transform")
					end,
					on_exit_custom = function (event_handler, event)
						local target_unit = event.target_unit

						if not DamageReceiverComponent.is_alive(target_unit) then
							return
						end

						local unit = event.owner_unit

						if not EntityAux.owned(unit) then
							return
						end

						local position = Unit.world_position(target_unit, 0)
						local rotation = Unit.world_rotation(target_unit, 0)
						local target_settings = LuaSettingsManager:get_settings_by_unit(target_unit)
						local unit_path = target_settings.golden_feather_unit
						local entity = event_handler.entity_spawner:spawn_entity(unit_path, position, rotation)

						NetworkUnitSynchronizer:add(entity)

						local component = event_handler.ability_component

						if EntityAux.owned(target_unit) then
							component.entity_spawner:despawn_entity(target_unit)
						else
							Unit.set_unit_visibility(target_unit, false)
							component:trigger_rpc_event_to(EntityAux.owner(target_unit), "rpc_destroy_entity_request", target_unit)
						end
					end,
				},
			},
		},
		selet_target_event = {
			event_data = true,
			event_duration = 5,
			event_start = 1,
			flow_event_effect_unit_spawned = "golden_feather_start",
			target_range = 6,
			target_type = "allies",
			unit_path = "relic_effects",
			target_broadphase = InteractableComponent.BROADPHASE_ID,
			target_predicates = {
				predicate_can_turn_to_gold,
			},
			on_valid_hit = {
				ability = "execute_transform",
				broadcast_ability = true,
				use_last_hit_as_target = true,
			},
		},
		golden_feather_1 = {
			cooldown = 600,
			duration = 5,
			ignore_aim_direction = true,
			set_as_busy = false,
			on_cooldowned = {
				timpani_event = "relic_golden_feather_reset",
			},
			ui_info = {
				type = "relic",
			},
			flow_events = {
				{
					event_name = "on_relic_activate",
					time = 0,
				},
			},
			events = {
				{
					inherit_from = "selet_target_event",
				},
			},
		},
		golden_feather_2 = {
			inherit_from = "golden_feather_1",
			events = {
				{
					inherit_from = "selet_target_event",
				},
			},
		},
		golden_feather_3 = {
			cooldown = 300,
			inherit_from = "golden_feather_2",
			events = {
				{
					event_duration = 1,
					event_start = 1,
					target_type = "allies",
					target_predicates = {
						closure(StateAux.predicate_has_component, "avatar"),
					},
					status_effects = {
						swiftness = {
							duration = 10,
							speed_modifier = 0.3,
						},
					},
				},
				{
					inherit_from = "selet_target_event",
				},
			},
		},
	},
}

return t
