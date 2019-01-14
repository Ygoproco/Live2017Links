--機械天使の絶対儀式
function c11398951.initial_effect(c)
	aux.AddRitualProcEqual(c,c11398951.ritualfil,nil,nil,c11398951.extrafil,c11398951.extraop)
end
function c11398951.ritualfil(c)
	return c:IsSetCard(0x2093) and c:IsRitualMonster()
end
function c11398951.mfilter(c)
	return c:GetLevel()>0 and c:IsRace(RACE_WARRIOR+RACE_FAIRY) and c:IsAbleToDeck()
end
function c11398951.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(c11398951.mfilter,tp,LOCATION_GRAVE,0,nil)
end
function c11398951.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsRace,nil,RACE_WARRIOR+RACE_FAIRY)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
