long_name = "Earth Mage"
short_name = "earthmage"
for_module = "tome"
version = {1,7,2}
addon_version = {1,0,1}
weight = 2000
author = {"werekracken"}
tags = {"class", "earth", "mage", "wilder", "stone", "archmage", "stone warden"}
homepage = "https://te4.org/user/102798/addons"
description = [[
Adds the Earth Mage as a mage class that combines earth magics with wild gifts. Earth Mages have learned the basics of how to create and use alchemist gems, but developed their own specialized uses as well.

Mana and equilibruim are their resources and their most important stat is Magic followed by Willpower and Constitution. They use some existing talent trees from Archmage and Stone Warden, and have a new class tree: Spell / Lapidary. Their playstyle is multitarget, area of effect, and damage over time, with a lot of options for survivability.

https://github.com/Werekracken/tome-earthmage

-- generic
Spell / Stone alchemy
Spell / Conveyance
Wild-gift / Harmony
-- locked
Cunning / Survival

-- class
Spell / Earth (x1.0 instead of the normal x1.3 to encourage play other than spamming Pulverizing Auger constantly)
Spell / Explosive admixtures
Spell / Eldritch stone
Wild-gift / Earthen vines
Spell / Lapidary
-- locked
Spell / Stone
Spell / Deeprock

Spell / Lapidary:

Living Stone
Like stone, you are not easily moved nor damaged. While active, increases your resistances to being teleported and knocked back by %d%% and increases your physical resistance by %d%%.
Physical resistance increases with Constitution.
Also, resting will decrease your equilibrium by %0.2f per turn.

Liquefaction
Crush an alchemist gem and use the released power to vibrate the ground so quickly that it partially liquefies. Targets an area of radius %d dealing %d physical damage per turn with a 25%% chance to stun.
The vibrations last for for %d turns.
You have just enough control over the vibrations to not affect yourself.
The damage done will increase with your Spellpower.

Rejuvenation
Use two alchemist gems to surround yourself with rejuvenating aura, increasing health regeneration by %d and mana regeneration by 1000%% for %d turns.
Health regeneration increases with Constitution.

Cleansing Crystals
Consume five alchemist gems to remove up to %d effects (good effects from foes, and bad effects from friends) from the target.
At level 3, it can be targeted.


---Changelog
v1.0.0
Initial release

v1.0.1
Fixed Cleansing Crystals to clean more than just magic effects as intended.
]]
overload = true
superload = false
hooks = true
data = true
