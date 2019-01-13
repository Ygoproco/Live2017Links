--灼熱の火霊使いヒータ
--Hiita the Scorching Fire Charmer
--Scripted by ahtelel
function c48815792.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c48815792.lcheck)
	c:EnableReviveLimit()
	--add setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(0xc0)
	c:RegisterEffect(e1)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(48815792,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,48815792)
	e2:SetTarget(c48815792.sptg)
	e2:SetOperation(c48815792.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,48815793)
	e3:SetCondition(c48815792.thcon)
	e3:SetTarget(c48815792.thtg)
	e3:SetOperation(c48815792.thop)
	c:RegisterEffect(e3)
end
function c48815792.lcheck(g,lc)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE)
end
function c48815792.spfilter(c,e,tp,zone)
	if zone==0 then zone=0xff end
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c48815792.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=c:GetFreeLinkedZone()&0x1f
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c48815792.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c48815792.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c48815792.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c48815792.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetFreeLinkedZone()&0x1f
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c48815792.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and rp~=tp and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c48815792.thfilter(c)
	return c:IsDefenseBelow(1500) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToHand()
end
function c48815792.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48815792.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c48815792.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c48815792.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

