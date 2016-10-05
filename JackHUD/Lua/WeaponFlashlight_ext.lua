
local flash_cbk = WeaponFlashLight.init

function WeaponFlashLight:init(unit)
	flash_cbk(self, unit)
	if JackHUD:GetOption("enable_flashlight_extender") then
		self._light:set_spot_angle_end(math.clamp(JackHUD:GetOption("flashlight_angle"), 0, 160))
		self._light:set_far_range(JackHUD:GetOption("flashlight_range"))
	end
end
