
	local init_original = ObjectInteractionManager.init
	local update_original = ObjectInteractionManager.update
	local add_unit_original = ObjectInteractionManager.add_unit
	local remove_unit_original = ObjectInteractionManager.remove_unit
	local interact_original = ObjectInteractionManager.interact
	local interupt_action_interact_original = ObjectInteractionManager.interupt_action_interact
	local init_original = ObjectInteractionManager.init

	function ObjectInteractionManager:init(...)
		init_original(self, ...)
		self._queued_units = {}
		if managers.gameinfo and JackHUD:GetOption("remove_answered_pager_contour") then
			managers.gameinfo:register_listener("pager_contour_remover", "pager", "answered", callback(nil, _G, "pager_answered_clbk"))
		end
	end
	
	function pager_answered_clbk(event, key, data)
		managers.enemy:add_delayed_clbk("contour_remove_" .. key, callback(nil, _G, "remove_answered_pager_contour_clbk", data.unit), Application:time() + 0.01)
	end

	function remove_answered_pager_contour_clbk(unit)
		if alive(unit) then
			unit:contour():remove(tweak_data.interaction.corpse_alarm_pager.contour_preset)
		end
	end
	
	function ObjectInteractionManager:update(t, ...)
		update_original(self, t, ...)
		self:_process_queued_units(t)
	end
	
	function ObjectInteractionManager:add_unit(unit, ...)
		self:add_unit_clbk(unit)
		return add_unit_original(self, unit, ...)
	end
	
	function ObjectInteractionManager:remove_unit(unit, ...)
		self:remove_unit_clbk(unit)
		return remove_unit_original(self, unit, ...)
	end
	
	function ObjectInteractionManager:interact(...)
		if alive(self._active_unit) and self._active_unit:interaction().tweak_data == "corpse_alarm_pager" then
			managers.gameinfo:event("pager", "answered", tostring(self._active_unit:key()))
		end
		
		return interact_original(self, ...)
	end
	
	function ObjectInteractionManager:interupt_action_interact(...)
		if alive(self._active_unit) and self._active_unit:interaction() and self._active_unit:interaction().tweak_data == "corpse_alarm_pager" then
			managers.gameinfo:event("pager", "remove", tostring(self._active_unit:key()))
		end
		
		return interupt_action_interact_original(self, ...)
	end
	
	
	function ObjectInteractionManager:add_unit_clbk(unit)
		self._queued_units[tostring(unit:key())] = unit
	end
	
	function ObjectInteractionManager:remove_unit_clbk(unit)
		local key = tostring(unit:key())
		
		if self._queued_units[key] then
			self._queued_units[key] = nil
		else
			managers.gameinfo:event("interactive_unit", "remove", key, unit)
		end
	end
	
	function ObjectInteractionManager:_process_queued_units(t)
		for key, unit in pairs(self._queued_units) do
			if alive(unit) then
				managers.gameinfo:event("interactive_unit", "add", key, unit)
			end
		end
	
		self._queued_units = {}
	end