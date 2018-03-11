--逆巻くエリア
function c56524813.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c56524813.spcost)
	e1:SetTarget(c56524813.sptg)
	e1:SetOperation(c56524813.spop)
	c:RegisterEffect(e1)
end
function c56524813.cfilter(c,ft,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) and (c:IsFaceup() or c:IsControler(tp))
end
function c56524813.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,c56524813.cfilter,1,false,nil,e:GetHandler(),ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,c56524813.cfilter,1,1,false,nil,e:GetHandler(),ft,tp)
	Duel.Release(g,REASON_COST)
end
function c56524813.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c56524813.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c56524813.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c56524813.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c56524813.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c56524813.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e1)
	end
end
function c56524813.desop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsCode,1,nil,56524813) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
