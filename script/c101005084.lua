--Danger! Chupacabra!
--Scripted by AlphaKretin
function c101005084.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101005084,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101005084.spcost)
	e1:SetTarget(c101005084.sptg)
	e1:SetOperation(c101005084.spop)
	c:RegisterEffect(e1)
	--special summon from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101005084,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101005084)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c101005084.spcon2)
	e2:SetTarget(c101005084.sptg2)
	e2:SetOperation(c101005084.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c101005084.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(101005084)==0 end
	c:RegisterFlagEffect(101005084,RESET_CHAIN,0,1)
end
function c101005084.spfilter(c,e,tp)
	return c:IsCode(101005084) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005084.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005084.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c101005084.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g<1 then return end
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
	local tc=g:Select(1-tp,1,1,nil)
	Duel.BreakEffect()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
	if not tc:GetFirst():IsCode(101005084) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c101005084.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #sc>0 and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c101005084.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_HAND and (r&REASON_DISCARD)~=0
end
function c101005084.spfilter2(c,e,tp)
	return c:IsSetCard(0x223) and not c:IsCode(101005084) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005084.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101005084.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101005084.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101005084.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101005084.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
