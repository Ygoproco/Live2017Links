--トリッキーズ・マジック4
function c75622824.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c75622824.cost)
	e1:SetTarget(c75622824.target)
	e1:SetOperation(c75622824.activate)
	c:RegisterEffect(e1)
end
function c75622824.cfilter(c,ft,ct)
	return c:IsFaceup() and c:IsCode(14778250) and c:IsAbleToGraveAsCost() and (ft>=ct or c:GetSequence()<5)
end
function c75622824.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>=ct-1 and Duel.IsExistingMatchingCard(c75622824.cfilter,tp,LOCATION_MZONE,0,1,nil,ft,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75622824.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft,ct)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75622824.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return false end
		e:SetLabel(0)
		return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,75622825,0,0x4011,2000,1200,5,RACE_SPELLCASTER,ATTRIBUTE_WIND)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,0)
end
function c75622824.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	if ft<ct then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,75622825,0,0x4011,2000,1200,5,RACE_SPELLCASTER,ATTRIBUTE_WIND) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,75622825)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
