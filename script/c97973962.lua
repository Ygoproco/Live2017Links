--暴走召喚師アレイスター
--Aleister the Meltdown Invoker
function c97973962.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,nil,c97973962.spcheck)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(86120751)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97973962,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c97973962.thcon)
	e2:SetCost(c97973962.thcost)
	e2:SetTarget(c97973962.thtg)
	e2:SetOperation(c97973962.thop)
	c:RegisterEffect(e2)	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(97973962,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(c97973962.thcon2)
	e3:SetTarget(c97973962.thtg2)
	e3:SetOperation(c97973962.thop2)
	c:RegisterEffect(e3)
end
function c97973962.spcheck(g,lc,tp)
	return g:GetClassCount(Card.GetRace,lc,SUMMON_TYPE_LINK,tp)>1 and g:GetClassCount(Card.GetAttribute,lc,SUMMON_TYPE_LINK,tp)>1
end
function c97973962.thcfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c97973962.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c97973962.thcfilter,1,nil,tp)
end
function c97973962.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
end
function c97973962.thfilter(c)
	return (c:IsCode(74063034) or c:IsCode(458748)) and c:IsAbleToHand()
end
function c97973962.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97973962.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c97973962.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c97973962.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c97973962.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT))	and c:IsPreviousPosition(POS_FACEUP)
end
function c97973962.thfilter2(c)
	return c:IsCode(47457347) and c:IsAbleToHand()
end
function c97973962.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c97973962.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c97973962.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c97973962.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

