--強制退化
function c37421075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c37421075.cost)
	e1:SetTarget(c37421075.target)
	e1:SetOperation(c37421075.activate)
	c:RegisterEffect(e1)
end
function c37421075.cfilter(c,ft,tp)
	return c:IsLevelAbove(4) and c:IsRace(RACE_DINOSAUR) and (ft>1 or (c:GetSequence()<5 and c:IsControler(tp))) and (c:IsFaceup() or c:IsControler(tp))
end
function c37421075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.CheckReleaseGroupCost(tp,c37421075.cfilter,1,false,nil,nil,ft,tp) end
	local rg=Duel.SelectReleaseGroupCost(tp,c37421075.cfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(rg,REASON_COST)
end
function c37421075.spfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37421075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return false end
		e:SetLabel(0)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c37421075.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
	e:SetLabel(0)
end
function c37421075.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c37421075.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
