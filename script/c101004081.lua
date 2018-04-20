--Super Team Buddy Force Unite!
--Scripted by Eerie Code
function c101004081.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101004081.target)
	e1:SetOperation(c101004081.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101004081.setcon)
	e2:SetTarget(c101004081.settg)
	e2:SetOperation(c101004081.setop)
	c:RegisterEffect(e2)
end
function c101004081.filter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c101004081.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c101004081.spfilter(c,e,tp,tc)
	return c:GetOriginalRace()==tc:GetOriginalRace() and c:GetOriginalCode()~=tc:GetOriginalCode() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101004081.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101004081.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101004081.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101004081.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
end
function c101004081.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsFaceup()
		and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101004081.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101004081.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) 
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_SZONE)
end
function c101004081.setfilter(c)
	return c:IsCode(101004081) and c:IsSSetable()
end
function c101004081.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101004081.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101004081.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101004081.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end
