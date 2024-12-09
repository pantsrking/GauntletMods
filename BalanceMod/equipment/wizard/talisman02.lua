-- chunkname: @equipment/wizard/talisman02.lua

local transform_units = {
	"pile_small",
	"pile_small",
	"pile_small",
	"pile_small",
	"pile_medium",
	"pile_medium",
	"pile_medium",
	"pile_medium",
	"pile_medium",
	"pile_medium",
	"pile_medium",
	"pile_medium",
	"pile_large",
	"pile_large",
	"pile_large",
	"pile_large",
	"gameobjects/keys/small",
	"gameobjects/food/ham",
}
local t = {
	icon = "wizard_ultimate_02",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "polymorph_cast",
				type = "talisman",
			},
		},
	},
	abilities = {
		transform_event = {
			event_data = true,
			event_duration = 0,
			target_type = "target_unit",
			unit_path = "ultimate_polymorph_transform",
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
				Unit.flow_event(event.unit, "polymorph_start")
				Unit.flow_event(target_unit, "on_polymorph")
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

				Unit.flow_event(event.unit, "polymorph_stop")

				local index = math.random(1, #transform_units)
				local unit_path = transform_units[index]
				local entity = event_handler.entity_spawner:spawn_entity(unit_path, position, rotation)

				Unit.flow_event(entity, "on_dropped")
				NetworkUnitSynchronizer:add(entity)

				if EntityAux.owned(target_unit) then
					event_handler.despawner:force_despawn(target_unit)
				else
					Unit.set_unit_visibility(target_unit, false)

					local component = event_handler.ability_component

					component:trigger_rpc_event_to(EntityAux.owner(target_unit), "rpc_destroy_entity_request", target_unit)
				end
			end,
		},
		transform = {
			duration = 5,
			events = {
				{
					event_start = 0,
					inherit_from = "transform_event",
				},
			},
		},
		homing_projectile = {
			duration = 20,
			events = {
				{
					angle = 0,
					collision_filter = "damageable_only",
					damage_amount = 0,
					damage_hit_delay = 1,
					damage_type = "fire",
					effect_type = "firebolt",
					event_duration = 1,
					event_start = 3,
					hit_react = "fire_bolt",
					on_enter_flow = "ability_firebolt_fire",
					radius = 0.8,
					speed = 20,
					stagger_origin_type = "direction",
					type = "projectile_homing",
					unit_path = "ultimate_polymorph_projectile",
					origin = {
						x = 0,
						y = 0.5,
						z = 0,
					},
					start_direction = {
						x = 0,
						y = 0,
						z = 1,
					},
					on_event_complete = {
						ability = "projectile_blast",
					},
				},
			},
		},
		projectile_blast = {
			duration = 5,
			events = {
				{
					event_duration = 1,
					event_start = 1,
					hit_react = "thrust",
					radius = 4,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
				{
					event_duration = 1,
					event_start = 1,
					radius = 1.5,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_valid_hit = {
						ability = "transform",
						condition = "only_evil",
						use_last_hit_as_target = true,
						predicates = {
							StateAux.predicate_can_polymorph,
						},
					},
				},
			},
		},
		select_target_event_data = {
			event_data = true,
			event_duration = 0,
			share_hitlist = true,
			target_range = 20,
			target_type = "random_enemy",
			target_predicates = {
				StateAux.predicate_can_polymorph,
			},
			on_valid_hit = {
				ability = "homing_projectile",
				broadcast_ability = true,
				clear_last_target_from_hitlist = false,
				inherit_hitlist = true,
				node = "j_head",
				use_caster_as_origin = true,
				use_last_hit_as_target = true,
			},
		},
		polymorph_cast = {
			animation = "ability_talisman_02",
			cooldown = 60,
			duration = 35,
			set_as_busy = false,
			flow_events = {
				{
					event_name = "ultimate_polymorph_windup",
					time = 0,
				},
				{
					event_name = "ultimate_polymorph_launch",
					time = 15,
				},
			},
			events = {
				{
					event_start = 0,
					inherit_from = "select_target_event_data",
					loop = {
						count = 6,
						frequency = 6,
					},
				},
			},
		},
	},
}

return t
