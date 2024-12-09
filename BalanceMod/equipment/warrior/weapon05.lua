-- chunkname: @equipment/warrior/weapon05.lua
local DAMAGE_MEDIUM = 10
local AXETHROW_DAMAGE = 35
local TAUNT_DURATION = 10
local TAUNT_COMMAND = {
	duration = TAUNT_DURATION,
}
local DAMAGE_TAUNT = 15

return SettingsAux.override_settings("equipment/warrior/weapon01", {
	combo = {
		abilities = {
			custom = true,
			heavy = true,
			light = true,
			rush = true,
			rush_aim = true,
			special = true,
		},
		combo_transitions = {
			{
				to = "light1",
				type = "light",
			},
			{
				to = "axethrow",
				type = "heavy",
			},
			{
				to = "frenzy",
				type = "special",
			},
			{
				to = "rush_aim",
				type = "rush_aim",
			},
			{
				to = "rush",
				type = "rush",
			},
			{
				type = "custom",
			},
		},
	},
	abilities = {
		default_data = {
			ability_data = true,
			combo_transitions = {
				{
					to = "light1",
					type = "light",
				},
				{
					to = "axethrow",
					type = "heavy",
				},
				{
					to = "frenzy",
					type = "special",
				},
				{
					to = "rush_aim",
					type = "rush_aim",
				},
			},
		},
		light_template = {
			disable_target_alignment = true,
			duration = 70,
			inherit_from = "default_data",
			events = {
				{
					break_food = true,
					collision_filter = "damageable_and_wall",
					event_duration = 2,
					event_start = 9,
					inherit_from = "default_event_data",
					damage_amount = DAMAGE_MEDIUM,
				},
			},
			buffer_to = {
				heavy = 8,
				light = 8,
			},
			cancel_to = {
				heavy = 12,
				interact = 12,
				light = 12,
				navigation = 14,
				rush_aim = 1,
			},
			movements = {
				{
					translation = 0.8,
					window = {
						6,
						8,
					},
				},
			},
		},
		axethrow = {
			animation = "attack_throw",
			duration = 20,
			inherit_from = "default_data",
			ui_info = {
				material = "warrior_action_hacknslash",
				type = "special",
			},
			on_enter = {},
			events = {
				{
					angle = 0,
					behind_wall_test = true,
					break_block = true,
					break_food = true,
					collision_filter = "damageable_and_wall",
					damage_hit_delay = 1,
					damage_type = "slash",
					event_duration = 1,
					event_start = 10,
					head_shot = true,
					hit_react = "slash_heavy_right",
					on_enter_flow = "ability_throw_axe",
					power = 1,
					radius = 1,
					speed = 30,
					stagger_origin_type = "direction",
					tick_frequency = 60,
					type = "projectile",
					unit_path = "axe_projectile",
					damage_amount = AXETHROW_DAMAGE,
					origin = {
						x = 0,
						y = 1,
						z = -0.1,
					},
					rotation_angles = {
						x = 0,
						y = 180,
						z = 0,
					},
				},
			},
			buffer_to = {
				heavy = 6,
				light = 6,
			},
			cancel_to = {
				heavy = 17,
				interact = 13,
				light = 5,
				navigation = 14,
				rush_aim = 5,
			},
			combo_transitions = {
				{
					to = "light1",
					type = "light",
				},
				{
					to = "axethrow_lefttoright",
					type = "heavy",
				},
				{
					to = "demonic_cleave",
					type = "special",
				},
				{
					to = "rush_aim",
					type = "rush_aim",
				},
			},
			on_exit = {
				flow_event = "ability_return_axe",
			},
		},
		axethrow_lefttoright = {
			animation = "attack_throw_lefttoright",
			inherit_from = "axethrow",
			events = {
				{
					rotation_angles = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
			combo_transitions = {
				{
					to = "light1",
					type = "light",
				},
				{
					to = "axethrow",
					type = "heavy",
				},
				{
					to = "demonic_cleave",
					type = "special",
				},
				{
					to = "rush_aim",
					type = "rush_aim",
				},
			},
		},
		axe_impact = {
			duration = 30,
			events = {
				{
					behind_wall_test = true,
					collision_filter = "damageable_only",
					damage_amount = 64,
					damage_type = "slash",
					effect_type = "axe",
					event_data = true,
					event_duration = 20,
					event_start = 2,
					hit_react = "thrust",
					radius = 1,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
			},
		},
		frenzy = {
			animation = "spawn",
			duration = 10,
			cooldown = {
				duration = 180,
				time = 3,
			},
			ui_info = {
				material = "warrior_action_hacknslash",
				type = "special",
			},
			events = {
				{
					event_duration = 1,
					event_start = 1,
					target_type = "self",
				},
				{
					event_duration = 1,
					event_start = 1,
					hit_react = "slash_heavy_right",
					on_enter_flow = "ability_special_execute",
					origin_type = "center",
					radius = 6,
					type = "sphere",
					damage_amount = DAMAGE_TAUNT,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_valid_hit = {
						custom_callback = function (event_handler, event, hit)
							local hit_unit = hit.unit

							if EntityAux.has_component_master(hit_unit, "enemy") then
								TAUNT_COMMAND.target_unit = event.caster_unit

								EntityAux.call_master(hit_unit, "enemy", "set_target_unit", TAUNT_COMMAND)
							end
						end,
					},
				},
			},
		},
	},
})
