-- chunkname: @characters/avatar_wizard/abilities/ultimate_shield.lua

local LIFETIME = 420
local t = {
	disable_health_bar = true,
	hitpoints = 4000,
	stopping_power = -1,
	stun_on_hit = true,
	lifetime = LIFETIME,
	faction = {
		"good",
	},
	resistances = {
		all = "immune",
	},
	abilities = {
		lightning_shield = {
			duration = LIFETIME,
			events = {
				{
					breaker = true,
					collision_filter = "damageable_only",
					damage_amount = 0,
					damage_type = "lightning",
					effect_type = "none",
					event_start = 0,
					hit_react = "shockwave",
					on_enter_flow = "ability_lightning_shield_enter",
					on_exit_flow = "ability_lightning_shield_exit",
					origin_type = "center",
					radius = 3.6,
					refresh_hitlist_time = 30,
					trigger_chained_knockback_ability = false,
					type = "sphere",
					event_duration = LIFETIME,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_valid_hit = {
						custom_callback = function (event_handler, event, hit)
							local shield_unit = event.caster_unit
							local position = hit.position

							Unit.set_flow_variable(shield_unit, "hit_position", position)
							Unit.flow_event(shield_unit, "on_hit")
						end,
					},
				},
			},
		},
		lightning_shield_explode = {
			duration = 1,
			events = {
				{
					breaker = true,
					collision_filter = "damageable_only",
					damage_amount = 0,
					damage_type = "lightning",
					effect_type = "none",
					event_duration = 1,
					event_start = 0,
					hit_react = "poke",
					origin_type = "center",
					type = "box",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 3.1,
						y = 3.1,
						z = 3,
					},
				},
			},
		},
	},
}

t.on_entity_registered = function (unit)
	UnitPropertyAux.add_ref(unit, "target_hidden", "lightning_shield")
	Unit.set_data(unit, "protective_bubble", true)
end

t.on_created_by_ability = function (unit, parent_ability)
	if EntityAux.owned(unit) then
		Unit.set_data(unit, "owner_unit", parent_ability.owner_unit)
	end
end

local function active_enter(component, unit, context)
	local owner = Unit.get_data(unit, "owner_unit")
	local command = TempTableFactory:get_map("ability_name", "lightning_shield", "ability_event_listeners", nil, "owner_unit", owner)

	EntityAux.queue_command_master(unit, "ability", "execute_ability", command)

	context.state.time_to_die = _G.GAME_TIME + context.settings.lifetime / 30
end

local function active(component, unit, context, dt)
	local state = context.state
end

local function is_dead(component, unit, context)
	local state = context.state
	local ttd = state.time_to_die
	local gt = _G.GAME_TIME

	return _G.GAME_TIME >= state.time_to_die
end

local function explode(component, unit, context)
	local owner = Unit.get_data(unit, "owner_unit")
	local command = TempTableFactory:get_map("ability_name", "lightning_shield_explode", "owner_unit", owner)

	EntityAux.queue_command_master(unit, "ability", "execute_ability", command)
end

t.start_state = "setup"

t.states = function (component)
	return {
		setup = StateCommonBuilder.build_skip_state(component, "hunt"),
		hunt = {
			on_enter = {
				closure(active_enter, component),
			},
			update = {
				closure(active, component),
			},
			pre_transitions = {
				{
					next_state = "dead",
					action = closure(is_dead, component),
				},
			},
			post_transitions = {},
			on_exit = {},
		},
		dead = {
			on_enter = {
				closure(explode, component),
			},
			update = {},
			post_transitions = {},
			on_exit = {},
		},
	}
end

return t
