--高等儀式術
local s,id=GetID()
function s.initial_effect(c)
	local e1=aux.CreateRitualProc(c,RITPROC_EQUAL,nil,nil,nil,s.extrafil,nil,s.forcedgroup)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	c:RegisterEffect(e1)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroup(tp,LOCATION_DECK,0)
end
function s.forcedgroup(c,e,tp)
	return c:IsLocation(LOCAITON_DECK) and c:IsType(TYPE_NORMAL)
end
