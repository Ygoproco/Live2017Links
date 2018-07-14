--閃刀術式－ベクタードブラスト 
--Sky Striker Maneuver - Vectored Blast!
--scripted by andré
function c21623008.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21623008.condition)
	e1:SetTarget(c21623008.target)
	e1:SetOperation(c21623008.operation)
	c:RegisterEffect(e1)
end
function c21623008.cfilter(c)
	return c:GetSequence()<5
end
function c21623008.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c21623008.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21623008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsPlayerCanDiscardDeck(1-tp,2) end
end
function c21623008.filter(c)
	return c:GetSequence()>=5
end
function c21623008.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,2)
	local g2=Duel.GetDecktopGroup(1-tp,2)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,3,nil,TYPE_SPELL) 
		and Duel.IsExistingMatchingCard(c21623008.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(21623008,0)) then
		local g=Duel.GetMatchingGroup(c21623008.filter,tp,0,LOCATION_MZONE,nil)
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end

