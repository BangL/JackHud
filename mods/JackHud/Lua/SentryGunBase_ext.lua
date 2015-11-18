if not JackHUD then
	return
end

if JackHUD and JackHUD._data and JackHUD._data.show_timers then
	SentryGunBase.SPAWNED_SENTRIES = {}

	local spawn_original = SentryGunBase.spawn
	local init_original = SentryGunBase.init
	local activate_as_module_original = SentryGunBase.activate_as_module
	local destroy_original = SentryGunBase.destroy

	function SentryGunBase.spawn(owner, pos, rot, ammo_multiplier, armor_multiplier, damage_multiplier, peer_id, ...)
		local unit = spawn_original(owner, pos, rot, ammo_multiplier, armor_multiplier, damage_multiplier, peer_id, ...)
		if not SentryGunBase.SPAWNED_SENTRIES[unit:key()] then
			SentryGunBase.SPAWNED_SENTRIES[unit:key()] = { unit = unit }
			UnitBase._do_listener_callback("on_sentry_create", unit)
		end
		SentryGunBase.SPAWNED_SENTRIES[unit:key()].owner = peer_id
		UnitBase._do_listener_callback("on_sentry_owner_update", unit, peer_id)
		return unit
	end

	function SentryGunBase:init(unit, ...)
		if not SentryGunBase.SPAWNED_SENTRIES[unit:key()] then
			SentryGunBase.SPAWNED_SENTRIES[unit:key()] = { unit = unit }
			UnitBase._do_listener_callback("on_sentry_create", unit)
		end
		init_original(self, unit, ...)
	end

	function SentryGunBase:activate_as_module(...)
		SentryGunBase.SPAWNED_SENTRIES[self._unit:key()] = nil
		UnitBase._do_listener_callback("on_sentry_destroy", self._unit)
		return activate_as_module_original(self, ...)
	end

	function SentryGunBase:destroy(...)
		SentryGunBase.SPAWNED_SENTRIES[self._unit:key()] = nil
		UnitBase._do_listener_callback("on_sentry_destroy", self._unit)
		return destroy_original(self, ...)
	end
end

local sync_setup_original = SentryGunBase.sync_setup
function SentryGunBase:sync_setup(upgrade_lvl, peer_id, ...)
	if JackHUD and JackHUD._data and JackHUD._data.show_timers then
		SentryGunBase.SPAWNED_SENTRIES[self._unit:key()].owner = peer_id
		UnitBase._do_listener_callback("on_sentry_owner_update", self._unit, peer_id)
	end
	sync_setup_original(self, upgrade_lvl, peer_id, ...)
	if JackHUD and JackHUD._data and JackHUD._data.enable_kill_counter then
		self._owner_id = self._owner_id or peer_id
	end
end