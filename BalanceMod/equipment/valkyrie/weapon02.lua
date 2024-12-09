-- chunkname: @equipment/valkyrie/weapon02.lua

local DAMAGE_LIGHTNING_FORKS = 18
local DAMAGE_THUNDERSTRIKE_BLOW = 10
local DAMAGE_THUNDERSTRIKE_LIGHTNING = 120

return SettingsAux.override_settings("equipment/valkyrie/weapon01", {
	combo = {
		combo_transitions = {
			{
				to = "sword1",
				type = "light",
			},
			{
				to = "rocket_girl_from_idle",
				type = "heavy",
			},
			{
				to = "thunderstrike",
				type = "special",
			},
			{
				to = "shield_bash",
				type = "melee_blocked",
			},
		},
	},
	abilities = {
		default_data = {
			ability_data = true,
			combo_transitions = {
				{
					to = "sword1",
					type = "light",
				},
				{
					to = "rocket_girl_from_idle",
					type = "heavy",
				},
				{
					to = "thunderstrike",
					type = "special",
				},
				{
					type = "defense",
				},
			},
		},
		sword7 = {
			events = {
				{
					animation = "shield_bash_02_followup",
					behind_wall_test = true,
					breaker = true,
					breaker_light = true,
					collision_filter = "damageable_and_wall",
					damage_type = "spear",
					effect_type = "spear",
					event_duration = 2,
					event_start = 4,
					execute = false,
					hit_react = "shockwave",
					stagger_origin_type = "character",
					type = "box_sweep",
					damage_amount = DAMAGE_LIGHTNING_FORKS,
					origin = {
						y = 1,
						z = 0,
						x = -0,
					},
					half_extents = {
						x = 3,
						y = 2,
						z = 0.5,
					},
					on_valid_hit = {
						inherit_hitlist = true,
						max_steps = 1,
						set_event_as_done = true,
						custom_callback = function (event_handler, event, hit, unit)
							if event.caster_unit and EntityAux.owned(event.caster_unit) then
								event_handler.ability_component:trigger_rpc_event("rpc_span_lightning", event.caster_unit, event.caster_unit, hit.unit)
							end
						end,
					},
				},
			},
		},
		thunderstrike = {
			animation = "attack_mace_strike",
			duration = 61,
			inherit_from = "default_data",
			ui_info = {
				material = "valkyrie_action_linebreaker",
				type = "special",
			},
			flow_events = {
				{
					event_name = "ability_special_windup",
					time = 0,
				},
			},
			events = {
				{
					breaker = true,
					damage_type = "cleave",
					event_duration = 1,
					event_start = 12,
					hit_react = "thrust",
					on_enter_flow = "ability_special_execute",
					type = "box",
					damage_amount = DAMAGE_THUNDERSTRIKE_BLOW,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					half_extents = {
						x = 0.3,
						y = 1,
						z = 0.5,
					},
					query_filters = {
						only_closest = true,
					},
					on_valid_hit = {
						ability = "lightning",
						use_last_hit_as_target = true,
						custom_callback = function (event_handler, event, hit)
							AbilityBuildingBlocks.set_cooldown(3, event_handler.ability_component, event.caster_unit, nil, event.parent_ability)

							local world = event_handler.ability_component.world_proxy:get_world()

							World.spawn_unit(world, "special_thunder", Unit.local_position(hit.unit, 0))
						end,
					},
				},
			},
			movements = {
				{
					translation = 0.4,
					window = {
						0,
						5,
					},
				},
			},
			cancel_to = {
				defense = 16,
				heavy = 16,
				interact = 16,
				light = 16,
				navigation = 16,
				special = 16,
			},
		},
		lightning = {
			duration = 10,
			cooldown = {
				duration = 90,
				time = 0,
			},
			events = {
				{
					break_food = true,
					breaker = true,
					event_duration = 1,
					event_start = 1,
					hit_react = "explosion",
					target_type = "target_unit",
					damage_amount = DAMAGE_THUNDERSTRIKE_LIGHTNING,
				},
				{
					breaker = true,
					damage_amount = 8,
					event_duration = 1,
					event_start = 2,
					hit_react = "shockwave",
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
	},
})
