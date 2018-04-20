--マギアス・パラディオン
--Magias Palladion
function c72228247.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c72228247.matfilter,1,1)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c72228247.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c72228247.atklimit)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72228247,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,72228247)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c72228247.thcon)
	e3:SetTarget(c72228247.thtg)
	e3:SetOperation(c72228247.thop)
	c:RegisterEffect(e3)
end
function c72228247.matfilter(c)
	return c:IsLinkSetCard(0x116) and not c:IsLinkCode(72228247)
end
function c72228247.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end
function c72228247.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil) 
	return g:GetSum(Card.GetBaseAttack)
end
function c72228247.atklimit(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c72228247.thcfilter(c,tp,lg)
	return c:IsControler(tp) and c:IsType(TYPE_EFFECT) and lg:IsContains(c)
end
function c72228247.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c72228247.thcfilter,1,nil,tp,lg)
end
function c72228247.thfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x116) and c:IsAbleToHand()
end
function c72228247.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72228247.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72228247.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c72228247.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end

