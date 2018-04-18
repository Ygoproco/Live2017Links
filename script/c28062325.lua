--竹頭木屑
function c28062325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c28062325.cost)
	e1:SetTarget(c28062325.target)
	e1:SetOperation(c28062325.activate)
	c:RegisterEffect(e1)
end
function c28062325.cfilter(c,ft,tp)
	return c:IsRace(RACE_PLANT) and (ft>1 or (c:GetSequence()<5 and c:IsControler(1-tp))) and (c:IsFaceup() or c:IsControler(tp))
end
function c28062325.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c28062325.cfilter,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,c28062325.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c28062325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=1 then return false end
		e:SetLabel(0)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,28062326,0,0x4011,800,500,1,RACE_PLANT,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c28062325.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<2 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,28062326,0,0x4011,800,500,1,RACE_PLANT,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,28062326)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
