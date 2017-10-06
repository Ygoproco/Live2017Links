--レベルの絆
function c100000254.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c100000254.cost)
	e1:SetTarget(c100000254.target)
	e1:SetOperation(c100000254.activate)
	c:RegisterEffect(e1)
end
function c100000254.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c100000254.filter(c,e,tp,code)
	return c:IsSetCard(0x41) and c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100000254.cfilter(c,e,tp)
	return c:IsSetCard(0x41) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
		and Duel.IsExistingMatchingCard(c100000254.cfilter2,tp,LOCATION_GRAVE,0,1,c,c:GetCode())
		and Duel.IsExistingMatchingCard(c100000254.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c100000254.cfilter2(c,code)
	return c:IsSetCard(0x41) and c:IsType(TYPE_MONSTER) and c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c100000254.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsPlayerCanDraw(1-tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c100000254.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c100000254.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg2=Duel.SelectMatchingCard(tp,c100000254.cfilter2,tp,LOCATION_GRAVE,0,1,1,rg:GetFirst(),rg:GetFirst():GetCode())
	rg:Merge(rg2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetTargetParam(rg:GetFirst():GetCode())
end
function c100000254.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Draw(1-tp,2,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c100000254.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
