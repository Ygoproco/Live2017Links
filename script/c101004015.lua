--オルターガイスト・ピクシール
--Altergeist Pixiel
function c101004015.initial_effect(c)
	--mill
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004015,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101004015)
	e1:SetCost(c101004015.cost)
	e1:SetTarget(c101004015.target)
	e1:SetOperation(c101004015.operation)
	c:RegisterEffect(e1)
end
function c101004015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101004015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c101004015.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x103)
end
function c101004015.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c101004015.filter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c101004015.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end
