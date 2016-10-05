
--[[
	Load our localization keys for our menu, and menu items.
]]
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_jackhud", function( loc )
	for _, filename in pairs(file.GetFiles(JackHUD._path .. "Loc/")) do
		local str = filename:match('^(.*).txt$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			loc:load_localization_file(JackHUD._path .. "Loc/" .. filename)
			break
		end
	end
	loc:load_localization_file(JackHUD._path .. "Loc/english.txt", false)
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_jackhud", function(menu_manager, nodes)
	if nodes.main then
		MenuHelper:AddMenuItem(nodes.main, "crimenet_contract_special", "menu_cn_premium_buy", "menu_cn_premium_buy_desc", "crimenet", "after")
	end
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_jackhud", function(menu_manager, menu_nodes)
	--[[
		Add "Reset all options" to the jackhud main menu.
	]]
	MenuHelper:AddButton({
		id = "jackhud_reset",
		title = "jackhud_reset",
		desc = "jackhud_reset_desc",
		callback = "callback_jackhud_reset",
		menu_id = "jackhud_options",
		priority = 100
	})
	MenuHelper:AddDivider({
		id = "jackhud_reset_divider",
		size = 16,
		menu_id = "jackhud_options",
		priority = 99
	})
end)

--[[
	Setup our menu callbacks, load our saved data, and build the menu from our json file.
]]
Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_jackhud", function( menu_manager )

	--[[
		Setup our callbacks as defined in our item callback keys, and perform our logic on the data retrieved.
	]]

	-- Screen skipping
	MenuCallbackHandler.callback_skip_black_screen = function(self, item)
		JackHUD._data.skip_black_screen = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_skip_stat_screen = function(self, item)
		JackHUD._data.skip_stat_screen = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_stat_screen_skip = function(self, item)
		JackHUD._data.stat_screen_skip = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_skip_card_picking = function(self, item)
		JackHUD._data.skip_card_picking = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_skip_loot_screen = function(self, item)
		JackHUD._data.skip_loot_screen = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_loot_screen_skip = function(self, item)
		JackHUD._data.loot_screen_skip = item:value()
		JackHUD:Save()
	end

	-- HUD Lists (Timers)
	MenuCallbackHandler.callback_show_timers = function(self, item)
		JackHUD._data.show_timers = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_equipment = function(self, item)
		JackHUD._data.show_equipment = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_sentries = function(self, item)
		JackHUD._data.show_sentries = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_hide_empty_sentries = function(self, item)
		JackHUD._data.hide_empty_sentries = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_ecms = function(self, item)
		JackHUD._data.show_ecms = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_ecm_retrigger = function(self, item)
		JackHUD._data.show_ecm_retrigger = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_minions = function(self, item)
		JackHUD._data.show_minions = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_pagers = function(self, item)
		JackHUD._data.show_pagers = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_tape_loop = function(self, item)
		JackHUD._data.show_tape_loop = (item:value() =="on")
		JackHUD:Save()
	end

	-- HUD Lists (Counters)
	MenuCallbackHandler.callback_show_enemies = function(self, item)
		JackHUD._data.show_enemies = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_aggregate_enemies = function(self, item)
		JackHUD._data.aggregate_enemies = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_turrets = function(self, item)
		JackHUD._data.show_turrets = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_civilians = function(self, item)
		JackHUD._data.show_civilians = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_hostages = function(self, item)
		JackHUD._data.show_hostages = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_minion_count = function(self, item)
		JackHUD._data.show_minion_count = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_pager_count = function(self, item)
		JackHUD._data.show_pager_count = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_loot = function(self, item)
		JackHUD._data.show_loot = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_aggregate_loot = function(self, item)
		JackHUD._data.aggregate_loot = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_separate_bagged_loot = function(self, item)
		JackHUD._data.separate_bagged_loot = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_gage_packages = function(self, item)
		JackHUD._data.show_gage_packages = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_special_pickups = function(self, item)
		JackHUD._data.show_special_pickups = (item:value() =="on")
		JackHUD:Save()
	end

	-- HUD Lists (Buffs)
	MenuCallbackHandler.callback_show_buffs = function(self, item)
		JackHUD._data.show_buffs = (item:value() =="on")
		JackHUD:Save()
	end

	MenuCallbackHandler.callback_enemy_color_r = function(self, item)
		JackHUD._data.enemy_color_r = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enemy_color_g = function(self, item)
		JackHUD._data.enemy_color_g = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enemy_color_b = function(self, item)
		JackHUD._data.enemy_color_b = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_civilian_color_r = function(self, item)
		JackHUD._data.civilian_color_r = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_civilian_color_g = function(self, item)
		JackHUD._data.civilian_color_g = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_civilian_color_b = function(self, item)
		JackHUD._data.civilian_color_b = item:value()
		JackHUD:Save()
	end

	-- Kill counter
	MenuCallbackHandler.callback_enable_kill_counter = function(self, item)
		JackHUD._data.enable_kill_counter = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_special_kills = function(self, item)
		JackHUD._data.show_special_kills = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_headshot_kills = function(self, item)
		JackHUD._data.show_headshot_kills = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_ai_kills = function(self, item)
		JackHUD._data.show_ai_kills = (item:value() =="on")
		JackHUD:Save()
	end

	-- HPS Meter
	MenuCallbackHandler.callback_enable_hps_meter = function(self, item)
		JackHUD._data.enable_hps_meter = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_hps_refresh_rate = function(self, item)
		JackHUD._data.hps_refresh_rate = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_hps_current = function(self, item)
		JackHUD._data.show_hps_current = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_current_hps_timeout = function(self, item)
		JackHUD._data.current_hps_timeout = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_hps_total = function(self, item)
		JackHUD._data.show_hps_total = (item:value() =="on")
		JackHUD:Save()
	end

	-- Flashlight extender
	MenuCallbackHandler.callback_enable_flashlight_extender = function(self, item)
		JackHUD._data.enable_flashlight_extender = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_flashlight_range = function(self, item)
		JackHUD._data.flashlight_range = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_flashlight_angle = function(self, item)
		JackHUD._data.flashlight_angle = item:value()
		JackHUD:Save()
	end

	-- Laser options
	MenuCallbackHandler.callback_enable_laser_options = function(self, item)
		JackHUD._data.enable_laser_options = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_r = function(self, item)
		JackHUD._data.laser_color_r = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_g = function(self, item)
		JackHUD._data.laser_color_g = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_b = function(self, item)
		JackHUD._data.laser_color_b = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_rainbow = function(self, item)
		JackHUD._data.laser_color_rainbow = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_a = function(self, item)
		JackHUD._data.laser_color_a = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_glow = function(self, item)
		JackHUD._data.laser_glow = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_light = function(self, item)
		JackHUD._data.laser_light = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_laser_options_others = function(self, item)
		JackHUD._data.enable_laser_options_others = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_r_others = function(self, item)
		JackHUD._data.laser_color_r_others = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_g_others = function(self, item)
		JackHUD._data.laser_color_g_others = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_b_others = function(self, item)
		JackHUD._data.laser_color_b_others = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_rainbow_others = function(self, item)
		JackHUD._data.laser_color_rainbow_others = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_a_others = function(self, item)
		JackHUD._data.laser_color_a_others = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_glow_others = function(self, item)
		JackHUD._data.laser_glow_others = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_light_others = function(self, item)
		JackHUD._data.laser_light_others = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_laser_options_snipers = function(self, item)
		JackHUD._data.enable_laser_options_snipers = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_r_snipers = function(self, item)
		JackHUD._data.laser_color_r_snipers = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_g_snipers = function(self, item)
		JackHUD._data.laser_color_g_snipers = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_b_snipers = function(self, item)
		JackHUD._data.laser_color_b_snipers = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_rainbow_snipers = function(self, item)
		JackHUD._data.laser_color_rainbow_snipers = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_a_snipers = function(self, item)
		JackHUD._data.laser_color_a_snipers = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_glow_snipers = function(self, item)
		JackHUD._data.laser_glow_snipers = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_light_snipers = function(self, item)
		JackHUD._data.laser_light_snipers = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_laser_options_turret = function(self, item)
		JackHUD._data.enable_laser_options_turret = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_r_turret = function(self, item)
		JackHUD._data.laser_color_r_turret = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_g_turret = function(self, item)
		JackHUD._data.laser_color_g_turret = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_b_turret = function(self, item)
		JackHUD._data.laser_color_b_turret = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_rainbow_turret = function(self, item)
		JackHUD._data.laser_color_rainbow_turret = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_a_turret = function(self, item)
		JackHUD._data.laser_color_a_turret = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_glow_turret = function(self, item)
		JackHUD._data.laser_glow_turret = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_light_turret = function(self, item)
		JackHUD._data.laser_light_turret = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_laser_options_turretr = function(self, item)
		JackHUD._data.enable_laser_options_turretr = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_r_turretr = function(self, item)
		JackHUD._data.laser_color_r_turretr = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_g_turretr = function(self, item)
		JackHUD._data.laser_color_g_turretr = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_b_turretr = function(self, item)
		JackHUD._data.laser_color_b_turretr = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_rainbow_turretr = function(self, item)
		JackHUD._data.laser_color_rainbow_turretr = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_a_turretr = function(self, item)
		JackHUD._data.laser_color_a_turretr = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_glow_turretr = function(self, item)
		JackHUD._data.laser_glow_turretr = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_light_turretr = function(self, item)
		JackHUD._data.laser_light_turretr = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_laser_options_turretm = function(self, item)
		JackHUD._data.enable_laser_options_turretm = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_r_turretm = function(self, item)
		JackHUD._data.laser_color_r_turretm = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_g_turretm = function(self, item)
		JackHUD._data.laser_color_g_turretm = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_b_turretm = function(self, item)
		JackHUD._data.laser_color_b_turretm = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_rainbow_turretm = function(self, item)
		JackHUD._data.laser_color_rainbow_turretm = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_color_a_turretm = function(self, item)
		JackHUD._data.laser_color_a_turretm = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_glow_turretm = function(self, item)
		JackHUD._data.laser_glow_turretm = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_laser_light_turretm = function(self, item)
		JackHUD._data.laser_light_turretm = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_remember_gadget_state = function(self, item)
		JackHUD._data.remember_gadget_state = (item:value() =="on")
		JackHUD:Save()
	end

	-- Push to interact
	MenuCallbackHandler.callback_push_to_interact = function(self, item)
		JackHUD._data.push_to_interact = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_equipment_interrupt = function(self, item)
		JackHUD._data.equipment_interrupt = (item:value() =="on")
		JackHUD:Save()
	end

	-- Other
	MenuCallbackHandler.callback_enable_filtersettings = function(self, item)
		JackHUD._data.enable_filtersettings = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_lobby_skins_mode = function(self, item)
		JackHUD._data.lobby_skins_mode = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_buy_all_assets = function(self, item)
		JackHUD._data.enable_buy_all_assets = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_remove_answered_pager_contour = function(self, item)
		JackHUD._data.remove_answered_pager_contour = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_pacified = function(self, item)
		JackHUD._data.enable_pacified = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_suspicion_text = function(self, item)
		JackHUD._data.show_suspicion_text = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_melee_interaction = function(self, item)
		JackHUD._data.show_melee_interaction = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_reload_interaction = function(self, item)
		JackHUD._data.show_reload_interaction = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_interaction_circle = function(self, item)
		JackHUD._data.show_interaction_circle = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_interaction_text = function(self, item)
		JackHUD._data.show_interaction_text = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_text_borders = function(self, item)
		JackHUD._data.show_text_borders = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_truncate_name_tags = function(self, item)
		JackHUD._data.truncate_name_tags = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_client_ranks = function(self, item)
		JackHUD._data.show_client_ranks = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_own_rank = function(self, item)
		JackHUD._data.show_own_rank = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_colorize_names = function(self, item)
		JackHUD._data.colorize_names = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_stamina_meter = function(self, item)
		JackHUD._data.show_stamina_meter = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_armor_timer = function(self, item)
		JackHUD._data.show_armor_timer = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_show_inspire_timer = function(self, item)
		JackHUD._data.show_inspire_timer = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_anti_stealth_grenades = function(self, item)
		JackHUD._data.anti_stealth_grenades = (item:value() =="on")
		JackHUD:Save()
	end

	MenuCallbackHandler.callback_center_assault_banner = function(self, item)
		JackHUD._data.center_assault_banner = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enable_enhanced_assault_banner = function(self, item)
		JackHUD._data.enable_enhanced_assault_banner = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enhanced_assault_spawns = function(self, item)
		JackHUD._data.enhanced_assault_spawns = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enhanced_assault_time = function(self, item)
		JackHUD._data.enhanced_assault_time = (item:value() =="on")
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_enhanced_assault_count = function(self, item)
		JackHUD._data.enhanced_assault_count = (item:value() =="on")
		JackHUD:Save()
	end

	MenuCallbackHandler.callback_enable_objective_animation = function(self, item)
		JackHUD._data.enable_objective_animation = (item:value() =="on")
		JackHUD:Save()
	end

	MenuCallbackHandler.callback_interaction_color_r = function(self, item)
		JackHUD._data.interaction_color_r = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_interaction_color_g = function(self, item)
		JackHUD._data.interaction_color_g = item:value()
		JackHUD:Save()
	end
	MenuCallbackHandler.callback_interaction_color_b = function(self, item)
		JackHUD._data.interaction_color_b = item:value()
		JackHUD:Save()
	end

	MenuCallbackHandler.callback_jackhud_reset = function(self, item)
		local menu_title = managers.localization:text("jackhud_reset")
		local menu_message = managers.localization:text("jackhud_reset_message")
		local menu_options = {
			[1] = {
				text = managers.localization:text("jackhud_reset_ok"),
				callback = function()
					JackHUD:LoadDefaults()
					JackHUD:ForceReloadAllMenus()
					JackHUD:Save()
				end,
			},
			[2] = {
				text = managers.localization:text("jackhud_reset_cancel"),
				is_cancel_button = true,
			},
		}
		QuickMenu:new( menu_title, menu_message, menu_options, true )
	end

	--[[
		Load our previously saved data from our save file.
	]]
	JackHUD:Load()
	JackHUD:InitAllMenus()

	--[[
		Set keybind defaults
	]]
	LuaModManager:SetPlayerKeybind("load_pre", LuaModManager:GetPlayerKeybind("load_pre") or "f5")
	LuaModManager:SetPlayerKeybind("save_pre", LuaModManager:GetPlayerKeybind("save_pre") or "f6")
end )
