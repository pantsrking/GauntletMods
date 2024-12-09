-- chunkname: @gameobjects/relics/vampire_heart.lua

local function _on_hit(unit, hit)
	local SOME_BONUS = 1

	hit.damage_amount = hit.damage_amount * SOME_BONUS
end

local t = {
	icon = "item_vampire_heart",
	item_id = "relic_vampire_heart",
	combo = {
		abilities = {
			relic = true,
		},
		combo_transitions = {
			{
				to = "vampire_heart_1",
				type = "relic_1",
			},
			{
				to = "vampire_heart_2",
				type = "relic_2",
			},
			{
				to = "vampire_heart_3",
				type = "relic_3",
			},
		},
	},
	abilities = {
		vampire_heart_data = {
			ability_data = true,
			cooldown = 150,
			duration = 70,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			ui_info = {
				type = "relic",
			},
			on_cooldowned = {
				timpani_event = "relic_vampire_heart_reset",
			},
		},
		vampire_event_data = {
			collision_filter = "damageable_only",
			damage_amount = 16,
			drain_amount = 2,
			event_data = true,
			event_duration = 150,
			event_start = 1,
			flow_event_effect_unit_spawned = "vampire_heart_activate_tier1",
			origin_type = "center",
			radius = 2.5,
			refresh_hitlist_time = 45,
			type = "sphere",
			unit_path = "gameobjects/relics/relic_effects",
			origin = {
				x = 0,
				y = 0,
				z = 0,
			},
			on_enter_custom = function (event_handler, event)
				EntityEventModifierManager:register_modifier(event.caster_unit, "on_hit_send", "vampire_heart", _on_hit)
			end,
			on_exit_custom = function (event_handler, event)
				Unit.flow_event(event.unit, "vampire_heart_deactivate")
				EntityEventModifierManager:unregister_modifier(event.caster_unit, "on_hit_send", "vampire_heart")
			end,
			on_valid_hit = {
				custom_callback = function (ability_event_handler, event, hit)
					if not EntityAux.owned(hit.caster_unit) then
						return
					end

					local unit = hit.unit

					if EntityAux.has_component(unit, "enemy") then
						EntityAux.queue_command_master_interface(hit.caster_unit, "i_damage_receiver", "heal", event.settings.drain_amount)
					end
				end,
			},
		},
		vampire_heart_1 = {
			inherit_from = "vampire_heart_data",
			events = {
				{
					inherit_from = "vampire_event_data",
					radius = 3,
				},
			},
		},
		vampire_heart_2 = {
			inherit_from = "vampire_heart_data",
			events = {
				{
					flow_event_effect_unit_spawned = "vampire_heart_activate_tier2",
					inherit_from = "vampire_event_data",
					radius = 4,
				},
			},
		},
		vampire_heart_3 = {
			inherit_from = "vampire_heart_data",
			events = {
				{
					flow_event_effect_unit_spawned = "vampire_heart_activate_tier3",
					inherit_from = "vampire_event_data",
					radius = 4,
				},
			},
		},
	},
}

return t
