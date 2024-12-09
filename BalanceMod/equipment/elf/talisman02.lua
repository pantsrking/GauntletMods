-- chunkname: @equipment/elf/talisman02.lua

local HIDDEN_DURATION = 8
local t = {
	icon = "elf_ultimate_02",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "cast",
				type = "talisman",
			},
		},
	},
	abilities = {
		heal_event_data = {
			event_data = true,
			event_duration = 1,
			event_start = 1,
			heal_amount = 1,
			target_type = "allies",
			target_predicates = {
				closure(StateAux.predicate_has_component, "avatar"),
			},
		},
		cast = {
			animation = "ultimate_shroudshot",
			duration = 20,
			cooldown = HIDDEN_DURATION * 30,
			flow_events = {
				{
					event_name = "ultimate_shroudshot_windup",
					time = 0,
				},
				{
					event_name = "ultimate_shroudshot_execute",
					time = 20,
				},
			},
			on_exit = {
				ability = "dryads_song",
			},
		},
		dryads_song = {
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			duration = HIDDEN_DURATION * 30,
			flow_events = {
				{
					event_name = "ultimate_dryadssong_windup",
					time = 0,
				},
			},
			events = {
				{
					damage_type = "ice",
					effect_type = "ice",
					event_start = 1,
					flow_event_effect_unit_spawned = "sirens_lute_activate_long",
					on_enter_flow = "ultimate_shroudshot_execute",
					target_type = "allies",
					unit_path = "gameobjects/relics/relic_effects",
					target_predicates = {
						closure(StateAux.predicate_has_component, "avatar"),
					},
					event_duration = HIDDEN_DURATION * 30,
					on_enter_custom = function (event_handler, event)
						EntityAux.get_component("avatar").sirens_lute_expiration_time = _G.GAME_TIME + HIDDEN_DURATION
					end,
					on_exit_custom = function (event_handler, event)
						Unit.flow_event(event.unit, "sirens_lute_over")
					end,
					status_effects = {
						hidden = {
							duration = HIDDEN_DURATION,
						},
					},
				},
				{
					event_start = 0,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 30,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 60,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 90,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 120,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 150,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 180,
					inherit_from = "heal_event_data",
				},
				{
					event_start = 210,
					inherit_from = "heal_event_data",
				},
			},
		},
	},
}

return t
