--紅蓮の炎壁
function c47658964.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c47658964.cost)
	e1:SetTarget(c47658964.target)
	e1:SetOperation(c47658964.activate)
	c:RegisterEffect(e1)
end
function c47658964.cfilter(c)
	return c:IsSetCard(0x39) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c47658964.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47658964.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g
	if Duel.IsPlayerAffectedByEffect(tp,69832741) then
		g=Duel.SelectMatchingCard(tp,c47658964.cfilter,tp,LOCATION_MZONE,0,1,5,nil)
	else
		g=Duel.SelectMatchingCard(tp,c47658964.cfilter,tp,LOCATION_GRAVE,0,1,Duel.GetLocationCount(tp,LOCATION_MZONE),nil)
	end
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c47658964.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsPlayerAffectedByEffect(tp,69832741)) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,47658965,0x39,0x4011,0,0,1,RACE_PYRO,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,e:GetLabel(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),tp,0)
end
function c47658964.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<e:GetLabel() or not Duel.IsPlayerCanSpecialSummonMonster(tp,47658965,0x39,0x4011,0,0,1,RACE_PYRO,ATTRIBUTE_FIRE) then return end
	for i=1,e:GetLabel() do
		local token=Duel.CreateToken(tp,47658965)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
