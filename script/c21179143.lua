--レプティレス・スポーン
function c21179143.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21179143.cost)
	e1:SetTarget(c21179143.target)
	e1:SetOperation(c21179143.activate)
	c:RegisterEffect(e1)
end
function c21179143.cfilter(c)
	return c:IsSetCard(0x3c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c21179143.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21179143.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c21179143.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21179143.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		or (Duel.IsPlayerAffectedByEffect(tp,69832741) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,21179144,0x3c,0x4011,0,0,1,RACE_REPTILE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c21179143.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,21179144,0x3c,0x4011,0,0,1,RACE_REPTILE,ATTRIBUTE_EARTH) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,21179144)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
