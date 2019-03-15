-- Skyforce Monk
local s,id=GetID()
function s.initial_effect(c)
	--Link summon method
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,1,1)
end
function s.matfilter(c)
	return c:IsLinkSetCard(0x22d) and not c:IsType(TYPE_LINK)
end