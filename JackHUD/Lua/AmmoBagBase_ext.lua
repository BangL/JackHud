
	local spawn_original = AmmoBagBase.spawn
	local init_original = AmmoBagBase.init
	local sync_setup_original = AmmoBagBase.sync_setup
	local _set_visual_stage_original = AmmoBagBase._set_visual_stage
	local destroy_original = AmmoBagBase.destroy
	
	function AmmoBagBase.spawn(pos, rot, ammo_upgrade_lvl, peer_id, ...)
		local unit = spawn_original(pos, rot, ammo_upgrade_lvl, peer_id, ...)
		local key = tostring(unit:key())
		managers.gameinfo:event("bag_deployable", "create", key, unit, "ammo_bag")
		managers.gameinfo:event("bag_deployable", "set_owner", key, peer_id)
		return unit
	end
	
	function AmmoBagBase:init(unit, ...)
		local key = tostring(unit:key())
		managers.gameinfo:event("bag_deployable", "create", key, unit, "ammo_bag")
		init_original(self, unit, ...)
		managers.gameinfo:event("bag_deployable", "set_max_amount", key, self._max_ammo_amount * 100)
	end
	
	function AmmoBagBase:sync_setup(ammo_upgrade_lvl, peer_id, ...)
		managers.gameinfo:event("bag_deployable", "set_owner", tostring(self._unit:key()), peer_id)
		return sync_setup_original(self, ammo_upgrade_lvl, peer_id, ...)
	end
	
	function AmmoBagBase:_set_visual_stage(...)
		managers.gameinfo:event("bag_deployable", "set_amount", tostring(self._unit:key()), self._ammo_amount * 100)
		return _set_visual_stage_original(self, ...)
	end
	
	function AmmoBagBase:destroy(...)
		managers.gameinfo:event("bag_deployable", "destroy", tostring(self._unit:key()))
		return destroy_original(self, ...)
	end
