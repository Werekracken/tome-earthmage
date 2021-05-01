damDesc = Talents.main_env.damDesc

spells_req1 = Talents.main_env.spells_req1
spells_req2 = Talents.main_env.spells_req2
spells_req3 = Talents.main_env.spells_req3
spells_req4 = Talents.main_env.spells_req4
techs_con_req1 = Talents.main_env.techs_con_req1
techs_con_req2 = Talents.main_env.techs_con_req2
techs_con_req3 = Talents.main_env.techs_con_req3
techs_con_req4 = Talents.main_env.techs_con_req4

if not Talents.talents_types_def["spell/lapidary"] then
    newTalentType{ allow_random=true, no_silence=true, is_spell=true, type="spell/lapidary", name = _t"lapidary", description = _t"Magical applications of stone and gems." }
    load("/data-earthmage/talents/spells/lapidary.lua")
end
