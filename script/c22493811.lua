--アリの増殖
function c22493811.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22493811.cost)
	e1:SetTarget(c22493811.target)
	e1:SetOperation(c22493811.activate)
	c:RegisterEffect(e1)
end
function c22493811.cfilter(c,ft,tp)
	return c:IsRace(RACE_INSECT) and (ft>1 or (c:GetSequence()<5 and c:IsControler(tp)))
end
function c22493811.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22493811.cfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c22493811.cfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c22493811.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonMonster(tp,22493812,0,0x4011,500,1200,4,RACE_INSECT,ATTRIBUTE_EARTH)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return ft>0 and check
		else
			return ft>1 and check
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c22493811.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22493812,0,0x4011,500,1200,4,RACE_INSECT,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,22493812)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end
