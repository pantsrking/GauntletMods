-- chunkname: @characters/spawner_base.lua

local t = {
	alignment_melee_radius = 1,
	big_dude = true,
	damageble_radius = 1.25,
	deflect_projectiles = true,
	disable_health_bar = false,
	enemy_type = "spawner",
	is_spawner = true,
	kill_score = 40,
	name = "loc_enemy_spawner",
	nav_grid_offset_radius = 3,
	soul_multiplier = 20,
	spawn_range = 30,
	start_spawning_delay = 0,
	stopping_power = 100,
	hitpoints = {
		200,
		275,
		350,
		425,
	},
	dynamic_blocker_extents = {
		x = 1,
		y = 1,
		z = 1,
	},
	faction = {
		"evil",
		"spawner",
	},
	resistances = {
		pierce = "resist",
		weak_shot = "resist",
	},
	healthbar_offset_world = {
		x = 0,
		y = 0,
		z = -3,
	},
	healthbar_size = {
		x = 64,
		y = 5,
	},
	target_lock_info = {
		base_radius_multiplier = 0,
		head_node = "j_head",
		head_radius_multiplier = 0.5,
		use_world_hit_position = true,
	},
	arrow_attach_joints = {
		"j_crystal",
		"j_arrow_attach_f",
		"j_arrow_attach_fl",
		"j_arrow_attach_l",
		"j_arrow_attach_b",
		"j_arrow_attach_bl",
		"j_arrow_attach_br",
		"j_arrow_attach_fr",
		"j_arrow_attach_r",
	},
	drops = {
		{
			unit_path = "gameobjects/gold/pile_large",
			weight = 1,
		},
	},
	abilities = {
		spawned = {
			duration = 15,
			events = {
				{
					can_be_blocked = false,
					damage_amount = 0,
					event_duration = 15,
					event_start = 0,
					friendly_fire = false,
					hit_react = "explosion",
					on_enter_flow = "spawn_explosion",
					origin_type = "center",
					type = "box",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 1.5,
						y = 1.5,
						z = 1.5,
					},
				},
			},
		},
	},
}

t.on_entity_registered = function (unit)
	if EntityAux.owned(unit) and EntityAux.has_component(unit, "ability") then
		local command = {
			ability_name = "spawned",
		}

		EntityAux.queue_command_master(unit, "ability", "execute_ability", command)
	end
end

return t
