--レグレクス・パラディオン
--Regulex Palladion
function c101005043.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,2,c101005043.lcheck)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101005043.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c101005043.atklimit)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101005043,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,101005043)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101005043.thcon)
	e3:SetTarget(c101005043.thtg)
	e3:SetOperation(c101005043.thop)
	c:RegisterEffect(e3)	
end
function c101005043.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x217)
end
function c101005043.matfilter(c)
	return c:IsLinkSetCard(0x217) and not c:IsLinkCode(3679218)
end
function c101005043.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end
function c101005043.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil) 
	return g:GetSum(Card.GetBaseAttack)
end
function c101005043.atklimit(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c101005043.thcfilter(c,tp,lg)
	return c:IsControler(tp) and c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c101005043.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c101005043.thcfilter,1,nil,tp,lg)
end
function c101005043.thfilter(c,tp)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSetCard(0x217) and c:IsAbleToHand()
end
function c101005043.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005043.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101005043.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c101005043.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
