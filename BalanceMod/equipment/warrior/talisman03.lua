-- chunkname: @equipment/warrior/talisman03.lua

local t = {
	icon = "warrior_ultimate_03",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "polymorph",
				type = "talisman",
			},
		},
	},
	abilities = {
		transform_event = {
			event_data = true,
			event_duration = 5,
			event_start = 20,
			target_range = 5,
			target_type = "random_enemy",
			unit_path = "ultimate_hunger_transform",
			target_predicates = {
				StateAux.predicate_can_instakill,
				StateAux.predicate_can_polymorph,
			},
			on_effect_unit_spawned = function (event_handler, event)
				local unit = event.owner_unit

				if not EntityAux.owned(unit) then
					return
				end

				if not Unit.alive(event.target_unit) then
					return
				end

				local target_unit = event.target_unit

				Unit.set_flow_variable(event.unit, "caster", unit)
				Unit.set_flow_variable(event.unit, "target", target_unit)
				Unit.flow_event(event.unit, "transform_start")
			end,
			on_exit_custom = function (event_handler, event)
				local unit = event.owner_unit

				if not EntityAux.owned(unit) then
					return
				end

				if not Unit.alive(event.target_unit) then
					return
				end

				local target_unit = event.target_unit
				local position = Unit.world_position(target_unit, 0)
				local rotation = Unit.world_rotation(target_unit, 0)

				Unit.flow_event(event.unit, "transform_stop")

				local unit_path = "golden_feather_turkey"
				local entity = event_handler.entity_spawner:spawn_entity(unit_path, position, rotation)

				NetworkUnitSynchronizer:add(entity)
				event_handler.despawner:force_despawn(target_unit)
			end,
		},
		polymorph = {
			animation = "ability_talisman_03",
			cooldown = 60,
			duration = 20,
			set_as_busy = false,
			flow_events = {
				{
					event_name = "ultimate_hunger_windup",
					time = 0,
				},
				{
					event_name = "ultimate_hunger_done",
					time = 8,
				},
			},
			events = {
				{
					event_duration = 1,
					event_start = 0,
					hit_react = "thrust",
					radius = 6,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
				{
					event_start = 3,
					inherit_from = "transform_event",
					loop = {
						count = 6,
						frequency = 3,
					},
				},
			},
		},
	},
}

return t
