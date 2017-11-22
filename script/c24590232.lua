--王魂調和
function c24590232.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c24590232.condition)
	e1:SetOperation(c24590232.activate)
	c:RegisterEffect(e1)
end
function c24590232.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c24590232.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:GetLevel()<9 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c24590232.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c24590232.filter2(c,e,tp,sc)
	local rg=Duel.GetMatchingGroup(c24590232.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	return c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true) 
		and aux.SelectUnselectGroup(rg,e,tp,nil,nil,c24590232.rescon(c,sc),0)
end
function c24590232.rescon(tuner,scard)
	return	function(sg,e,tp,mg)
				sg:AddCard(tuner)
				local res=Duel.GetLocationCountFromEx(tp,tp,sg,scard)>0 and sg:CheckWithSumEqual(Card.GetLevel,scard:GetLevel(),sg:GetCount(),sg:GetCount())
				sg:RemoveCard(tuner)
				return res
			end
end
function c24590232.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c24590232.activate(e,tp,eg,ep,ev,re,r,rp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_SYNCHRO)
	if Duel.NegateAttack() and Duel.GetLocationCountFromEx(tp)>0 and pg:GetCount()<=0
		and Duel.IsExistingMatchingCard(c24590232.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(24590232,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c24590232.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local sc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c24590232.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,sc)
		local tuner=g2:GetFirst()
		local rg=Duel.GetMatchingGroup(c24590232.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tuner)
		local sg=aux.SelectUnselectGroup(rg,e,tp,nil,nil,c24590232.rescon(tuner,sc),1,tp,HINTMSG_REMOVE,c24590232.rescon(tuner,sc))
		sg:AddCard(tuner)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
