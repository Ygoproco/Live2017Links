--星遺物の醒存
--World Legacy Survivor
--Scripted by AlphaKretin
function c31706048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,31706048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c31706048.target)
	e1:SetOperation(c31706048.activate)
	c:RegisterEffect(e1)
end
function c31706048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result and Duel.IsPlayerCanDiscardDeck(tp,5)
	end
end
function c31706048.filter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x104)) or c:IsSetCard(0xfe)
end
function c31706048.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c31706048.filter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c31706048.filter,1,1,nil)
			if sg:GetFirst():IsAbleToHand() then 
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
				Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			else Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
			end
		else
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REVEAL)
			Duel.ShuffleDeck(tp)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c31706048.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c31706048.splimit(e,c)
	return not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_EXTRA)
end

