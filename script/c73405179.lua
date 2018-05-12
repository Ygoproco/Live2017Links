--鉄の騎士
--Iron Knight
--Scripted by Naim
function c73405179.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c73405179.atkcond)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73405179,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,73405179)
	e2:SetCondition(c73405179.thcon)
	e2:SetTarget(c73405179.thtg)
	e2:SetOperation(c73405179.thop)
	c:RegisterEffect(e2)
end
c73405179.listed_names={72283691}
function c73405179.atkfilter(c)
	return c:IsFaceup() and c:IsCode(41916534)
end
function c73405179.atkcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c73405179.atkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c73405179.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c73405179.fieldcond(c)
	return c:IsFaceup() and c:IsCode(72283691)
end
function c73405179.thfilter(c,fc)
	return (c:IsCode(41916534) or (fc and c:IsRace(RACE_WARRIOR))) and c:IsAbleToHand()
end
function c73405179.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local fc=Duel.IsExistingMatchingCard(c73405179.fieldcond,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
		return Duel.IsExistingMatchingCard(c73405179.thfilter,tp,LOCATION_DECK,0,1,nil,fc)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c73405179.thop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.IsExistingMatchingCard(c73405179.fieldcond,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c73405179.thfilter,tp,LOCATION_DECK,0,1,1,nil,fc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
