	local set_tweak_data_original = BaseInteractionExt.set_tweak_data
	
	function BaseInteractionExt:set_tweak_data(...)
		if self:active() then
			managers.interaction:remove_unit_clbk(self._unit)
		end
		
		set_tweak_data_original(self, ...)
		
		if self:active() then
			managers.interaction:add_unit_clbk(self._unit)
		end
	end