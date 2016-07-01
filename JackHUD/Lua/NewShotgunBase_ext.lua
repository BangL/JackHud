local toggle_gadget_original = NewRaycastWeaponBase.toggle_gadget
function NewRaycastWeaponBase:toggle_gadget()
	if toggle_gadget_original(self) then
		self._stored_gadget_on = self._gadget_on
		return true
	end
end

local on_equip_original = NewShotgunBase.on_equip
function NewShotgunBase:on_equip(user_unit, ...)
	on_equip_original(self, user_unit, ...)
	self:set_gadget_on(JackHUD:GetOption("remember_gadget_state") and self._stored_gadget_on or 0, false)
end