--Vendread Reunion
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=aux.CreateRitualProc(c,RITPROC_EQUAL,s.cfilter,nil,nil,s.extrafil,nil,s.filter,nil,s.ritcheck,s.customoperation)
	e1:SetTarget(s.registerloccount(e1:GetTarget()))
	e1:SetOperation(s.registerloccount(e1:GetOperation()))
	c:RegisterEffect(e1)
end
function s.registerloccount(func)
	return function(e,tp,...)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if Duel.IsPlayerCanSpecialSummonCount(tp,2) then ft=0 end
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		e:SetLabel(ft)
		local res=func(e,tp,...)
		e:SetLabel()
		return res
	end
end
function s.cfilter(c,e,tp,m,ft)
	return e:GetLabel()>0 and c:IsSetCard(0x106) and c:IsPublic()
end
function s.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x106) and Duel.IsPlayerCanRelease(tp,c)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp)
	Duel.GetMatchingGroup(s.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
end
function s.ritcheck(e,tp,g,sc)
	local count=#g
	return g:GetClassCount(Card.GetCode)==count and count <=e:GetLabel()
end
function s.customoperation(mg,e,tp,eg,ep,ev,re,r,rp,tc)
	Duel.ConfirmCards(1-tp,tc)
	if #mg==0 then return end
	if Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)==#mg then
		local og=Duel.GetOperatedGroup()
		Duel.ConfirmCards(1-tp,og)
		tc:SetMaterial(og)
		Duel.Release(og,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
