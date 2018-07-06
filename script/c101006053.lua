--転生炎獣の意志
--Salamangreat Heart
--Scripted by Eerie Code
function c101006053.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon (single)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006053,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101006053)
	e2:SetTarget(c101006053.sptg1)
	e2:SetOperation(c101006053.spop1)
	c:RegisterEffect(e2)
	--spsummon (link)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101006053,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c101006053.spcost)
	e3:SetTarget(c101006053.sptg2)
	e3:SetOperation(c101006053.spop2)
	c:RegisterEffect(e3)
end
function c101006053.spfilter(c,e,tp,pos)
	return c:IsSetCard(0x220) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos)
end
function c101006053.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101006053.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c101006053.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101006053.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,POS_FACEUP)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101006053.filter(c)
	return c:IsSetCard(0x220) and c:IsType(TYPE_LINK) and c:GetFlagEffect(101006040)~=0--c:GetMaterial():IsExists(Card.IsLinkCode,1,nil,c:GetCode())
end
function c101006053.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101006053.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101006053.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101006053.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,POS_FACEUP_DEFENSE)
		and Duel.IsExistingTarget(c101006053.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101006053.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c101006053.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),tc:GetLink())
	if ft<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101006053.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,ft,nil,e,tp,POS_FACEUP_DEFENSE)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
