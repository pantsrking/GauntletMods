-- chunkname: @equipment/wizard/weapon03.lua

local SERPENT_JUMP_TRANSLATION = 5
local SERPENT_JUMP_DURATION = 2
local SERPENT_JUMP_DELAY = 8
local SERPENT_JUMP_1_START = 3
local SERPENT_JUMP_1_END = SERPENT_JUMP_1_START + SERPENT_JUMP_DURATION
local SERPENT_JUMP_2_START = SERPENT_JUMP_1_END + SERPENT_JUMP_DELAY
local SERPENT_JUMP_2_END = SERPENT_JUMP_2_START + SERPENT_JUMP_DURATION
local SERPENT_JUMP_3_START = SERPENT_JUMP_2_END + SERPENT_JUMP_DELAY
local SERPENT_JUMP_3_END = SERPENT_JUMP_3_START + SERPENT_JUMP_DURATION
local DAMAGE_LIGHTNING_SERPENT_TRAVEL = 5
local DAMAGE_LIGHTNING_SERPENT_BLAST = 20
local DAMAGE_LIGHTNING_BOLT = 5
local DAMAGE_LIGHTNING_BOMB_IMPACT = 35
local DAMAGE_LIGHTNING_BOMB_FORK = 18

local function rotate_avatar_randomly(unit, rotation_min, rotation_max)
	local current_rotation = Unit.local_rotation(unit, 0)
	local rotation_diff = rotation_max - rotation_min
	local degrees = rotation_min + rotation_diff * math.random()
	local radians = math.rad(degrees)
	local random_rotation_offset = Quaternion(Vector3.up(), radians)
	local new_rotation = Quaternion.multiply(current_rotation, random_rotation_offset)

	EntityAux.queue_command_master(unit, "rotation", "set_rotation", new_rotation)
end

return SettingsAux.override_settings("equipment/wizard/weapon01", {
	item_type = "weapon",
	spells = {
		energy_astral = "storm_serpent",
		energy_energy = "storm_bolt",
		energy_matter = "storm_bomb",
	},
	abilities = {
		blast_event = {
			can_be_blocked = false,
			event_data = true,
			event_duration = 1,
			hit_react = "shockwave",
			on_enter_flow = "ability_serpents_blast",
			origin_type = "center",
			radius = 2,
			type = "sphere",
			damage_amount = DAMAGE_LIGHTNING_SERPENT_BLAST,
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
		},
		storm_serpent = {
			animation = "attack_serpentine",
			disable_target_alignment = true,
			enemy_collisions = "disable",
			inherit_from = "serpentine",
			override_mover_filter = "level_bound_mover",
			duration = SERPENT_JUMP_3_END,
			cooldown = {
				duration = 150,
				time = 3,
			},
			ui_info = {
				material = "storm_serpents_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_serpents_windup",
			},
			on_exit = {
				flow_event = "ability_serpents_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				rotation_speed = 0,
				speed = 0,
			},
			events = {
				{
					can_be_blocked = false,
					damage_type = "lightning",
					hit_react = "lightning_shock",
					on_enter_flow = "ability_serpents_fire",
					origin_type = "center",
					radius = 2,
					status_effects = "nil",
					type = "sphere",
					damage_amount = DAMAGE_LIGHTNING_SERPENT_TRAVEL,
					event_start = SERPENT_JUMP_1_START,
					event_duration = SERPENT_JUMP_3_END,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
				},
				{
					event_duration = 1,
					event_start = SERPENT_JUMP_1_START - 1,
					on_enter_custom = function (ability_event_handler, event)
						local avatar_unit = event.owner_unit

						Unit.flow_event(avatar_unit, "timejump_cast")

						if not EntityAux.owned(avatar_unit) then
							return
						end

						if not Unit.alive(avatar_unit) then
							return
						end

						rotate_avatar_randomly(avatar_unit, 23, 45)
					end,
				},
				{
					inherit_from = "blast_event",
					event_start = SERPENT_JUMP_1_END,
				},
				{
					event_duration = 1,
					event_start = SERPENT_JUMP_1_END,
					on_enter_custom = function (ability_event_handler, event)
						local avatar_unit = event.owner_unit

						Unit.flow_event(avatar_unit, "timejump_cast")

						if not EntityAux.owned(avatar_unit) then
							return
						end

						if not Unit.alive(avatar_unit) then
							return
						end

						rotate_avatar_randomly(avatar_unit, -45, -68)
					end,
				},
				{
					inherit_from = "blast_event",
					event_start = SERPENT_JUMP_2_END,
				},
				{
					event_duration = 1,
					event_start = SERPENT_JUMP_2_END,
					on_enter_custom = function (ability_event_handler, event)
						local avatar_unit = event.owner_unit

						Unit.flow_event(avatar_unit, "timejump_cast")

						if not EntityAux.owned(avatar_unit) then
							return
						end

						if not Unit.alive(avatar_unit) then
							return
						end

						rotate_avatar_randomly(avatar_unit, 45, 68)
					end,
				},
				{
					inherit_from = "blast_event",
					event_start = SERPENT_JUMP_3_END,
				},
			},
			cancel_to = {
				custom = SERPENT_JUMP_3_END,
				navigation = SERPENT_JUMP_3_END,
				interact = SERPENT_JUMP_3_END,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
			movements = {
				{
					window = {
						SERPENT_JUMP_1_START,
						SERPENT_JUMP_1_END,
					},
					translation = SERPENT_JUMP_TRANSLATION,
				},
				{
					window = {
						SERPENT_JUMP_2_START,
						SERPENT_JUMP_2_END,
					},
					translation = SERPENT_JUMP_TRANSLATION,
				},
				{
					window = {
						SERPENT_JUMP_3_START,
						SERPENT_JUMP_3_END,
					},
					translation = SERPENT_JUMP_TRANSLATION,
				},
			},
			invincibilities = {
				{
					window = {
						SERPENT_JUMP_1_START,
						SERPENT_JUMP_3_END,
					},
				},
			},
		},
		storm_bolt = {
			animation = "attack_endritch_bolt",
			duration = 4,
			cooldown = {
				duration = 0,
				time = 1,
			},
			ui_info = {
				material = "storm_bolt_icon",
				type = "special",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				rotation_speed = 0,
				speed = 3.5,
			},
			events = {
				{
					damage_hit_delay = 1,
					damage_type = "lightning",
					effect_type = "firebolt",
					event_start = 2,
					hit_react = "lightning_shock",
					inherit_from = "projectile_ability_event",
					on_enter_flow = "ability_bolt_fire",
					unit_path = "spell_storm_bolt_projectile",
					origin = {
						3,
						x = 0,
						y = 0.3,
						z = 0,
					},
					damage_amount = DAMAGE_LIGHTNING_BOLT,
				},
			},
			buffer_to = {
				custom = 10,
			},
			cancel_to = {
				custom = 12,
				interact = 22,
				navigation = 22,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
		},
		storm_bomb = {
			animation = "attack_firebomb",
			disable_target_alignment = true,
			duration = 30,
			cooldown = {
				duration = 300,
				time = 1,
			},
			ui_info = {
				material = "storm_bomb_icon",
				type = "special",
			},
			on_enter = {
				flow_event = "ability_storm_bomb_windup",
			},
			on_exit = {
				flow_event = "ability_storm_bomb_done",
			},
			on_cooldowned = {
				timpani_event = "wizard_ability_cooldown",
			},
			override_movespeed = {
				speed = 5,
				rotation_speed = 0.4 * math.pi,
			},
			events = {
				{
					angular_frequency = 1,
					break_food = true,
					collision_filter = "damageable_only",
					construct_target_position = "nil",
					damage_type = "lightning",
					effect_type = "firebolt",
					event_duration = 30,
					event_start = 1,
					follow_caster = true,
					hit_react = "shockwave",
					inherit_from = "projectile_ability_event",
					is_dependant_on_caster = true,
					max_time = 270,
					on_enter_flow = "ability_bomb_fire",
					power = 1,
					radius = 0.6,
					start_angle = 0,
					start_radius = 2,
					stop_radius = 2,
					type = "projectile_spiral",
					unit_path = "spell_storm_bomb_projectile",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					damage_amount = DAMAGE_LIGHTNING_BOMB_IMPACT,
					loop = {
						count = 4,
						frequency = 0,
						increments = {
							start_angle = 90,
						},
					},
					on_event_complete = {
						ability = "storm_bomb_burst",
						inherit_hitlist = true,
					},
				},
			},
			buffer_to = {
				custom = 25,
			},
			cancel_to = {
				custom = 31,
			},
			combo_transitions = {
				{
					type = "custom",
				},
			},
		},
		storm_bomb_burst = {
			duration = 15,
			on_enter = {
				custom_callback = function (component, unit, ability)
					if EntityAux.owned(unit) then
						local ability_state = EntityAux._state_master_raw(unit, "ability")

						ability_state.chain_lightning_hitlist = {}
					end
				end,
			},
			events = {
				{
					behind_wall_test = true,
					block_damage = 1,
					collision_filter = "damageable_only",
					damage_hit_delay = 3,
					damage_type = "lightning",
					effect_type = "none",
					event_duration = 1,
					event_start = 0,
					hit_react = "shockwave",
					node = "j_l_hand_attach",
					node_use_root_rotation = true,
					radius = 3,
					stagger_origin_type = "query",
					type = "sphere",
					wall_collision_filter = "wall_only",
					query_filters = {
						only_closest = false,
					},
					damage_amount = DAMAGE_LIGHTNING_BOMB_FORK,
					query_filters = {
						only_closest = false,
					},
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					on_valid_hit = {
						inherit_hitlist = true,
						max_steps = 1,
						set_event_as_done = true,
						custom_callback = function (event_handler, event, hit, unit)
							if event.caster_unit and EntityAux.owned(event.caster_unit) then
								if EntityAux.has_component_master(event.caster_unit, "avatar") then
									local name = event.parent_ability.static_ability.name

									if name == "chain_lightning_idle" then
										local avatar_state = EntityAux._state_master_raw(event.caster_unit, "avatar")

										if not avatar_state.chainlightning_valid_hit then
											AbilityBuildingBlocks.set_cooldown(1, event_handler.ability_component, event.caster_unit, nil, event.parent_ability)
										end

										avatar_state.chainlightning_valid_hit = true
									end
								end

								local ability_state = EntityAux._state_master_raw(event.caster_unit, "ability")
								local data = ability_state.chain_lightning_hitlist

								if #data == 0 then
									event_handler.ability_component:trigger_rpc_event("rpc_span_lightning", event.caster_unit, unit, hit.unit)
								else
									local prior_unit = data[#data]
									local hit_unit = hit.unit

									event_handler.ability_component:trigger_rpc_event("rpc_span_lightning", event.caster_unit, prior_unit, hit.unit)
								end

								ability_state.chain_lightning_hitlist[#data + 1] = hit.unit
							end
						end,
					},
				},
			},
		},
	},
})
