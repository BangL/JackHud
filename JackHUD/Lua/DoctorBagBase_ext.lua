
	local spawn_original = DoctorBagBase.spawn
	local init_original = DoctorBagBase.init
	local sync_setup_original = DoctorBagBase.sync_setup
	local _set_visual_stage_original = DoctorBagBase._set_visual_stage
	local destroy_original = DoctorBagBase.destroy
	
	function DoctorBagBase.spawn(pos, rot, amount_upgrade_lvl, peer_id, ...)
		local unit = spawn_original(pos, rot, amount_upgrade_lvl, peer_id, ...)
		local key = tostring(unit:key())
		managers.gameinfo:event("bag_deployable", "create", key, unit, "doc_bag")
		managers.gameinfo:event("bag_deployable", "set_owner", key, peer_id)
		return unit
	end
	
	function DoctorBagBase:init(unit, ...)
		local key = tostring(unit:key())
		managers.gameinfo:event("bag_deployable", "create", key, unit, "doc_bag")
		init_original(self, unit, ...)
		managers.gameinfo:event("bag_deployable", "set_max_amount", key, self._max_amount)
	end
	
	function DoctorBagBase:sync_setup(amount_upgrade_lvl, peer_id, ...)
		managers.gameinfo:event("bag_deployable", "set_owner", tostring(self._unit:key()), peer_id)
		return sync_setup_original(self, amount_upgrade_lvl, peer_id, ...)
	end
	
	function DoctorBagBase:_set_visual_stage(...)
		managers.gameinfo:event("bag_deployable", "set_amount", tostring(self._unit:key()), self._amount)
		return _set_visual_stage_original(self, ...)
	end
	
	function DoctorBagBase:destroy(...)
		managers.gameinfo:event("bag_deployable", "destroy", tostring(self._unit:key()))
		return destroy_original(self, ...)
	end