
local init_cbk = NetworkMatchMakingSTEAM.init

local settings_file = SavePath .. "CrimeNetFilter.ini"

function NetworkMatchMakingSTEAM:init()
	init_cbk(self)
	if JackHUD and JackHUD:GetOption("enable_filtersettings") then
		self:_load_persistent_settings()
	end
end

function NetworkMatchMakingSTEAM:save_persistent_settings()

	managers.network.matchmake:search_lobby(Global.game_settings.search_friends_only)
	
	local file, err = io.open(settings_file, "w")
		if not file then
			io.stderr:write(err .. "\n")
			return
		end
		
		file:write("#Generated file for persistent CrimeNet filter settings, don't mess with it unless you know what you're doing\n")
		file:write("friends_only " .. tostring(self._search_friends_only) .. "\n")
		file:write("appropriate_jobs " .. tostring(self._search_appropriate_jobs) .. "\n")
		file:write("max_lobbies " .. tostring(self._lobby_return_count) .. "\n")
		file:write("distance " .. tostring(self._distance_filter) .. "\n")
		for k, v in pairs(self._lobby_filters) do
			file:write(tostring(k) .. " " .. tostring(self._lobby_filters[k].value) .. "\n")
		end
		
		file:close()
end

function NetworkMatchMakingSTEAM:_load_persistent_settings()
			local file, err = io.open(settings_file, "r")
		if not file then
			io.stderr:write(err .. "\n")
			return
		end
		
		local line = file:read()
		while line do
			if not string.match(line, "^#.+") then
				local key, val = string.match(line, "^(.+) (.+)$")
				
				if key and val then
					if key == "friends_only" then
						local friends_only = val  == "true" and true or false
						Global.game_settings.search_friends_only = friends_only
						self._search_friends_only = friends_only
					elseif key == "appropriate_jobs" then
						local appropriate_jobs = val  == "true" and true or false
						Global.game_settings.search_appropriate_jobs = appropriate_jobs
						self._search_appropriate_jobs = appropriate_jobs
					elseif key == "max_lobbies" then
						self:set_lobby_return_count(tonumber(val))
					elseif key == "distance" then
						self:set_distance_filter(tonumber(val))
					elseif key == "num_players" or key == "state" or key == "difficulty" or key == "job_id" or key == "kicking_allowed" or key == "job_plan" then
						self:add_lobby_filter(key, tonumber(val), "equal")
					else
						io.stderr:write("Unknown key/value pair: " .. key .. ", " .. val .. "\n")
					end
				else
					io.stderr:write("Unable to parse line: " .. line .. "\n")
				end
			end
			line = file:read()
		end
	end
