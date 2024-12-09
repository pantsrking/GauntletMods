-- chunkname: @equipment/necromagus/talisman03.lua

local function _on_hit(unit, hit)
	hit.damage_amount = hit.damage_amount
end

local t = {
	icon = "necromagus_ultimate_03",
	item_type = "talisman",
	combo = {
		abilities = {
			ultimate = true,
		},
		combo_transitions = {
			{
				to = "conjure",
				type = "talisman",
			},
		},
	},
	abilities = {
		conjure = {
			animation = "ability_talisman_02",
			cooldown = 36,
			duration = 35,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			flow_events = {
				{
					event_name = "ultimate_resurrect_launch",
					time = 0,
				},
			},
			events = {
				{
					damage_amount = 0,
					damage_hit_delay = 1,
					event_duration = 1,
					event_start = 3,
					hit_react = "thrust",
					radius = 3,
					type = "sphere",
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					status_effects = {
						chilled = true,
					},
				},
				{
					event_duration = 1,
					event_start = 30,
					target_type = "avatars",
					target_predicates = {},
					target_filter = StateAux.filter_death_time,
					on_valid_hit = {
						custom_callback = function (ability_event_handler, event, hit)
							local player_info = PlayerManager:get_player_info_by_avatar(hit.unit)
							local ability_component = ability_event_handler.ability_component

							ability_component:trigger_rpc_event_to_host("rpc_revive_with_hp_ratio_request", player_info.go_id, 0.6)
						end,
					},
				},
			},
		},
	},
}

return t
