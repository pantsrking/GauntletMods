-- chunkname: @lua/menu/screen_main_menu.lua

local IS_STEAM_BUILD = _G.BUILD_DATE_INFORMATION ~= "2017-09-08 16:31:18"

require("lua/menu/popup_host_options")
require("lua/menu/popup_lobby_browser")

if IS_STEAM_BUILD then
	require("lua/menu/popup_login")
end

require("lua/menu/popup_quick_join")
require("lua/menu/popup_hosting_lobby")
require("lua/menu/popup_level_select")
require("lua/menu/popup_colosseum_level_select")
require("lua/menu/popup_how_to_play")
require("lua/menu/screen_base")
require("lua/boot/game")

ScreenMainMenu = class("ScreenMainMenu", "ScreenBase")

ScreenMainMenu.init = function (self, ...)
	ScreenBase.init(self, ...)

	self.motd_set = false
	self.wbprofile_set_up = false
	self.current_selection = {}
	self.screen_default_selection = {
		"top",
		"play_online",
	}
end

ScreenMainMenu.on_script_reload = function (self)
	if self:is_visible() then
		self:rebuild_ui()
	end
end

local function update_online_required_options(self)
	if self.widget then
		local leaderboards_button = self.widget:get("leaderboards")

		if leaderboards_button then
			local enabled = Platform:get_connection_status() == Platform.CONNECTION_REGAINED or Platform:get_connection_status() == Platform.CONNECTION_ONLINE

			leaderboards_button:set_selectable(enabled)
			leaderboards_button:set_clickable(enabled)
			leaderboards_button:set_alpha(enabled and 1 or 0.1)
		end
	end
end

local function update_wbid_ui(self)
	if SaveDataHelper:get("logged_in_to_wbplay", IS_PS4 and PS4.initial_user_id() or nil) then
		self.widget:get("wb_sign_up_message_container"):set_visible(false)
	else
		self.widget:get("wb_sign_up_message_container"):set_visible(true)
	end

	local wbid_login = self.widget:get("wbid_login")
	local wbid_login_icon = self.widget:get("wbid_login_icon")
	local wb_message_link_button = self.widget:get("wb_message_link_button")

	self.widget:get("wb_message_text"):set_text("")
	self.widget:get("wb_message_text"):set_visible(false)
	wb_message_link_button:set_visible_instant(false)

	local title, message, link = Game:get_message_of_the_day()

	if title then
		self.widget:get("wb_message_title"):set_text(title)

		self.motd_set = true
	end

	if message then
		self.widget:get("wb_message_text"):set_text(message)
		self.widget:get("wb_message_text"):set_visible(true)
		wb_message_link_button:set_visible_instant(true)

		self.motd_set = true
	end

	if link ~= nil then
		self.motd_link = link

		self.widget:get("wb_message_box"):set_clickable(true)

		self.motd_set = true
	end

	if not self.motd_set then
		self.widget:get("wb_message_container"):set_visible(false)
		self.widget:get("wb_sign_up_message_container"):set_visible(false)

		return
	end

	self.widget:get("wb_message_container"):set_visible(true)
	InteractorComponent.set_menu_gamepad_button(GUI.MAIN_CONTROLLER, wbid_login_icon, "login")
	InteractorComponent.set_menu_gamepad_button(GUI.MAIN_CONTROLLER, wb_message_link_button, "open_motd_link")

	if Platform:get_connection_status() == Platform.CONNECTION_ONLINE or Platform:get_connection_status() == Platform.CONNECTION_REGAINED then
		local profile = WBProfileManager:console_profile()

		self.widget:get("loading_coin"):set_visible(false)

		if not WBProfileManager:is_setup() or WBProfileManager:is_waiting_for_lookup() then
			if self.wbplay_time == nil then
				self.wbplay_time = _G.ENGINE_TIME
			end

			local seconds = (_G.ENGINE_TIME - self.wbplay_time) / 1

			if seconds > 4 then
				self.wbplay_time = nil
			end

			wbid_login:set_text(tr("loc_wbid_checking_account"))
		elseif profile:profile_name_or_email() then
			wbid_login:set_text(tr("loc_wbid_logged_in") .. profile:profile_name_or_email())
		else
			wbid_login:set_text(tr("loc_wbid_no_profile_associated"))
		end

		wbid_login:set_clickable(true)
		wbid_login_icon:set_visible_instant(true)
	else
		wbid_login:set_text(tr(_G.IS_PC and "loc_lobby_steam_offline" or "loc_lobby_psn_offline"))
		wbid_login_icon:set_visible_instant(false)
		self.widget:get("loading_coin"):set_visible(false)
		self.widget:get("wb_message_text"):set_visible(false)
		wb_message_link_button:set_visible_instant(false)
		wbid_login:set_clickable(false)
	end
end

local function create_text_shadow_proto(text, style, size)
	return {
		alpha = 0.5,
		clickable = false,
		color = "black",
		id = "shadow",
		selectable = false,
		text = text,
		style = style,
		position = {
			"left + 2",
			"top + 2",
		},
		size = size,
	}
end

ScreenMainMenu.rebuild_ui = function (self)
	GUI:destroy_widget(self.widget)

	self.widget = nil
	self.menu_state = "top"

	local floor_id = ColosseumSettings:get_todays_floor_id()
	local colosseum_info = ColosseumSettings:get_colosseum_by_floor_id(floor_id)
	local colosseum_day_text = ""

	if floor_id then
		colosseum_day_text = tr("loc_environment_" .. colosseum_info.environment) .. " - " .. tr("loc_colosseum_spawner_type") .. tr("loc_colosseum_spawner_type_" .. colosseum_info.spawner_type)
	end

	self.widget = GUI:add_widget_at("gui/screen_main_menu_ui")

	self.widget.on.child_clicked = function (...)
		self:widget_clicked(...)
	end

	local button_protos = {}
	local online_button_protos = {}
	local offline_button_protos = {}
	local quick_join_button_protos = {}

	table.insert(button_protos, {
		id = "play_online",
		selected = true,
		style = "title_large",
		type = "button",
		text = tr("loc_menu_lobby_start_game"),
		on = {
			selected = function ()
				self:show_tooltip("play_online")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_lobby_start_game"), "title_large_shadow"),
		},
	})
	table.insert(button_protos, {
		id = "quick_join",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_quick_join"),
		on = {
			selected = function ()
				self:show_tooltip("quick_join")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_quick_join"), "title_large_shadow"),
		},
	})
	table.insert(button_protos, {
		bg_img = "menu_standard_divider_horizontal_gradient_dark",
		size = {
			400,
			6,
		},
	})
	table.insert(button_protos, {
		id = "play_offline",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_local_game"),
		size = {
			280,
			50,
		},
		on = {
			selected = function ()
				self:show_tooltip("play_offline")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_local_game"), "title_large_shadow", {
				280,
				50,
			}),
		},
	})
	table.insert(button_protos, {
		bg_img = "menu_standard_divider_horizontal_gradient_dark",
		size = {
			400,
			6,
		},
	})
	table.insert(online_button_protos, {
		id = "start_campaign_online",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_campaign"),
		on = {
			selected = function ()
				self:show_tooltip("start_campaign")
				self.menu_manager.menu_level_daemon:move_to_section("start_game")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_campaign"), "title_large_shadow"),
		},
	})
	table.insert(online_button_protos, {
		id = "start_endless_online",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_endless"),
		on = {
			selected = function ()
				self:show_tooltip("endless")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_endless"), "title_large_shadow"),
		},
	})
	table.insert(online_button_protos, {
		bg_img = "menu_standard_divider_horizontal_gradient_dark",
		size = {
			400,
			6,
		},
	})
	table.insert(online_button_protos, {
		id = "start_colosseum_online",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_colosseum"),
		on = {
			selected = function ()
				self:show_tooltip("start_colosseum")
				self.menu_manager.menu_level_daemon:move_to_section("colosseum")
			end,
		},
		children = {
			{
				font_size = 25,
				text_align = "left",
				text = colosseum_day_text,
				position = {
					"left",
					"bottom + 20",
				},
			},
			create_text_shadow_proto(tr("loc_menu_main_colosseum"), "title_large_shadow"),
		},
	})
	table.insert(online_button_protos, {
		type = "spacing",
		size = {
			0,
			25,
		},
	})
	table.insert(online_button_protos, {
		bg_img = "menu_standard_divider_horizontal_gradient_dark",
		size = {
			400,
			6,
		},
	})
	table.insert(quick_join_button_protos, {
		id = "quick_join_campaign",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_campaign"),
		on = {
			selected = function ()
				self:show_tooltip("start_campaign")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_campaign"), "title_large_shadow"),
		},
	})
	table.insert(quick_join_button_protos, {
		id = "quick_join_endless",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_endless"),
		on = {
			selected = function ()
				self:show_tooltip("endless")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_endless"), "title_large_shadow"),
		},
	})
	table.insert(quick_join_button_protos, {
		bg_img = "menu_standard_divider_horizontal_gradient_dark",
		size = {
			400,
			6,
		},
	})
	table.insert(quick_join_button_protos, {
		id = "quick_join_colosseum",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_colosseum"),
		on = {
			selected = function ()
				self:show_tooltip("start_colosseum")
			end,
		},
		children = {
			{
				font_size = 25,
				text_align = "left",
				text = colosseum_day_text,
				position = {
					"left",
					"bottom + 20",
				},
			},
			create_text_shadow_proto(tr("loc_menu_main_colosseum"), "title_large_shadow"),
		},
	})
	table.insert(offline_button_protos, {
		id = "start_campaign_offline",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_campaign"),
		on = {
			selected = function ()
				self:show_tooltip("campaign_offline")
				self.menu_manager.menu_level_daemon:move_to_section("start_game")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_campaign"), "title_large_shadow"),
		},
	})
	table.insert(offline_button_protos, {
		id = "start_endless_offline",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_endless"),
		on = {
			selected = function ()
				self:show_tooltip("endless_offline")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_endless"), "title_large_shadow"),
		},
	})
	table.insert(offline_button_protos, {
		bg_img = "menu_standard_divider_horizontal_gradient_dark",
		size = {
			400,
			6,
		},
	})
	table.insert(offline_button_protos, {
		id = "start_colosseum_offline",
		style = "title_large",
		type = "button",
		text = tr("loc_menu_main_colosseum"),
		on = {
			selected = function ()
				self:show_tooltip("start_colosseum")
				self.menu_manager.menu_level_daemon:move_to_section("colosseum")
			end,
		},
		children = {
			{
				font_size = 25,
				text_align = "left",
				text = colosseum_day_text,
				position = {
					"left",
					"bottom + 20",
				},
			},
			create_text_shadow_proto(tr("loc_menu_main_colosseum"), "title_large_shadow"),
		},
	})
	table.insert(offline_button_protos, {
		type = "spacing",
		size = {
			0,
			25,
		},
	})
	table.insert(offline_button_protos, {
		bg_img = "menu_standard_divider_horizontal_gradient_dark",
		size = {
			400,
			6,
		},
	})

	if _G.IS_DEV and _G.ARGUMENTS.dev then
		if NetworkBackend:type() == "LAN" then
			table.insert(button_protos, {
				id = "lobby_browser_offline",
				style = "title_large",
				text = "Find LAN Game",
				translated = false,
				type = "button",
			})
		end

		table.insert(button_protos, {
			id = "debug",
			style = "title_large",
			text = "DEBUG",
			translated = false,
			type = "button",
		})
	end

	table.insert(button_protos, {
		id = "leaderboards",
		style = "title_small",
		type = "button",
		text = tr("loc_menu_main_leaderboards"),
		on = {
			selected = function ()
				self:show_tooltip("leaderboards")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_leaderboards"), "title_small_shadow"),
		},
	})
	table.insert(button_protos, {
		id = "masteries",
		style = "title_small",
		type = "button",
		text = tr("loc_menu_main_masteries"),
		on = {
			selected = function ()
				self:show_tooltip("perk_progression")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_masteries"), "title_small_shadow"),
		},
	})
	table.insert(button_protos, {
		id = "how_to_play",
		style = "title_small",
		type = "button",
		text = tr("loc_menu_how_to_play"),
		on = {
			selected = function ()
				self:show_tooltip("how_to_play")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_how_to_play"), "title_small_shadow"),
		},
	})
	table.insert(button_protos, {
		id = "settings",
		style = "title_small",
		text_align = "left",
		type = "button",
		text = tr("loc_menu_main_settings"),
		on = {
			selected = function ()
				self:show_tooltip("settings")
			end,
		},
		children = {
			create_text_shadow_proto(tr("loc_menu_main_settings"), "title_small_shadow"),
		},
	})

	if not _G.IS_PS4 then
		table.insert(button_protos, {
			id = "quit",
			style = "title_small",
			type = "button",
			text = tr("loc_menu_main_quit"),
			on = {
				selected = function ()
					self:show_tooltip("quit")
				end,
			},
			children = {
				create_text_shadow_proto(tr("loc_menu_main_quit"), "title_small_shadow"),
			},
		})
	end

	if GUI.MAIN_CONTROLLER == INPUT_USER_KEYBOARD_MOUSE then
		table.insert(online_button_protos, {
			type = "spacing",
			size = {
				0,
				40,
			},
		})
		table.insert(online_button_protos, {
			id = "return_online",
			style = "title_small",
			type = "button",
			text = tr("loc_menu_back"),
			on = {
				selected = function ()
					self:show_tooltip("return")
				end,
				clicked = function ()
					self:transition_to_mode()
				end,
			},
			children = {
				create_text_shadow_proto(tr("loc_menu_back"), "title_small_shadow"),
			},
		})
		table.insert(quick_join_button_protos, {
			type = "spacing",
			size = {
				0,
				40,
			},
		})
		table.insert(quick_join_button_protos, {
			id = "return_quick_join",
			style = "title_small",
			type = "button",
			text = tr("loc_menu_back"),
			on = {
				selected = function ()
					self:show_tooltip("return")
				end,
				clicked = function ()
					self:transition_to_mode()
				end,
			},
			children = {
				create_text_shadow_proto(tr("loc_menu_back"), "title_small_shadow"),
			},
		})
		table.insert(offline_button_protos, {
			type = "spacing",
			size = {
				0,
				40,
			},
		})
		table.insert(offline_button_protos, {
			id = "return_offline",
			style = "title_small",
			type = "button",
			text = tr("loc_menu_back"),
			on = {
				selected = function ()
					self:show_tooltip("return")
				end,
				clicked = function ()
					self:transition_to_mode()
				end,
			},
			children = {
				create_text_shadow_proto(tr("loc_menu_back"), "title_small_shadow"),
			},
		})
	end

	self.widget:get("buttons"):set_children_from_proto(button_protos)
	self.widget:get("buttons_online"):set_children_from_proto(online_button_protos)
	self.widget:get("buttons_quick_join"):set_children_from_proto(quick_join_button_protos)
	self.widget:get("buttons_offline"):set_children_from_proto(offline_button_protos)

	if _G.IS_PC then
		local proto = {
			id = "change_main_controller",
			selectable = false,
			style = "button_standard",
			type = "button",
			text = tr("loc_change_main_controller"),
			position = {
				"left + 180",
				"bottom - 40",
			},
			children = {
				{
					id = "change_controller_key",
					translated = false,
					visible = true,
					position = {
						"left + 15",
						"center - 2",
					},
					size = {
						32,
						32,
					},
				},
			},
		}
		local button_widget = GUI:load_proto(proto)

		self.widget:add_child(button_widget)
		InteractorComponent.set_menu_gamepad_button(GUI.MAIN_CONTROLLER, self.widget:get("change_controller_key"), "change_controller")
	end

	if _G.IS_PC then
		self.widget:get("wbid_login"):set_exclusive_user_name(_G.INPUT_USER_KEYBOARD_MOUSE)
		self.widget:get("wbid_login"):input_whitelist_add(_G.INPUT_USER_KEYBOARD_MOUSE)
	end

	self.motd_set = false

	CursorManager:set_show_cursor(GUI.MAIN_CONTROLLER == _G.INPUT_USER_KEYBOARD_MOUSE)
	self.widget:get("wb_message_container"):set_visible_instant(true, GUI.MAIN_CONTROLLER)

	local logged_in_to_wbplay = SaveDataHelper:get("logged_in_to_wbplay", IS_PS4 and PS4.initial_user_id() or nil)

	self.widget:get("wb_sign_up_message_container"):set_visible_instant(not logged_in_to_wbplay, GUI.MAIN_CONTROLLER)
	update_wbid_ui(self)
	self.widget:get("gauntlet_logo"):start_particle_effect("lightning", "effects_ui/menu_logo_lightning")
	update_online_required_options(self)
	GUI:finalize_layout()
end

ScreenMainMenu.show_mode_buttons = function (self, mode)
	if mode == "online" then
		self.widget:get("buttons"):set_visible(false)
		self.widget:get("buttons_online"):set_visible(true)

		self.menu_state = "online"

		return "start_campaign_online"
	elseif mode == "offline" then
		self.widget:get("buttons"):set_visible(false)
		self.widget:get("buttons_offline"):set_visible(true)

		self.menu_state = "offline"

		return "start_campaign_offline"
	elseif mode == "quick_join" then
		self.widget:get("buttons"):set_visible_instant(false)
		self.widget:get("buttons_quick_join"):set_visible(true)

		self.menu_state = "quick_join"

		return "quick_join_campaign"
	else
		self.widget:get("buttons_online"):set_visible(false)
		self.widget:get("buttons_offline"):set_visible(false)
		self.widget:get("buttons_quick_join"):set_visible(false)
		self.widget:get("buttons"):set_visible(true)

		self.menu_state = "top"

		return "play_online"
	end
end

ScreenMainMenu.transition_to_mode = function (self, mode)
	self.menu_manager:store_selection(self.menu_state)

	local default_selection = self:show_mode_buttons(mode)

	self.menu_manager:restore_selection(self.menu_state, default_selection)
end

local MINIMUM_POPUP_DURATION = 1

local function verify_psplus(success_cb)
	local widget = GUI:load_widget_at("gui/popup_network_setup_ui")
	local user_id = PS4.initial_user_id()
	local user_name = Platform:username(user_id)
	local text = LocalizationManager:string_format("loc_hotjoin_ingame_psplus", "#USER", user_name)

	widget:get("status_text"):set_text(text)
	Game:current_menu_manager():transition_to_modal("popup_verify_online_features", widget)
	GUI:finalize_layout()

	local function psplus_request_callback(user_id, result, error_code)
		Game:current_menu_manager():transition_from_modal(widget)
		GUI:destroy_widget(widget)

		if result then
			success_cb()
		else
			local text = LocalizationManager:string_format("loc_network_setup_error_psplus", "#USER", user_name)

			PopupDialogue.show_error(GUI.MAIN_CONTROLLER, text)
		end
	end

	PsnManager:can_access_psplus_request(user_id, psplus_request_callback, true, false, false)
end

local ERROR_LOC_LOOKUP

if _G.IS_PS4 then
	ERROR_LOC_LOOKUP = {
		[NpCheck.ERROR_PATCH_EXIST] = "loc_network_setup_error_patch",
		[NpCheck.ERROR_SYSTEM_SOFTWARE_EXIST] = "loc_network_setup_error_system",
		[NpCheck.ERROR_SYSTEM_SOFTWARE_EXIST_FOR_TITLE] = "loc_network_setup_error_system",
		[NpCheck.ERROR_SIGNED_OUT] = "loc_network_setup_error_signed_out",
	}
end

local function verify_online(success_cb, needs_psplus_check)
	if _G.IS_PC then
		success_cb()
	else
		local np_id = PS4.np_id(PS4.initial_user_id())

		if PsnManager:is_can_access_online_features_busy(np_id) then
			return
		end

		if needs_psplus_check then
			success_cb = closure(verify_psplus, success_cb)
		end

		local widget = GUI:load_widget_at("gui/popup_network_setup_ui")

		widget:get("status_text"):set_text(tr("loc_verify_online_features"))
		Game:current_menu_manager():transition_to_modal("popup_verify_online_features", widget)
		GUI:finalize_layout()

		local function online_features_request_callback(np_id, result, age_restricted, error_code)
			Game:current_menu_manager():transition_from_modal(widget)
			GUI:destroy_widget(widget)

			if result then
				success_cb()
			else
				local error_loc

				error_loc = age_restricted and "loc_network_setup_error_age" or ERROR_LOC_LOOKUP[error_code] or "loc_network_setup_error_ps4"

				local text

				if error_loc == "loc_network_setup_error_age" or error_loc == "loc_network_setup_error_signed_out" then
					local user_name = Platform:username(PS4.initial_user_id())

					text = LocalizationManager:string_format(error_loc, "#USER", user_name)
				else
					text = LocalizationManager:string(error_loc)
				end

				PopupDialogue.show_error(GUI.MAIN_CONTROLLER, text)
			end
		end

		if not np_id then
			online_features_request_callback(np_id, false, false, NpCheck.ERROR_SIGNED_OUT)

			return
		end

		PsnManager:can_access_online_features_request(np_id, online_features_request_callback, false, true)
	end
end

local function try_go_online(success_cb)
	if Game:online_mode() then
		verify_online(success_cb, true)

		return
	end

	if NetworkSetupManager:get_state() == NetworkSetupManager.NETWORK_SETUP_DONE then
		local users = {
			Platform:user_id(),
		}

		NetworkSetupManager:connect(false, users, Game)
	else
		NetworkSetupManager:set_silent(false)
	end

	local function network_setup_cb()
		local state, fail_state, fail_error, fail_user_name = NetworkSetupManager:get_state()

		if state == NetworkSetupManager.NETWORK_SETUP_DONE then
			if Game:online_mode() then
				if _G.IS_PS4 and Network.nat_type() == 3 then
					PopupDialogue.show_ok(GUI.MAIN_CONTROLLER, tr("loc_network_info_nat3"), success_cb)
				else
					success_cb()
				end
			elseif fail_error ~= NetworkSetupManager.NETWORK_ERROR_DISCONNECTED then
				local text = PopupNetworkSetup.error_msg(fail_error, fail_user_name)

				PopupDialogue.show_ok(GUI.MAIN_CONTROLLER, text)
			end
		end
	end

	PopupNetworkSetup.show(GUI.MAIN_CONTROLLER, network_setup_cb, MINIMUM_POPUP_DURATION)
end

local function try_go_to(online_mode, next_cb)
	if online_mode then
		try_go_online(next_cb)
	else
		if Game:online_mode() then
			NetworkSetupManager:disconnect()
		end

		next_cb()
	end
end

ScreenMainMenu.get_selection = function (self)
	self.widget:pause_particles()

	self.current_selection[1] = self.menu_state
	self.current_selection[2] = GUI:get_selected_id(GUI.MAIN_CONTROLLER)

	return self.current_selection
end

ScreenMainMenu.set_selection = function (self, selection)
	self.widget:unpause_particles()
	self:transition_to_mode(selection[1])
	ScreenBase.set_selection(self, selection[2] or self.screen_default_selection[2])
end

ScreenMainMenu.on_enter = function (self, params)
	ScreenBase.on_enter(self)
	self:rebuild_ui()

	if params then
		if self.level_select_popup then
			self.level_select_popup:exit()

			self.level_select_popup = nil
		end

		if params.go_offline then
			if LobbyManager:network_lobby() then
				Game:leave_network_game()
			end

			NetworkSetupManager:disconnect()
			self.menu_manager:clear_selection_history(self._screen_name)
		end

		if params.reason then
			PopupDialogue.show_error(GUI.MAIN_CONTROLLER, params.reason)
		end

		if params.join_lobby then
			local function next_cb()
				local function cb(self, result, error)
					if result == "success" then
						local game_info = NetworkClient:get_game_info()

						if game_info.in_game then
							Game:change_state_to_game({
								starter_controller_name = GUI.MAIN_CONTROLLER,
							})
						else
							local screen_params = {
								user_name = GUI.MAIN_CONTROLLER,
								game_type = game_info.game_type,
							}

							Game:go_to_lobby(screen_params)
						end
					elseif result == "fail" then
						error = Game:get_host_client_error_text(error)

						PopupDialogue.show_error(GUI.MAIN_CONTROLLER, error, nil)
						Game:leave_network_game()
					elseif result == "cancel" then
						Game:leave_network_game()
					end
				end

				Game:join_network_game(params.join_lobby, closure(cb, self))
			end

			self.menu_manager:apply_selection_history(self)
			try_go_to(true, next_cb)
		end
	end

	GUI:get_root():set_exclusive_user_name(GUI.MAIN_CONTROLLER)

	if _G.IS_PC then
		local user = ProfileManager:get_user(GUI.MAIN_CONTROLLER)
		local slayer_edition_played = user:data("slayer_edition_played")

		if not slayer_edition_played then
			user:set("slayer_edition_played", true)
			user:save("slayer_edition_played")

			local PERK_SETTINGS = require("lua/managers/perk_settings")
			local counts = user:get_masteries()

			for avatar_type, hero_counts in pairs(counts) do
				local avatar_index = AvatarSettings.avatar_lookup[avatar_type]

				if avatar_index then
					local gold_earned = 0

					for perk_id, count in pairs(hero_counts) do
						local level = PerkManager.calc_perk_level(perk_id, count)
						local perk_settings = PERK_SETTINGS[perk_id]
						local max_level = #perk_settings

						for i = 1, level do
							local perk = perk_settings[i]
							local gold_reward

							if i == max_level then
								gold_reward = PERK_GOLD_REWARDS[#PERK_GOLD_REWARDS]
							else
								gold_reward = PERK_GOLD_REWARDS[i]
							end

							gold_earned = gold_earned + gold_reward
						end
					end

					user:add_gold(avatar_type, gold_earned)
				end
			end

			PopupDialogue.show_ok(GUI.MAIN_CONTROLLER, tr("loc_update_welcome"))
		end
	end
end

ScreenMainMenu.on_exit = function (self)
	self:close_popup()
	ScreenBase.on_exit(self)
	GUI:destroy_widget(self.widget)

	self.widget = nil
end

ScreenMainMenu.update = function (self, dt)
	if Platform:get_connection_status() == Platform.CONNECTION_LOST or Platform:resumed_from_suspension() then
		self.menu_manager:clear_selection_history(self._screen_name)
		self:show_mode_buttons()
		update_online_required_options(self)
	end

	if Platform:get_connection_status() == Platform.CONNECTION_LOST or Platform:get_connection_status() == Platform.CONNECTION_REGAINED or Platform:resumed_from_suspension() then
		self.motd_set = false

		update_wbid_ui(self)
		update_online_required_options(self)
	end

	if not self.motd_set then
		local title, message, link = Game:get_message_of_the_day()

		if title or message or link then
			update_wbid_ui(self)
		end
	end

	if IS_STEAM_BUILD and (not self.wbprofile_set_up and WBProfileManager:is_setup()) then
		update_wbid_ui(self)
		self.wbprofile_set_up = true
	end

	if _G.IS_DEV and (_G.IS_PS4 and Pad1.active() and Pad1.pressed(Pad1.button_index("r1")) or _G.IS_PC and Keyboard.pressed(Keyboard.button_index("f1"))) then
		ColosseumSettings:set_days_since_colosseum_start(ColosseumSettings:get_day() + 1)
		self:rebuild_ui()
		self:show_mode_buttons("online")
	end

	if self.popup then
		self.popup:update(dt)

		if self.widget == nil then
			return
		end
	end
end

ScreenMainMenu.go_to_lobby = function (self, user_name, screen_params)
	Game:create_network_game(nil, nil, screen_params.game_type)

	local function done()
		LobbyManager:update()
		self.menu_manager:transition_to("screen_lobby", screen_params)
	end

	local function fail(reason)
		Game:leave_network_game()

		if reason == PopupHostingLobby.ERROR_LOST_CONNECTION then
			return
		end

		local msg = PopupHostingLobby.error_msg(reason)

		PopupDialogue.show_error(user_name, msg)
	end

	PopupHostingLobby.show(user_name, done, fail, MINIMUM_POPUP_DURATION)
end

local function host_options_cb(self)
	local difficulty = DifficultyManager:difficulty_setting()
	local finished_tutorial = ProfileManager:has_finished_floor("tutorial", difficulty)
	local last_selected_floor = "tutorial"

	last_selected_floor = finished_tutorial and ProfileManager:get_last_selected_floor(difficulty) or last_selected_floor
	self.level_select_popup = PopupLevelSelect.show(GUI.MAIN_CONTROLLER, function (result, floor_id, popup)
		self.level_select_popup = nil

		if result == "animation_done" then
			-- Nothing
		elseif result == "floor_selected" then
			popup:exit()
			ProfileManager:set_last_selected_floor(floor_id, difficulty)

			local lobby_params = {
				user_name = GUI.MAIN_CONTROLLER,
				game_type = _G.GAME_TYPE_CAMPAIGN,
				floor_id = floor_id,
			}

			self:go_to_lobby(GUI.MAIN_CONTROLLER, lobby_params)
		elseif result == "cancel" then
			popup:exit()

			if self._started_campaign ~= nil then
				self:start_game(_G.GAME_TYPE_CAMPAIGN, self._started_campaign)
			end
		end
	end, last_selected_floor)
end

ScreenMainMenu.start_game = function (self, game_type, online_mode)
	if game_type == _G.GAME_TYPE_CAMPAIGN then
		self._started_campaign = online_mode

		PopupHostOptions.show(GUI.MAIN_CONTROLLER, closure(host_options_cb, self), Game:online_mode())
	elseif game_type == _G.GAME_TYPE_ENDLESS then
		self:go_to_lobby(GUI.MAIN_CONTROLLER, {
			user_name = GUI.MAIN_CONTROLLER,
			game_type = game_type,
		})
	elseif game_type == _G.GAME_TYPE_COLOSSEUM then
		local todays_floor_id = ColosseumSettings:get_todays_floor_id()

		self.level_select_popup = PopupColosseumLevelSelect.show(GUI.MAIN_CONTROLLER, function (result, floor_id, popup)
			self.level_select_popup = nil

			if result == "floor_selected" then
				popup:exit()
				self:go_to_lobby(GUI.MAIN_CONTROLLER, {
					user_name = GUI.MAIN_CONTROLLER,
					game_type = _G.GAME_TYPE_COLOSSEUM,
					floor_id = floor_id,
				})
			elseif result == "go_back" then
				popup:exit()
			end
		end, todays_floor_id)
	end
end

ScreenMainMenu.quick_join = function (self, game_type)
	PopupQuickJoin.show(GUI.MAIN_CONTROLLER, self.app_state, game_type)
end

ScreenMainMenu.leaderboards = function (self)
	local function success_cb()
		self.menu_manager:transition_to("screen_leaderboards", GUI.MAIN_CONTROLLER, _G.GAME_TYPE_ENDLESS)
	end

	verify_online(success_cb, false)
end

ScreenMainMenu.show_tooltip = function (self, name, full_loc_string)
	local tooltip_widget = self.widget:get("tooltip_text")

	if full_loc_string then
		tooltip_widget:set_text(tr(name))
	else
		tooltip_widget:set_text(tr("loc_menu_tooltip_" .. name))
	end
end

ScreenMainMenu.set_popup = function (self, popup)
	local old_popup = self.popup

	self.popup = popup

	if old_popup then
		old_popup:destroy()
	end
end

ScreenMainMenu.close_popup = function (self)
	self:set_popup(nil)
	update_wbid_ui(self)
end

local function show_play_online(self)
	self:transition_to_mode("online")
end

local function show_quick_join(self)
	self:transition_to_mode("quick_join")
end

local function show_play_offline(self)
	self:transition_to_mode("offline")
end

local function try_open_motd_link(self)
	local function next_cb()
		local pad_user = PadManager:get_user(GUI.MAIN_CONTROLLER)
		local user_id = _G.IS_PS4 and pad_user and pad_user.pad.user_id()

		WebBrowserManager:open(self.motd_link, user_id)
	end

	verify_online(next_cb, false)
end

local function try_login_to_wbplay(self)
	local function next_cb()
		if IS_PS4 then
			PS4VideoRecording.set_prohibit(true)
			PS4LiveStreaming.set_enabled(false)

			self.video_recording_prohibited = true
		end

		local function cb(...)
			self:close_popup(...)

			if IS_PS4 then
				self.video_recording_prohibited = false

				Game.engine_scheduler:delay_action(0.2, function ()
					if not self.video_recording_prohibited then
						PS4VideoRecording.set_prohibit(false)
						PS4LiveStreaming.set_enabled(true)
					end
				end)
			end
		end

		self:set_popup(PopupLogin(GUI.MAIN_CONTROLLER, cb))
	end

	verify_online(next_cb, false)
end

ScreenMainMenu.widget_clicked = function (self, widget, user_name)
	local id = widget.id

	if id == "play_online" then
		try_go_to(true, closure(show_play_online, self))
	elseif id == "quick_join" then
		try_go_to(true, closure(show_quick_join, self))
	elseif id == "play_offline" then
		try_go_to(false, closure(show_play_offline, self))
	elseif id == "start_campaign_online" then
		self:start_game(_G.GAME_TYPE_CAMPAIGN, true)
	elseif id == "start_endless_online" then
		self:start_game(_G.GAME_TYPE_ENDLESS, true)
	elseif id == "start_colosseum_online" then
		self:start_game(_G.GAME_TYPE_COLOSSEUM, true)
	elseif id == "quick_join_campaign" then
		self:quick_join(_G.GAME_TYPE_CAMPAIGN)
	elseif id == "quick_join_endless" then
		self:quick_join(_G.GAME_TYPE_ENDLESS)
	elseif id == "quick_join_colosseum" then
		self:quick_join(_G.GAME_TYPE_COLOSSEUM)
	elseif id == "start_campaign_offline" then
		self:start_game(_G.GAME_TYPE_CAMPAIGN, false)
	elseif id == "start_endless_offline" then
		self:start_game(_G.GAME_TYPE_ENDLESS, false)
	elseif id == "start_colosseum_offline" then
		self:start_game(_G.GAME_TYPE_COLOSSEUM, false)
	elseif _G.IS_PC and id == "change_main_controller" then
		if PadManager:get_num_active_pads() == 0 then
			PopupDialogue.show_ok(_G.INPUT_USER_KEYBOARD_MOUSE, tr("loc_no_gamepad_connected"))
		else
			self.menu_manager:transition_to("screen_input_select", user_name)
		end
	elseif _G.IS_DEV and id == "debug" then
		self.menu_manager:transition_to("screen_debug", user_name)
	elseif _G.IS_DEV and id == "lobby_browser_offline" then
		self:set_popup(PopupLobbyBrowser(user_name, self.app_state, callback(self, "close_popup")))
	elseif id == "leaderboards" then
		self:leaderboards()
	elseif id == "settings" then
		self.menu_manager:transition_to("screen_options", user_name, false)
	elseif id == "credits" then
		self.menu_manager:transition_to("screen_credits", user_name)
	elseif id == "masteries" then
		self.menu_manager:transition_to("screen_masteries", user_name)
	elseif id == "how_to_play" then
		PopupHowToPlay.show(user_name)
	elseif id == "wbid_login" then
		local online = Platform:get_connection_status() == Platform.CONNECTION_ONLINE

		if self.motd_set and online then
			try_login_to_wbplay(self)
		end
	elseif id == "wb_message_box" or id == "wb_message_scroll_area" then
		local online = Platform:get_connection_status() == Platform.CONNECTION_ONLINE

		if self.motd_link and online then
			try_open_motd_link(self)
		end
	elseif _G.IS_PC and id == "quit" then
		Application.quit()
	end
end

ScreenMainMenu.handle_one_input = function (self, input_name, user_name, pressed)
	if self.popup then
		return false
	end

	if not self.widget:responds_to(user_name) then
		return
	end

	local online = Platform:get_connection_status() == Platform.CONNECTION_ONLINE

	if self.motd_set and online and input_name == "login" then
		try_login_to_wbplay(self)
	elseif self.motd_link and online and input_name == "open_motd_link" then
		try_open_motd_link(self)
	elseif _G.IS_PC and input_name == "change_controller" then
		self.menu_manager:transition_to("screen_input_select", user_name)
	elseif input_name == "back" then
		self:transition_to_mode()
	end

	return ScreenBase.handle_one_input(self, input_name, user_name, pressed)
end
