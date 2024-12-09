-- chunkname: @equipment/necromagus/talisman01.lua

local DAMAGE = 3
local REFRESH_TIME = 15

local function _on_hit(unit, hit)
	hit.damage_amount = hit.damage_amount
end

local t = {
	icon = "necromagus_ultimate_01",
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
			animation = "ability_talisman_01",
			cooldown = 150,
			duration = 25,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			flow_events = {
				{
					event_name = "ultimate_darkhunger_windup",
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
			},
			on_exit = {
				ability = "drainfield",
			},
		},
		drainfield = {
			duration = 150,
			ignore_aim_direction = true,
			ignore_interrupt = true,
			set_as_busy = false,
			flow_events = {
				{
					event_name = "ultimate_darkhunger_launch",
					time = 0,
				},
			},
			events = {
				{
					collision_filter = "damageable_only",
					drain_amount = 1,
					event_duration = 270,
					event_start = 1,
					flow_event_effect_unit_spawned = "activate",
					hit_react = "poke",
					origin_type = "center",
					radius = 4,
					type = "sphere",
					unit_path = "characters/avatar_necromagus/abilities/ultimate_darkhunger",
					refresh_hitlist_time = REFRESH_TIME,
					damage_amount = DAMAGE,
					origin = {
						x = 0,
						y = 0,
						z = 0,
					},
					status_effects = {
						chilled = true,
					},
					on_enter_custom = function (event_handler, event)
						EntityEventModifierManager:register_modifier(event.caster_unit, "on_hit_send", "vampire_heart", _on_hit)
					end,
					on_exit_custom = function (event_handler, event)
						Unit.flow_event(event.unit, "deactivate")
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
			},
		},
	},
}

return t
