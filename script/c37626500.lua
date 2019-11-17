--精霊の祝福
local s,id=GetID()
function s.initial_effect(c)
	aux.AddRitualProcEqual(c,s.ritual_filter)
end
function s.ritual_filter(c)
	return c:IsRitualMonster() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
