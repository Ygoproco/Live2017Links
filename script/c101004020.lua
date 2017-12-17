--エレメントセイバー・マカニ
--Elementsaber Makani
--Scripted by Eerie Code
function c101004020.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004020,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101004020.thcost)
	e1:SetTarget(c101004020.thtg)
	e1:SetOperation(c101004020.thop)
	c:RegisterEffect(e1)
	--att change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004020,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101004020.atttg)
	e2:SetOperation(c101004020.attop)
	c:RegisterEffect(e2)
end
function c101004020.costfilter(c)
	return c:IsSetCard(0x400d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101004020.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=Duel.IsPlayerAffectedByEffect(tp,101004060)
	local loc=LOCATION_HAND
	if fc then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c101004020.costfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c101004020.costfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,101004060)
		local field=Duel.GetFirstMatchingCard(Card.IsHasEffect,tp,LOCATION_ONFIELD,0,nil,101004060)
		if field then field:RegisterFlagEffect(101004060,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0) end
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c101004020.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x400d) or c:IsSetCard(0x212)) and c:IsAbleToHand()
end
function c101004020.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101004020.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101004020.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101004020.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c101004020.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
	e:SetLabel(att)
end
function c101004020.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
