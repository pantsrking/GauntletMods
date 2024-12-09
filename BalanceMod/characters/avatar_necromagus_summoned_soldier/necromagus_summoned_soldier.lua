-- chunkname: @characters/avatar_necromagus_summoned_soldier/necromagus_summoned_soldier.lua

local LIFETIME = 20
local DAMAGE = 6
local t = SettingsAux.override_settings("characters/enemy_base", {
	animation_driven_movement = true,
	blood_effect_node = "root",
	bloodtype = "bone",
	discovery_disabled = true,
	enemy_type = "skeleton_soldier",
	global_ability_cooldown = 0.2,
	hitpoints = 31,
	instakill_on = "nil",
	max_movespeed = 20,
	movespeed = 15,
	movespeed_0_to_100_duration = 3,
	preferred_distance_max = 2.5,
	preferred_distance_min = 0.5,
	refresh_target_time = 0.5,
	roam_speed_factor = 0.4,
	use_simple_mover = false,
	faction = {
		"good",
	},
	hit_reacts = require("characters/hit_reacts_elite"),
	animation_merge_options = {
		clock_fidelity = 0.75,
		max_drift = 0.2,
		max_start_time = 0.2,
	},
	scale_info = {
		scale = 1.05,
		variation = 0.05,
	},
	resistances = {
		poisoned = "immune",
	},
	spawn_info = {
		default = {
			animation = "awaken",
			duration = 25,
			flow_event_dormant = "spawn_generator",
			invincibility_duration = 8,
			wakeup_delay = 0,
		},
	},
	random_movespeed_range = {
		0.2,
		1,
	},
	drops = {},
	gibs = {
		decapitated = {
			{
				node = "j_head",
				pitch = 130,
				pitch_variation = 10,
				power = 15,
				power_variation = 1,
				unit_path = "gib_skull",
				yaw = 0,
				yaw_variation = 20,
			},
			{
				amount = 1,
				node = "root",
				unit_path = "characters/skeleton_soldier/gib/gib_headless",
			},
		},
		headshot = {
			{
				keep_attachment_weight = 1,
				node = "j_head",
				pitch = 180,
				pitch_variation = 0,
				power = 30,
				power_variation = 1,
				unit_path = "gib_skull_arrow",
				yaw = 0,
				yaw_variation = 0,
			},
			{
				amount = 1,
				node = "root",
				unit_path = "characters/skeleton_soldier/gib/gib_headless",
			},
		},
		exploded = {
			{
				amount = 1,
				node = "j_head",
				pitch = 130,
				pitch_variation = 10,
				power = 15,
				power_variation = 10,
				unit_path = "gib_skull_arrow",
				yaw = 0,
				yaw_variation = 20,
			},
			{
				amount = 1,
				node = "j_spine3",
				pitch = 40,
				pitch_variation = 100,
				power = 10,
				power_variation = 10,
				unit_path = "gib_ribcage",
				yaw = 90,
				yaw_variation = 90,
			},
			{
				amount = 2,
				node = "j_spine3",
				pitch = 40,
				pitch_variation = 100,
				power = 15,
				power_variation = 10,
				unit_path = "gib_bone",
				yaw = 90,
				yaw_variation = 90,
			},
			{
				amount = 2,
				node = "j_hips",
				pitch = 40,
				pitch_variation = 100,
				power = 10,
				power_variation = 10,
				unit_path = "gib_bone",
				yaw = -90,
				yaw_variation = 90,
			},
		},
		blasted = {
			{
				amount = 1,
				node = "j_head",
				pitch = 0,
				pitch_variation = 20,
				power = 20,
				power_variation = 5,
				unit_path = "gib_skull_arrow",
				yaw = 180,
				yaw_variation = 10,
			},
			{
				amount = 1,
				node = "j_spine3",
				pitch = 0,
				pitch_variation = 20,
				power = 20,
				power_variation = 5,
				unit_path = "gib_ribcage",
				yaw = 180,
				yaw_variation = 10,
			},
			{
				amount = 2,
				node = "j_spine3",
				pitch = 0,
				pitch_variation = 20,
				power = 25,
				power_variation = 5,
				unit_path = "gib_bone",
				yaw = 180,
				yaw_variation = 10,
			},
			{
				amount = 2,
				node = "j_hips",
				pitch = 0,
				pitch_variation = 20,
				power = 25,
				power_variation = 5,
				unit_path = "gib_bone",
				yaw = 180,
				yaw_variation = 10,
			},
		},
		split_vertical = {
			{
				amount = 1,
				node = "j_head",
				pitch = -100,
				pitch_variation = 10,
				power = 35,
				power_variation = 20,
				unit_path = "gib_skull_arrow",
				yaw = 0,
				yaw_variation = 20,
			},
			{
				amount = 1,
				node = "j_spine3",
				pitch = -100,
				pitch_variation = 10,
				power = 15,
				power_variation = 20,
				unit_path = "gib_ribcage",
				yaw = 0,
				yaw_variation = 10,
			},
			{
				amount = 4,
				node = "j_spine3",
				pitch = -100,
				pitch_variation = 0,
				power = 25,
				power_variation = 30,
				unit_path = "gib_bone",
				yaw = 0,
				yaw_variation = 30,
			},
			{
				amount = 4,
				node = "j_hips",
				pitch = -100,
				pitch_variation = 20,
				power = 20,
				power_variation = 30,
				unit_path = "gib_bone",
				yaw = 0,
				yaw_variation = 90,
			},
		},
	},
	ability_selection = {
		slash = {
			cooldown = 1,
			max_distance = 2.75,
			min_distance = 0,
			request_execution = true,
			weight = 1,
		},
	},
	abilities = {
		spawn = {
			duration = 5,
			events = {
				{
					damage_amount = 0,
					damage_type = "lightning",
					effect_type = "axe",
					event_duration = 1,
					event_start = 1,
					friendly_fire = false,
					hit_react = "thrust",
					radius = 2,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
		slash = {
			duration = 30,
			animation_events = {
				{
					event_name = "attack_slash_windup",
					time = 0,
				},
			},
			flow_events = {
				{
					event_name = "ability_attack",
					time = 9,
				},
			},
			events = {
				{
					damage_type = "slash",
					effect_type = "axe",
					event_duration = 1,
					event_start = 8,
					friendly_fire = false,
					hit_react = "thrust",
					type = "box",
					damage_amount = DAMAGE,
					origin = {
						x = 0,
						y = 0.5,
						z = 0,
					},
					half_extents = {
						x = 0.4,
						y = 1.1,
						z = 0.5,
					},
				},
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

		local time_in_seconds = LIFETIME - 1 + math.random() * 2

		Game.scheduler:delay_action(time_in_seconds, function ()
			if Unit.alive(unit) then
				EntityAux.call_interface(unit, "i_hit_receiver", "hit", {
					damage_amount = 99999,
					settings = {
						hit_react = "push",
					},
					modifiers = {},
					direction = Vector3Aux.box_temp(-UnitAux.unit_forward(unit)),
					position = Vector3Aux.box_temp(Unit.world_position(unit, 0)),
					random_seed = math.random() * 1000,
				})
			end
		end)
	end
end

t.states = function (component)
	local cache_component_states = closure(StateCommon.cache_component_states, component)

	return StateCommonBuilderFodder.build_default(component, {
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
