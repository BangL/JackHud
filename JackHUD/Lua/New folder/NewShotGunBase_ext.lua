
local on_equip_original = NewShotgunBase.on_equip
local toggle_gadget_original = NewShotgunBase.toggle_gadget

function NewShotgunBase:on_equip(...)
	if self._has_gadget then
		self:_setup_laser()
		if alive(self._second_gun) then
			self._second_gun:base():_setup_laser()
		end
	end
	self:set_gadget_on(JackHUD:GetOption("remember_gadget_state") and self._stored_gadget_on or 0, false)
	return on_equip_original(self, ...)
end

function NewShotgunBase:toggle_gadget()
	if toggle_gadget_original(self) then
		self._stored_gadget_on = self._gadget_on
		return true
	end
end

function NewShotgunBase:_setup_laser()
	for _, part in pairs(self._parts) do
		local base = part.unit and part.unit:base()
		if base and base.set_color_by_theme then
			base:set_color_by_theme("player")
		end
	end
end