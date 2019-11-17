--精霊の祝福
local s,id=GetID()
function s.initial_effect(c)
	aux.AddRitualProcEqual(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
end
