--鉄の騎士
--Iron Knight
--Scripted by Naim
function c100227007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c100227007.atkcond)
	e1:SetValue(-1000)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100227007,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100227007)
	e2:SetCondition(c100227007.thcon)
	e2:SetTarget(c100227007.thtg)
	e2:SetOperation(c100227007.thop)
	c:RegisterEffect(e2)
end
c100227007.listed_names={100227010}
function c100227007.atkfilter(c)
	return c:IsFaceup() and c:IsCode(100227006)
end
function c100227007.atkcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100227007.atkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100227007.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100227007.fieldcond(c)
	return c:IsFaceup() and c:IsCode(100227010)
end
function c100227007.thfilter(c,fc)
	return (c:IsCode(100227006) or (fc and c:IsRace(RACE_WARRIOR))) and c:IsAbleToHand()
end
function c100227007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local fc=Duel.IsExistingMatchingCard(c100227007.fieldcond,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
		return Duel.IsExistingMatchingCard(c100227007.thfilter,tp,LOCATION_DECK,0,1,nil,fc)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100227007.thop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.IsExistingMatchingCard(c100227007.fieldcond,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100227007.thfilter,tp,LOCATION_DECK,0,1,1,nil,fc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end