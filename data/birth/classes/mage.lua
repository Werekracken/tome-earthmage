local Particles = require "engine.Particles"

newBirthDescriptor{
   type = "subclass",
   name = "Earth Mage",
   desc = {
      "Earth Mages are spell casters who combine earth magics with wild gifts.",
      "Their most important stat is Magic followed by Willpower and Constitution.",
      "#GOLD#Stat modifiers:",
      "#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +2 Constitution",
      "#LIGHT_BLUE# * +2 Magic, +2 Willpower, +0 Cunning",
      "#GOLD#Life per level:#LIGHT_BLUE# -3",
   },
   power_source = {arcane=true, nature=true},
   random_rarity = 3,
   stats = { mag=2, wil=2, con=2 },
   birth_example_particles = {
		function(actor)
			if core.shader.active(4) then
            actor:addParticles(Particles.new("shader_ring_rotating", 1, {toback=true, rotation=0, radius=1}, {type="stone", hide_center=1, color1={0.5, 0.5, 0.5, 1}, color2={0.4, 0.3, 0.2, 1}, time_factor = 700000}))
			else 
            actor:addParticles(Particles.new("crystalline_focus", 1))
         end
		end,
	},
   talents_types = {
      -- generic
		["spell/stone-alchemy"]={true, 0.3},
      ["spell/conveyance"]={true,0.3},
      ["wild-gift/harmony"]={true, 0.3},
      ["cunning/survival"]={false, 0.1},

      -- class
		["spell/earth"]={true, 0},
		["spell/eldritch-stone"]={true, 0.3},
		["spell/explosives"]={true, 0.3},
      ["wild-gift/earthen-vines"]={true,0.3},
      ["spell/lapidary"]={true,0.3},
      ["spell/stone"]={false, 0.3},
      ["spell/deeprock"]={false,0.3},

   },
   talents = {
		[ActorTalents.T_CREATE_ALCHEMIST_GEMS] = 1,
		[ActorTalents.T_EXTRACT_GEMS] = 1,
		[ActorTalents.T_THROW_BOMB] = 1,
		[ActorTalents.T_WK_LIVING_STONE] = 1,
		[ActorTalents.T_STONE_VINES] = 1,
   },
   copy = {
      max_life = 90,
      resolvers.equip{ id=true,
         {type="weapon", subtype="staff", name="elm staff", autoreq=true, ignore_material_restriction=true, ego_chance=-1000},
         {type="armor", subtype="cloth", name="linen robe", autoreq=true, ignore_material_restriction=true, ego_chance=-1000},
      },
      mana_regen = 0.5,
		resolvers.inscription("RUNE:_MANASURGE", {cooldown=15, dur=10, mana=820}, 3),
      resolvers.generic(function(self) self:birth_create_alchemist_gems() end),
		birth_create_alchemist_gems = function(self)
			-- Make and wield some alchemist gems
			local t = self:getTalentFromId(self.T_CREATE_ALCHEMIST_GEMS)
			local gem = t.make_gem(self, t, "GEM_AGATE")
			self:wearObject(gem, true, true)
			self:sortInven()
		end,
   },
   copy_add = {
      life_rating = -3,
   },
}

getBirthDescriptor("class", "Mage").descriptor_choices.subclass["Earth Mage"] = "allow"