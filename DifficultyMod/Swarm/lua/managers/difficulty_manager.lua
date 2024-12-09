-- chunkname: @lua/managers/difficulty_manager.lua

local AHGSE_MULTIPLIER = {
	fml = 4,
	goldfood = 4,
	hard = 1.5,
	medium = 0.8,
}
local DIFFICULTY_SPEED_MULTIPLIER = {
	fml = 1.5,
	goldfood = 1.5,
	hard = 1.25,
	medium = 1,
}
local AVATAR_DAMAGE_MULTIPLIERS = {
	fml = 1.5,
	goldfood = 1.5,
	hard = 1,
	medium = 1,
}
local ENEMY_DAMAGE_MULTIPLIERS = {
	fml = 0.7,
	goldfood = 0.7,
	hard = 1,
	medium = 2,
}
local GOLD_PICKED_UP_MULTIPLIER = {
	medium = {
		0.6,
		0.8,
		1,
		1.2,
	},
	hard = {
		1,
		1.2,
		1.4,
		1.6,
	},
	fml = {
		1.4,
		1.6,
		1.8,
		2,
	},
	goldfood = {
		1.4,
		1.6,
		1.8,
		2,
	},
}
local COLOSSEUM_WAVE_MAX_MULTIPLIER = {
	fml = 15,
	goldfood = 15,
	hard = 10,
	medium = 5,
}
local DIFFICULTY_LOC_STRINGS = {
	fml = "loc_options_difficulty_fml",
	goldfood = "loc_options_difficulty_fml",
	hard = "loc_options_difficulty_hard",
	medium = "loc_options_difficulty_medium",
}
local DIFFICULTY_CLASSES = {
	"medium",
	"hard",
	"fml",
}
local ALL_DIFFICULTY_CLASSES = {
	"medium",
	"hard",
	"fml",
	"goldfood",
}
local DIFFICULTY_CLASSES_LOOKUP = table.make_bimap(ALL_DIFFICULTY_CLASSES)

rawset(_G, "DIFFICULTY_LOC_STRINGS", DIFFICULTY_LOC_STRINGS)
rawset(_G, "DIFFICULTY_DEFAULT", "hard")
rawset(_G, "COLOSSEUM_DIFFICULTY", "fml")
rawset(_G, "ALL_DIFFICULTY_CLASSES", ALL_DIFFICULTY_CLASSES)
rawset(_G, "DIFFICULTY_CLASSES", DIFFICULTY_CLASSES)
rawset(_G, "DIFFICULTY_CLASSES_LOOKUP", DIFFICULTY_CLASSES_LOOKUP)
rawset(_G, "AVATAR_DAMAGE_MULTIPLIERS", AVATAR_DAMAGE_MULTIPLIERS)
rawset(_G, "ENEMY_DAMAGE_MULTIPLIERS", ENEMY_DAMAGE_MULTIPLIERS)
rawset(_G, "GOLD_PICKED_UP_MULTIPLIER", GOLD_PICKED_UP_MULTIPLIER)
rawset(_G, "COLOSSEUM_WAVE_MAX_MULTIPLIER", COLOSSEUM_WAVE_MAX_MULTIPLIER)

DifficultyManager = manager("DifficultyManager")

DifficultyManager.setup = function (self)
	self:_store_state()

	self._objects = {}
	self._difficulty = Application.user_setting("slayer", "difficulty") or _G.DIFFICULTY_DEFAULT

	if self._difficulty == "easy" then
		self._difficulty = "medium"
	end
end

DifficultyManager.teardown = function (self)
	if self._event_delegate then
		self._event_delegate:unregister(self)
	end

	self:_restore_state()
end

DifficultyManager.set_event_delegate = function (self, event_delegate)
	if self._event_delegate then
		self._event_delegate:unregister(self)
	end

	self._event_delegate = event_delegate

	if self._event_delegate then
		self._event_delegate:register(self, "on_party_changed")
	end
end

DifficultyManager.set_network_router = function (self, network_router)
	if self._network_router then
		self._network_router:unregister(self)
	end

	self._network_router = network_router

	if self._network_router then
		self._network_router:register(self, "from_server_set_difficulty")
	end
end

DifficultyManager.register = function (self, obj)
	self._objects[obj] = true
end

DifficultyManager.unregister = function (self, obj)
	self._objects[obj] = nil
end

DifficultyManager.difficulty_setting = function (self)
	return self._difficulty
end

DifficultyManager.set_difficulty_setting = function (self, new_setting)
	local old_setting = DifficultyManager:difficulty_setting()

	Application.set_user_setting("slayer", "difficulty", new_setting)
	Application.save_user_settings()

	self._difficulty = new_setting

	if old_setting ~= new_setting then
		self:_trigger_difficulty_change()

		if self._event_delegate then
			self._event_delegate:trigger("difficulty_setting_changed", new_setting)
		end
	end
end

DifficultyManager.num_players = function (self)
	local num_players = PartyManager:get_players_count() or 1

	num_players = math.max(num_players, 1)

	return num_players
end

DifficultyManager.interpolate_increasing_ahgse = function (self, map)
	return math.interpolate_increasing(map, self:difficulty_ahgse())
end

DifficultyManager.interpolate_cooldown_ahgse = function (self, dec_map)
	local inv_map = TempTableFactory:get()

	for key, val in pairs(dec_map) do
		inv_map[key] = 1 / val
	end

	local inverted = self:interpolate_increasing_ahgse(inv_map)

	return 1 / inverted
end

DifficultyManager.difficulty_ahgse = function (self)
	local num_players = self:num_players()
	local difficulty_setting = self:difficulty_setting()
	local multiplier = (AHGSE_MULTIPLIER[difficulty_setting] or 1) + ((self.difficulty_multiplier or 1) - 1)
	local ahgse = num_players * multiplier

	return ahgse
end

DifficultyManager.set_difficulty_multiplier = function (self, multiplier)
	self.difficulty_multiplier = multiplier
end

DifficultyManager.difficulty_speed = function (self)
	local difficulty_setting = self:difficulty_setting()
	local speed_multiplier = (DIFFICULTY_SPEED_MULTIPLIER[difficulty_setting] or 1) * (self.difficulty_multiplier or 1)

	return math.clamp(speed_multiplier, 0, 2)
end

DifficultyManager.avatar_damage_multiplier = function (self)
	local difficulty_setting = self:difficulty_setting()

	return AVATAR_DAMAGE_MULTIPLIERS[difficulty_setting] * (self.difficulty_multiplier or 1)
end

DifficultyManager.enemy_damage_multiplier = function (self)
	local difficulty_setting = self:difficulty_setting()

	return ENEMY_DAMAGE_MULTIPLIERS[difficulty_setting] * (1 / (self.difficulty_multiplier or 1))
end

DifficultyManager.gold_picked_up_multiplier = function (self)
	local difficulty = self:difficulty_setting()
	local num_players = self:num_players()

	num_players = math.clamp(num_players, 1, 4)

	return GOLD_PICKED_UP_MULTIPLIER[difficulty][num_players] * (self.difficulty_multiplier or 1)
end

DifficultyManager._trigger_difficulty_change = function (self)
	if self._event_delegate == nil then
		return
	end

	local new_difficulty = self:difficulty_ahgse()

	for obj, _ in pairs(self._objects) do
		obj:difficulty_changed(new_difficulty)
	end
end

DifficultyManager.on_party_changed = function (self, players, players_map, players_type, players_count)
	self:_trigger_difficulty_change()
end

DifficultyManager.from_server_set_difficulty = function (self, sender, difficulty)
	DifficultyManager:set_difficulty_setting(ALL_DIFFICULTY_CLASSES[difficulty])
end

DifficultyManager.setup_console_library = function (self)
	return {
		text = "Difficulty manager. Difficulty is measured in AHGSE.",
		parts = {
			set = {
				usage = "[42|medium|hard|fml]",
				autocomple = {
					"medium",
					"hard",
					"fml",
				},
				fun = function (difficulty)
					if difficulty and tonumber(difficulty) then
						difficulty = tonumber(difficulty)
						self._difficulty_override = difficulty

						self:_trigger_difficulty_change()

						return sprintf("Difficulty override set to %f AHGSE", difficulty)
					elseif difficulty then
						self:set_difficulty_setting(difficulty)
					elseif self._difficulty_override then
						self._difficulty_override = nil

						self:_trigger_difficulty_change()

						return "Removed difficulty override"
					else
						return {
							error = "Expected a number",
						}
					end
				end,
			},
		},
	}
end
