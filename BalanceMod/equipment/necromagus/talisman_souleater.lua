-- chunkname: @equipment/necromagus/talisman_souleater.lua

local DAMAGE = 20
local EVENT_UNIT_PATH = "ultimate_souleater"

local function ASSIGN_STORED_EVENT_UNIT(ability_event_handler, event)
	local caster_unit = event.caster_unit

	if caster_unit then
		local ability_state = EntityAux._state_raw(caster_unit, "ability")

		event.unit = ability_state.souleater_event_unit

		if not Unit.alive(event.unit) then
			local position = Unit.world_position(caster_unit, 0) + Vector3.up()
			local rotation = Unit.world_rotation(caster_unit, 0)

			event.unit = World.spawn_unit(ability_event_handler.world_proxy:get_world(), EVENT_UNIT_PATH, position, rotation)
		end

		ability_state.souleater_event_unit = event.unit
	end
end

local t = {
	icon = "necromagus_ultimate_01",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "souleater_cast",
				type = "talisman",
			},
		},
	},
	abilities = {
		souleater_jump = {
			duration = 20,
			events = {
				{
					inherit_from = "select_target_event_data",
				},
			},
		},
		projectile_event = {
			angle = 0,
			breaker = true,
			breaker_light = true,
			collision_filter = "damageable_only",
			damage_type = "ice",
			destroy_event_unit_on_caster_removed = true,
			effect_type = "spear",
			event_data = true,
			event_duration = 100,
			event_start = 0,
			execute = true,
			hit_react = "thrust",
			on_enter_flow = "ability_firebolt_fire",
			power = 1,
			radius = 0.3,
			speed = 24,
			stagger_origin_type = "direction",
			type = "projectile",
			damage_amount = DAMAGE,
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			on_enter_custom = ASSIGN_STORED_EVENT_UNIT,
		},
		projectile_with_target = {
			duration = 20,
			events = {
				{
					inherit_from = "projectile_event",
					on_valid_hit = {
						ability = "souleater_jump",
						inherit_hitlist = true,
						max_steps = 256,
					},
					on_non_valid_hit = {
						destroy_event_unit = true,
						set_event_as_done = true,
					},
				},
			},
		},
		projectile_without_target = {
			duration = 20,
			events = {
				{
					collision_filter = "nil",
					inherit_from = "projectile_event",
					max_distance = 10,
					on_event_complete = {
						destroy_event_unit = true,
					},
				},
			},
		},
		select_target_event_data = {
			event_data = true,
			event_duration = 0,
			event_start = 0,
			target_range = 20,
			target_type = "random_enemy",
			target_predicates = {
				closure(StateAux.predicate_has_component, "enemy"),
				partial(StateAux.predicate_within_range, 0, 20),
			},
			on_enter_custom = ASSIGN_STORED_EVENT_UNIT,
			on_valid_hit = {
				ability = "projectile_with_target",
				inherit_hitlist = true,
				max_steps = 256,
				use_last_hit_as_target = true,
			},
			on_non_valid_hit = {
				ability = "projectile_without_target",
			},
		},
		souleater_cast = {
			animation_driven_movement = "true",
			duration = 44,
			ignore_interrupt = true,
			target_alignment_type = "ranged",
			on_cooldowned = {
				timpani_event = "valkyrie_ability_cooldown",
			},
			animation_events = {
				{
					event_name = "windup",
					time = 1,
				},
				{
					event_name = "attack_charged",
					time = 20,
				},
			},
			flow_events = {
				{
					event_name = "on_talisman_activate",
					time = 0,
				},
				{
					event_name = "on_talisman_complete",
					time = 20,
				},
			},
			events = {
				{
					event_start = 7,
					inherit_from = "select_target_event_data",
				},
			},
			buffer_to = {
				heavy = 4,
				light = 4,
			},
			cancel_to = {
				heavy = 10,
				interact = 13,
				light = 10,
				navigation = 13,
			},
			invincibilities = {
				{
					window = {
						0,
						8,
					},
				},
			},
		},
	},
}

return t
