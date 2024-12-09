-- chunkname: @characters/relic_gargoyle/relic_gargoyle.lua

local LIFETIME = 200
local DAMAGE = 25
local t = SettingsAux.override_settings("characters/demon_base", {
	animation_driven_movement = false,
	blood_effect_node = "j_collarbone",
	bloodtype = "red",
	discovery_disabled = true,
	enemy_type = "demon_imp",
	global_ability_cooldown = 0.25,
	hitpoints = 100,
	instakill_on = "nil",
	is_ranged_attacker = true,
	movespeed = 4,
	movespeed_0_to_100_duration = 3,
	name = "loc_enemy_demon_imp",
	preferred_distance_max = 11,
	preferred_distance_min = 2,
	refresh_target_time = 0.25,
	faction = {
		"good",
	},
	scale_info = {
		scale = 1.5,
		variation = 0.05,
	},
	hit_reacts = require("characters/hit_reacts_elite"),
	spawn_info = {
		default = {
			animation = "awaken",
			duration = 30,
			flow_event_dormant = "spawn_windup",
			flow_event_wakeup = "spawn_appear",
			invincibility_duration = 40,
			wakeup_delay = 15,
		},
		dive = {
			animation = "spawn_dive",
			duration = 70,
			flow_event_wakeup = "spawn_dive",
			invincibility_duration = 70,
			wakeup_delay = 0,
		},
	},
	ability_selection = {
		demon_bolt = {
			cooldown = 1,
			max_distance = 15,
			min_distance = 0.1,
			weight = 1,
		},
	},
	abilities = {
		spawn = {
			duration = 50,
			events = {
				{
					damage_amount = 0,
					damage_type = "lightning",
					effect_type = "axe",
					event_duration = 1,
					event_start = 23,
					friendly_fire = false,
					hit_react = "thrust",
					radius = 4,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
		demon_bolt = {
			animation = "attack_normal",
			duration = 15,
			rotation_lock_start = 10,
			on_enter = {
				flow_event = "ability_bolt_windup",
			},
			events = {
				{
					angle = 0,
					damage_type = "pierce",
					effect_type = "arrow",
					event_start = 10,
					execute = true,
					friendly_fire = false,
					hit_react = "fire_bolt",
					max_distance = 16,
					radius = 0.25,
					speed = 30,
					stagger_origin_type = "direction",
					type = "projectile",
					unit_path = "characters/relic_gargoyle/abilities/demonbolt",
					damage_amount = DAMAGE,
					origin = {
						x = 0,
						y = 1,
						z = 0,
					},
				},
			},
		},
	},
	gibs = {
		split_vertical = {
			{
				amount = 1,
				node = "root",
				unit_path = "characters/relic_gargoyle/gibs/gib_split_vertical",
			},
		},
		split_horizontal = {
			{
				amount = 1,
				node = "root",
				unit_path = "characters/relic_gargoyle/gibs/gib_split_horizontal",
			},
		},
		exploded = {
			{
				amount = 1,
				node = "j_head",
				pitch = 0,
				pitch_variation = 180,
				power = 10,
				power_variation = 15,
				unit_path = "characters/relic_gargoyle/gibs/gib_head",
				yaw = 0,
				yaw_variation = 180,
			},
			{
				amount = 10,
				node = "j_hips",
				pitch = 90,
				pitch_variation = 40,
				power = 5,
				power_variation = 25,
				unit_path = "gib_generic",
				yaw = 0,
				yaw_variation = 180,
			},
		},
		decapitated = {
			{
				amount = 1,
				node = "root",
				unit_path = "characters/relic_gargoyle/gibs/gib_headless",
			},
			{
				amount = 1,
				node = "j_head",
				pitch = 120,
				pitch_variation = 20,
				power = 20,
				power_variation = 1,
				unit_path = "characters/relic_gargoyle/gibs/gib_head",
				yaw = 0,
				yaw_variation = 20,
			},
		},
	},
})

t.on_created_by_ability = function (unit, parent_ability)
	if EntityAux.owned(unit) then
		local stat_creditor_go_id = AbilityAux.get_stat_creditor_go_id(parent_ability.owner_unit)

		Unit.set_data(unit, "stat_creditor_go_id", stat_creditor_go_id)
	end
end

t.on_entity_registered = function (unit)
	if EntityAux.owned(unit) then
		local command = TempTableFactory:get_map("ability_name", "spawn", "ability_event_listeners", nil)

		EntityAux.queue_command_master(unit, "ability", "execute_ability", command)

		local time_in_seconds = LIFETIME

		Game.scheduler:delay_action(time_in_seconds, function ()
			if Unit.alive(unit) then
				Unit.flow_event(unit, "despawn")
			end
		end)
	end
end

t.states = function (component)
	local cache_component_states = closure(StateCommon.cache_component_states, component)

	return StateCommonBuilder.build_default(component, {
		battle = {
			on_enter = {},
			pre_transitions = {
				{
					action = closure(StateCommon.compulsory_checks, component),
				},
			},
			update = {
				closure(StateCommon.select_target_player, component),
				closure(StateCommon.move_towards_target_advanced, component),
			},
			post_transitions = {
				{
					action = closure(StateCommon.has_lost_target, component),
				},
				{
					next_state = "attack",
					action = closure(StateCommon.select_random_ability, component),
				},
			},
			on_exit = {
				closure(StateCommon.move_towards_target_exit, component),
			},
		},
		attack = {
			on_enter = {
				closure(StateCommon.attack_enter_owned, component),
			},
			pre_transitions = {
				{
					action = closure(StateCommon.compulsory_checks, component),
				},
			},
			update = {
				closure(StateCommon.rotate_towards_target, component),
			},
			post_transitions = {
				{
					next_state = "select_action",
					action = closure(StateCommon.attack_update, component),
				},
			},
			on_exit = {},
		},
	}, t.start_state), cache_component_states
end

return t
