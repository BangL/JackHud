
	local spawn_original = SentryGunBase.spawn
	local init_original = SentryGunBase.init
	local sync_setup_original = SentryGunBase.sync_setup
	local activate_as_module_original = SentryGunBase.activate_as_module
	local destroy_original = SentryGunBase.destroy
	local load_original = SentryGunBase.load
	
	function SentryGunBase.spawn(owner, pos, rot, peer_id, ...)
		local unit = spawn_original(owner, pos, rot, peer_id, ...)
		managers.gameinfo:event("sentry", "create", tostring(unit:key()), unit)
		managers.gameinfo:event("sentry", "set_owner", tostring(unit:key()), peer_id)
		return unit
	end
	
	function SentryGunBase:init(unit, ...)
		managers.gameinfo:event("sentry", "create", tostring(unit:key()), unit)
		init_original(self, unit, ...)
	end
	
	function SentryGunBase:sync_setup(upgrade_lvl, peer_id, ...)
		self._owner_id = self._owner_id or peer_id
		managers.gameinfo:event("sentry", "set_owner", tostring(self._unit:key()), peer_id)
		return sync_setup_original(self, upgrade_lvl, peer_id, ...)
	end
	
	function SentryGunBase:activate_as_module(...)
		managers.gameinfo:event("sentry", "destroy", tostring(self._unit:key()))
		return activate_as_module_original(self, ...)
	end
	
	function SentryGunBase:destroy(...)
		managers.gameinfo:event("sentry", "destroy", tostring(self._unit:key()))
		return destroy_original(self, ...)
	end
	
	function SentryGunBase:load(...)
		load_original(self, ...)
		
		if self._is_module then
			managers.gameinfo:event("sentry", "destroy", tostring(self._unit:key()))
		end
	end