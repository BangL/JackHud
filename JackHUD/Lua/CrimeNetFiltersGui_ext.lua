
local filter_close_cbk = CrimeNetFiltersGui.close

function CrimeNetFiltersGui:close()
	filter_close_cbk(self)
	if JackHUD:GetOption("enable_filtersettings") then
		managers.network.matchmake:save_persistent_settings()
	end
end
