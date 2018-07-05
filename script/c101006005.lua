--転生炎獣 Ｊジャガー
--Salamangreat Jack Jaguar
--scripted by Larry126
function c101006005.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006005,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101006005)
	e2:SetCondition(c101006005.spcon)
	e2:SetTarget(c101006005.sptg)
	e2:SetOperation(c101006005.spop)
	c:RegisterEffect(e2)
end
function c101006005.cfilter(c,e,tp,sc)
	return c:IsSetCard(0x220) and c:IsType(TYPE_LINK)
end
function c101006005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101006005.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101006005.tdfilter(c)
	return c:IsSetCard(0x220) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and not c:IsCode(101006005)
end
function c101006005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101006005.tdfilter(chkc) end
	local c=e:GetHandler()
	local zone=0
	local g=Duel.GetMatchingGroup(c101006005.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		zone=zone | tc:GetLinkedZone()
	end
	if chk==0 then return Duel.IsExistingTarget(c101006005.tdfilter,tp,LOCATION_GRAVE,0,1,c)
		and zone & 0x1f~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone & 0x1f) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101006005.tdfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,LOCATION_GRAVE)
end
function c101006005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone = 0
	local g = Duel.GetMatchingGroup(c101006005.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		zone = zone | tc:GetLinkedZone()
	end
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and zone & 0x1f~=0 and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone & 0x1f)
	end
end