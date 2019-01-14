--高等儀式術
function c46052429.initial_effect(c)
	aux.AddRitualProcEqual(c,aux.FilterBoolFunction(Card.IsRitualMonster),nil,nil,c46052429.extrafil,c46052429.extraop,c46052429.matfil)
end
function c46052429.matfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToGrave()
end
function c46052429.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c46052429.matfilter,tp,LOCATION_DECK,0,nil)
end
function c46052429.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function c46052429.matfil(c)
	return c:IsLocation(LOCATION_DECK)
end