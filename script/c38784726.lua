--転生炎獣の降臨
--Rise of the Salamangreat
--Scripted by AlphaKretin
function c38784726.initial_effect(c)
	aux.AddRitualProcGreater(c,c38784726.ritualfil,nil,c38784726.extrafil,c38784726.extraop)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(38784726,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c38784726.spcon)
	e2:SetTarget(c38784726.sptg)
	e2:SetOperation(c38784726.spop)
	c:RegisterEffect(e2)
end
c38784726.fit_monster={16313112}
function c38784726.ritualfil(c)
	return c:IsSetCard(0x119) and c:IsRitualMonster()
end
function c38784726.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x119) and c:IsAbleToDeck()
end
function c38784726.ckfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_LINK)
end
function c38784726.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(c38784726.ckfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) then
		return Duel.GetMatchingGroup(c38784726.mfilter,tp,LOCATION_GRAVE,0,nil)
	end
	return Group.CreateGroup()
end
function c38784726.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(c38784726.mfilter,nil)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function c38784726.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c38784726.spfilter(c,e,tp)
	return c:IsCode(16313112) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c38784726.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c38784726.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c38784726.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c38784726.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end

