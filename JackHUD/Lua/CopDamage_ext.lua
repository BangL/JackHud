
	local _on_damage_received_original = CopDamage._on_damage_received
	local chk_killshot_original = CopDamage.chk_killshot
	local bullet_original = CopDamage.damage_bullet
	local explosion_original = CopDamage.damage_explosion
	local melee_original = CopDamage.damage_melee
	local fire_original = CopDamage.damage_fire
	local sync_bullet_original = CopDamage.sync_damage_bullet
	local sync_explosion_original = CopDamage.sync_damage_explosion
	local sync_melee_original = CopDamage.sync_damage_melee
	local sync_fire_original = CopDamage.sync_damage_fire

	function CopDamage:_on_damage_received(damage_info, ...)
		if self._unit:in_slot(16) then
			managers.gameinfo:event("minion", "set_health", tostring(self._unit:key()), self._health)
		end
		return _on_damage_received_original(self, damage_info, ...)
	end
	
	function CopDamage:chk_killshot(attacker_unit, ...)
		if alive(attacker_unit) and managers.gameinfo:get_minions(tostring(attacker_unit:key())) then
			managers.gameinfo:event("minion", "increment_kills", tostring(attacker_unit:key()))
		end
		
		return chk_killshot_original(self, attacker_unit, ...)
	end

	function CopDamage:_process_kill(aggressor, i_body)
		if alive(aggressor) and aggressor:base() then
			if aggressor:base().sentry_gun then
				aggressor = aggressor:base():get_owner() or managers.criminals:character_unit_by_peer_id(aggressor:base()._owner_id)
			elseif aggressor:base()._projectile_entry then
				aggressor = aggressor:base()._thrower_unit
			end
		end
		if alive(aggressor) then
			local panel_id
			if aggressor == managers.player:player_unit() then
				panel_id = HUDManager.PLAYER_PANEL
			else
				local char_data = managers.criminals:character_data_by_unit(aggressor)
				panel_id = char_data and char_data.panel_id
			end
			if panel_id then
				local body_name = i_body and self._unit:body(i_body) and self._unit:body(i_body):name()
				local headshot = self._head_body_name and body_name and body_name == self._ids_head_body_name or false
				local is_special = managers.groupai:state()._special_unit_types[self._unit:base()._tweak_table] or false
				managers.hud:increment_kill_count(panel_id, is_special, headshot)
				return
			end
		end
	end

	function CopDamage:damage_bullet(attack_data, ...)
		local result = bullet_original(self, attack_data, ...)
		if result and result.type == "death" then self:_process_kill(attack_data.attacker_unit, self._unit:get_body_index(attack_data.col_ray.body:name())) end
		return result
	end

	function CopDamage:damage_explosion(attack_data, ...)
		if not self:dead() then
			explosion_original(self, attack_data, ...)
			if self:dead() and alive(attack_data.attacker_unit) then
				self:_process_kill(attack_data.attacker_unit, attack_data.col_ray and attack_data.col_ray.body and self._unit:get_body_index(attack_data.col_ray.body:name()))
			end
		end
	end

	function CopDamage:damage_melee(attack_data, ...)
		local result = melee_original(self, attack_data, ...)
		if result and result.type == "death" then self:_process_kill(attack_data.attacker_unit, self._unit:get_body_index(attack_data.col_ray.body:name())) end
		return result
	end

	function CopDamage:damage_fire(attack_data, ...)
		--TODO: Fix this when Overkill has learned how to code
		if not self:dead() then
			fire_original(self, attack_data, ...)
			if self:dead() and alive(attack_data.attacker_unit) then
				self:_process_kill(attack_data.attacker_unit, attack_data.col_ray and attack_data.col_ray.body and self._unit:get_body_index(attack_data.col_ray.body:name())) 
			end
		end
		--local result = fire_original(self, attack_data, ...)
		--if result and result.type == "death" then self:_process_kill(attack_data.attacker_unit, self._unit:get_body_index(attack_data.col_ray.body:name())) end
		--return result
	end

	function CopDamage:sync_damage_bullet(attacker_unit, damage_percent, i_body, hit_offset_height, variant, death, ...)
		if death then self:_process_kill(attacker_unit, i_body) end
		return sync_bullet_original(self, attacker_unit, damage_percent, i_body, hit_offset_height, variant, death, ...)
	end

	function CopDamage:sync_damage_explosion(attacker_unit, damage_percent, i_attack_variant, variant, death, ...)
		if death then self:_process_kill(attacker_unit) end
		return sync_explosion_original(self, attacker_unit, damage_percent, i_attack_variant, variant, death, ...)
	end

	function CopDamage:sync_damage_melee(attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death, ...)
		if death then
			self:_process_kill(attacker_unit, i_body)
		end
		return sync_melee_original(self, attacker_unit, damage_percent, damage_effect_percent, i_body, hit_offset_height, variant, death, ...)
	end

	function CopDamage:sync_damage_fire(attacker_unit, damage_percent, death, ...)
		if death then
			self:_process_kill(attacker_unit)
		end
		return sync_fire_original(self, attacker_unit, damage_percent, death, ...)
	end
