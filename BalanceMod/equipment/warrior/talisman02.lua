-- chunkname: @equipment/warrior/talisman02.lua

local CONJURE_DURATION = 50
local GIANT_DURATION = 240
local t = {
	icon = "warrior_ultimate_02",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "conjure_moreofthor",
				type = "talisman",
			},
		},
	},
	abilities = {
		step = {
			duration = 5,
			set_as_busy = false,
			events = {
				{
					event_duration = 5,
					event_start = 0,
					hit_react = "thrust",
					origin_type = "center",
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
		conjure_moreofthor = {
			animation = "ability_talisman_02",
			cooldown = 330,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			duration = CONJURE_DURATION,
			on_cooldowned = {
				timpani_event = "relic_sirens_lute_reset",
			},
			invincibilities = {
				{
					window = {
						0,
						CONJURE_DURATION,
					},
				},
			},
			flow_events = {
				{
					event_name = "ultimate_moreofthor_windup",
					time = 1,
				},
			},
			events = {
				{
					damage_type = "ice",
					effect_type = "ice",
					event_duration = 1,
					event_start = 25,
					on_enter_flow = "ultimate_moreofthor_grow_start",
					on_enter_custom = function (event_handler, event)
						local unit = event.caster_unit

						if EntityAux.owned(unit) then
							EntityAux.call_master(unit, "scale", "set_scale", 1.65)
							Unit.set_flow_variable(unit, "grow_factor", 1)

							local temp_data = {
								play_footstep_effect = function (self, params)
									if Unit.is_a(unit, "characters/avatar_warrior/warrior") then
										local command = TempTableFactory:get_map("ability_name", "step", "settings_path", "equipment/warrior/talisman01")

										EntityAux.queue_command_master(unit, "ability", "execute_ability", command)
									end
								end,
							}
						end
					end,
				},
				{
					event_start = 47,
					on_enter_flow = "ultimate_moreofthor_potiondrop",
					radius = 0.15,
					speed_multiplier = 3,
					type = "projectile_lob",
					unit_path = "potion_discarded",
					vertical_angle = 60,
					construct_target_position = {
						distance_max = -3,
						distance_min = -3,
					},
					origin = {
						x = -0.7,
						y = 0,
						z = 2,
					},
				},
			},
			on_exit = {
				ability = "moreofthor",
			},
		},
		moreofthor = {
			enemy_collisions = "disable",
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			on_enter = {
				flow_event = "ultimate_moreofthor_grow_done",
			},
			duration = GIANT_DURATION,
			invincibilities = {
				{
					window = {
						0,
						GIANT_DURATION,
					},
				},
			},
			on_exit = {
				flow_event = "ultimate_moreofthor_shrink_start",
				custom_callback = function (component, unit, ability)
					if EntityAux.owned(unit) then
						EntityAux.call_master(unit, "scale", "set_scale", 1)
						Unit.set_flow_variable(unit, "grow_factor", 0)
					end
				end,
			},
		},
	},
}

return t
