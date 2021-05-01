newTalent{
	name = "Living Stone", short_name = "WK_LIVING_STONE",
	type = {"spell/lapidary",1},
    image = "talents/livingstone.png",
	require = techs_con_req1,
	points = 5,
	sustain_mana = 20,
	sustain_equilibrium = 5,
	cooldown = 10,
	mode = "sustained",
	tactical = { BUFF = 2 },
   	getImmunity = function(self, t) return .2 * math.ceil(self:getTalentLevelRaw(t)) end,
    getResist = function(self, t) return self:combatStatScale("con", 12, 50, 0.75) end,
	restingRegen = function(self, t) return self:combatTalentScale(t, 0.5, 2.5, 0.75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "equilibrium_regen_on_rest", -t.restingRegen(self, t))
	end,
    activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
        local ret = {
			teleport = self:addTemporaryValue("teleport_immune", t.getImmunity(self, t)),
			knockback = self:addTemporaryValue("knockback_immune", t.getImmunity(self, t)),
            resPhys = self:addTemporaryValue("resists", {[DamageType.PHYSICAL]=t.getResist(self, t)}),
		}
        return ret
	end,
	deactivate = function(self, t, p)
        self:removeTemporaryValue("teleport_immune", p.teleport)
		self:removeTemporaryValue("knockback_immune", p.knockback)
        self:removeTemporaryValue("resists", p.resPhys)
		if p.particle then self:removeParticles(p.particle) end
		return true
	end,
	info = function(self, t)
        local immune = t.getImmunity(self, t) * 100
        local resist = t.getResist(self, t)
		local rest = t.restingRegen(self, t)
		return ([[Like stone, you are not easily moved nor damaged. While active, increases your resistances to being teleported and knocked back by %d%% and increases your physical resistance by %d%%.
		Physical resistance increases with Constitution.
		Also, resting will decrease your equilibrium by %0.2f per turn.]]):
		tformat(immune, resist, rest)
	end,
}

newTalent{
	name = "Liquefaction", short_name = "WK_LIQUEFACTION",
	type = {"spell/lapidary", 2},
    image = "talents/liquefaction.png",
	require = techs_con_req2,
	points = 5,
    mana = 20,
	equilibrium = 10,
	cooldown = 12,
	tactical = { ATTACKAREA = {PHYSICAL = 2}, DISABLE = 2 },
	range = 6,
	radius = function(self, t) return 4 end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t, selffire=self:spellFriendlyFire()}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 4, 105) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 6)) end,
	action = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		if not ammo then
			game.logPlayer(self, "You need an alchemist gem in your quiver.")
			return
		end

		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)

		-- Add a lasting map effect
		local dam = self:spellCrit(t.getDamage(self, t))
		game.level.map:addEffect(self,
			x, y, t.getDuration(self,t),
			DamageType.PHYSICAL_STUN, dam,
			self:getTalentRadius(t),
			5, nil,
			{type="gravity_well2"},
			nil, false
		)

		ammo = self:removeObject(self:getInven("QUIVER"), 1)
		if not ammo then return end

		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[Crush an alchemist gem and use the released power to vibrate the ground so quickly that it partially liquifies. Targets an area of radius %d dealing %d physical damage per turn with a 25%% chance to stun.
		The vibrations last for for %d turns.
		You have just enough control over the vibrations to not affect yourself.
		The damage done will increase with your Spellpower.]]):tformat(radius, damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}

newTalent{
	name = "Rejuvenation", short_name = "WK_REJUVINATION",
	type = {"spell/lapidary", 3},
    image = "talents/rejuvination.png",
	require = techs_con_req3,
	points = 5,
    mana = 10,
	equilibrium = 3,
	tactical = { HEAL = 2, BUFF = 2 },
	on_pre_use = function(self, t)
		return not self:hasEffect(self.EFF_MANASURGE) and not self:hasEffect(self.EFF_REGENERATION)
	end,
    cooldown = function(self, t) return self:combatTalentLimit(t, 10, 30, 16) end,
	getDuration = function(self, t) return 4 + math.ceil(self:getTalentLevelRaw(t)) end,
	getRegen = function(self, t) return self:combatStatScale("con", 3, 7, 1.25) + (self:getTalentLevel(t) * 10) end,
	action = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		if not ammo or ammo:getNumber() < 2 then
			game.logPlayer(self, "You need at least two alchemist gems in your quiver.")
			return
		end

		self:removeObject(self:getInven("QUIVER"), 1)
		ammo = self:removeObject(self:getInven("QUIVER"), 1)
		if not ammo then return end

        local dur = t.getDuration(self, t)
		local regen = t.getRegen(self, t)
        self:setEffect(self.EFF_REGENERATION, dur, {power=regen})
        self:setEffect(self.EFF_MANASURGE, dur, {power=self.mana_regen * 10})
		return true

		
	end,
	info = function(self, t)
        local dur = t.getDuration(self, t)
		local regen = t.getRegen(self, t)
        return ([[Use two alchemist gems to surround yourself with rejuvenating aura, increasing health regeneration by %d and mana regeneration by 1000%% for %d turns.
		Health regeneration increases with Constitution.]]):
		tformat(regen, dur)
	end,
}

newTalent{
	name = "Cleansing Crystals", short_name = "WK_CLEANSING_CRYSTALS",
	type = {"spell/lapidary",4},
    image = "talents/cleansing_crystals.png",
	require = techs_con_req4,
	points = 5,
	mana = 25,
	equilibrium = 5,
	requires_target = true,
	cooldown = function(self, t) return self:combatTalentLimit(t, 10, 30, 16) end,
	tactical = { CURE = function(self, t, aitarget)
		local nb = 0
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" then nb = nb + 1 end
		end
		return nb
	end,
	DISABLE = function(self, t, aitarget)
		local nb = 0
		for eff_id, p in pairs(aitarget.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "beneficial" then nb = nb + 1 end
		end
		for tid, act in pairs(aitarget.sustain_talents) do
			if act then
				local talent = aitarget:getTalentFromId(tid)
				if talent.is_spell then nb = nb + 1 end
			end
		end
		return nb^0.5
	end},
	requires_target = function(self, t) return self:getTalentLevel(t) >= 3 and (self.player or t.tactical.cure(self, t) <= 0) end,
	range = 10,
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	action = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		if not ammo or ammo:getNumber() < 5 then
			game.logPlayer(self, "You need to ready at least five alchemist gems in your quiver.")
			return
		end

		local target = self

		if self:getTalentLevel(t) >= 3 then
			local tg = {type="hit", range=self:getTalentRange(t)}
			local tx, ty = self:getTarget(tg)
			if tx and ty and game.level.map(tx, ty, Map.ACTOR) then
				local _ _, tx, ty = self:canProject(tg, tx, ty)
				if not tx then return nil end
				target = game.level.map(tx, ty, Map.ACTOR)
				if not target then return nil end

				target = game.level.map(tx, ty, Map.ACTOR)
			else return nil
			end
		end

		local effs = {}

		-- Go through all spell effects
		if self:reactionToward(target) < 0 then
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "beneficial" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					local talent = target:getTalentFromId(tid)
					if talent.is_spell then effs[#effs+1] = {"talent", tid} end
				end
			end
		else
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			target:dispel(eff[2], self)
		end

		for i = 1, 5 do self:removeObject(self:getInven("QUIVER"), 1) end
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[Consume five alchemist gems to remove up to %d effects (good effects from foes, and bad effects from friends) from the target.
		At level 3, it can be targeted.]]):
		tformat(count)
	end,
}