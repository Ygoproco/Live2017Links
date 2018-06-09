-- ビンゴマシーンＧＯ！ＧＯ！
--Bingo Machine GO! GO!
function c93437091.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93437091,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,93437091+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c93437091.target)
	e1:SetOperation(c93437091.operation)
	c:RegisterEffect(e1)
end
c93437091.listed_names={89631139,23995346}
function c93437091.filter(c)
	return ( (c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER)) ) or ( (aux.IsCodeListed(c,89631139) or aux.IsCodeListed(c,23995346)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(93437091) ) 
		and c:IsAbleToHand()
end
function c93437091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c93437091.filter,tp,LOCATION_DECK,0,nil)
		return g:GetCount()>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c93437091.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c93437091.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tc=sg:Select(1-tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

