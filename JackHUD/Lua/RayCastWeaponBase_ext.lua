

	local setup_original = RaycastWeaponBase.setup
	local set_ammo_remaining_in_clip_original = RaycastWeaponBase.set_ammo_remaining_in_clip
	local on_equip_original = RaycastWeaponBase.on_equip
	
	function RaycastWeaponBase:setup(...)
		setup_original(self, ...)
		
		local user_unit = self._setup and self._setup.user_unit
		local player_unit = managers.player:player_unit()
		self._player_is_owner = alive(user_unit) and alive(player_unit) and user_unit:key() == player_unit:key()
	end
	
	function RaycastWeaponBase:set_ammo_remaining_in_clip(ammo, ...)
		if RaycastWeaponBase.LOCK_N_LOAD_ACTIVE and self._player_is_owner then
			local data = RaycastWeaponBase.LOCK_N_LOAD_ACTIVE
			if ammo <= data.max_threshold and ammo >= data.min_threshold then
				local bonus = math.clamp(data.max_bonus * math.pow(data.penalty, ammo - data.min_threshold), data.min_bonus, data.max_bonus)
				managers.gameinfo:event("buff", "set_value", "lock_n_load", { value = bonus, show_value = true })
			end
		end
		
		return set_ammo_remaining_in_clip_original(self, ammo, ...)
	end
