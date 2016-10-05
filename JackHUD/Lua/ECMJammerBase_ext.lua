
	local init_original = ECMJammerBase.init
	local set_active_original = ECMJammerBase.set_active
	local _set_feedback_active_original = ECMJammerBase._set_feedback_active
	local update_original = ECMJammerBase.update
	local _send_net_event_original = ECMJammerBase._send_net_event
	local sync_net_event_original = ECMJammerBase.sync_net_event
	local destroy_original = ECMJammerBase.destroy
	
	function ECMJammerBase:init(...)
		init_original(self, ...)
		managers.gameinfo:event("ecm", "create", tostring(self._unit:key()), self._unit)
	end
	
	function ECMJammerBase:set_active(active, ...)
		managers.gameinfo:event("ecm", "set_jammer_active", tostring(self._unit:key()), active)
		return set_active_original(self, active, ...)
	end
	
	function ECMJammerBase:_set_feedback_active(state, ...)
		if not state then
			local peer_id = managers.network:session() and managers.network:session():local_peer() and managers.network:session():local_peer():id()
			if peer_id and (peer_id == self._owner_id) and managers.player:has_category_upgrade("ecm_jammer", "can_retrigger") then
				self._feedback_recharge_t = tweak_data.upgrades.ecm_feedback_retrigger_interval or 60
				managers.gameinfo:event("ecm", "set_retrigger_active", tostring(self._unit:key()), true)
			end
		end
	
		return _set_feedback_active_original(self, state, ...)
	end
	
	function ECMJammerBase:update(unit, t, dt, ...)
		update_original(self, unit, t, dt, ...)
		
		if self._chk_feedback_retrigger_t then
			self._feedback_recharge_t = self._chk_feedback_retrigger_t
		elseif self._feedback_recharge_t then
			self._feedback_recharge_t = self._feedback_recharge_t - dt
		end
			
		if self._feedback_recharge_t or self._jammer_active then
			managers.gameinfo:event("ecm", "update", tostring(self._unit:key()), self._battery_life or 0, self._feedback_recharge_t or 0)
		end
	end
	
	function ECMJammerBase:_send_net_event(event_id, ...)
		if event_id == self._NET_EVENTS.feedback_restart then
			self._feedback_recharge_t = nil
			managers.gameinfo:event("ecm", "set_retrigger_active", tostring(self._unit:key()), false)
		end
		
		return _send_net_event_original(self, event_id, ...)
	end
	
	function ECMJammerBase:sync_net_event(event_id, ...)
		if event_id == self._NET_EVENTS.feedback_restart then
			self._feedback_recharge_t = nil
			managers.gameinfo:event("ecm", "set_retrigger_active", tostring(self._unit:key()), false)
		end
		
		return sync_net_event_original(self, event_id, ...)
	end
	
	function ECMJammerBase:destroy(...)
		managers.gameinfo:event("ecm", "set_jammer_active", tostring(self._unit:key()), false)
		managers.gameinfo:event("ecm", "set_retrigger_active", tostring(self._unit:key()), false)
		managers.gameinfo:event("ecm", "destroy", tostring(self._unit:key()))
		destroy_original(self, ...)
	end