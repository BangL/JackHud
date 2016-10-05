
	local _start_tape_loop_original = SecurityCamera._start_tape_loop
	local _deactivate_tape_loop_original = SecurityCamera._deactivate_tape_loop
	
	function SecurityCamera:_start_tape_loop(tape_loop_t, ...)
		managers.gameinfo:event("tape_loop", "start", tostring(self._unit:key()), self._unit, tape_loop_t + 6)
		return _start_tape_loop_original(self, tape_loop_t, ...)
	end
	
	function SecurityCamera:_deactivate_tape_loop(...)
		managers.gameinfo:event("tape_loop", "stop", tostring(self._unit:key()))
		return _deactivate_tape_loop_original(self, ...)
	end