--エマージェンシー・サイバー
--Emergency Cyber
--Scripted by Eerie Code
function c100227016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100227016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100227016.target)
	e1:SetOperation(c100227016.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(c100227016.negcon)
	e2:SetOperation(c100227016.negop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c100227016.thcon)
	e3:SetCost(c100227016.thcost)
	e3:SetTarget(c100227016.thtg)
	e3:SetOperation(c100227016.thop)
	c:RegisterEffect(e3)
end
function c100227016.filter(c)
	return (c:IsSetCard(0x1093) or (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and not c:IsSummonableCard())) 
		and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100227016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100227016.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100227016.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c100227016.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then 
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
function c100227016.negcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return de and dp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function c100227016.negop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(100227016,RESET_EVENT+0x1fe0000)
end
function c100227016.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100227016)~=0
end
function c100227016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c100227016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100227016.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
