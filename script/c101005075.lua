--星遺物の交心
--World Legacy Communion
function c101005075.initial_effect(c)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101005075)
	e1:SetCondition(c101005075.cecon)
	e1:SetTarget(c101005075.cetg)
	e1:SetOperation(c101005075.ceop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101005075)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101005075.sptg)
	e2:SetOperation(c101005075.spop)
	c:RegisterEffect(e2)
end
function c101005075.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c101005075.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c101005075.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x104)
end
function c101005075.cecon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c101005075.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101005075.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c101005075.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005075.thfilter,rp,0,LOCATION_MZONE,1,nil) end
end
function c101005075.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c101005075.repop)
end
function c101005075.spfilter1(c,e,tp)
	local zone = c:GetLinkedZone(tp)&0x1f
	return c:IsFaceup() and c:IsType(TYPE_LINK) and Duel.IsExistingMatchingCard(c101005075.spfilter2,tp,0x13,0,1,c,e,tp,zone)
end
function c101005075.spfilter2(c,e,tp,zone)
	return c:IsSetCard(0x104) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,tp,zone)
end
function c101005075.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101005075.spfilter1(chkc,e,tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk == 0 then return Duel.IsExistingTarget(c101005075.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SelectTarget(tp,c101005075.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c101005075.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local zone = tc:GetLinkedZone(tp)&0x1f
		local sg = Duel.SelectMatchingCard(tp,c101005075.spfilter2,tp,0x13,0,1,1,c,e,tp,zone)
		if sg then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE,zone)
		end
	end
end
