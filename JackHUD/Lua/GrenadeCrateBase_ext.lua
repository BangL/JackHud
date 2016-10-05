
	local init_original = GrenadeCrateBase.init
	local _set_visual_stage_original = GrenadeCrateBase._set_visual_stage
	local destroy_original = GrenadeCrateBase.destroy
	local custom_init_original = CustomGrenadeCrateBase.init
	
	function GrenadeCrateBase:init(unit, ...)
		local key = tostring(unit:key())
		managers.gameinfo:event("bag_deployable", "create", key, unit, "grenade_crate")
		init_original(self, unit, ...)
		managers.gameinfo:event("bag_deployable", "set_max_amount", key, self._max_grenade_amount)
	end
	
	function GrenadeCrateBase:_set_visual_stage(...)
		managers.gameinfo:event("bag_deployable", "set_amount", tostring(self._unit:key()), self._grenade_amount)
		return _set_visual_stage_original(self, ...)
	end
	
	function GrenadeCrateBase:destroy(...)
		managers.gameinfo:event("bag_deployable", "destroy", tostring(self._unit:key()))
		return destroy_original(self, ...)
	end
	
	function CustomGrenadeCrateBase:init(unit, ...)
		local key = tostring(unit:key())
		managers.gameinfo:event("bag_deployable", "create", key, unit, "grenade_crate", true)
		custom_init_original(self, unit, ...)
		managers.gameinfo:event("bag_deployable", "set_max_amount", key, self._max_grenade_amount)
	end
