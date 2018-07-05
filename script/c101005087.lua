--Danger! Zone
--Scripted by AlphaKretin
function c101005087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101005087+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101005087.target)
	e1:SetOperation(c101005087.activate)
	c:RegisterEffect(e1)
end
function c101005087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c101005087.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x223)
end
function c101005087.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		if g:IsExists(Card.IsSetCard,1,nil,0x223) then
			local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c101005087.rescon,1,tp,HINTMSG_DISCARD)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		else
			Duel.ConfirmCards(1-p,g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
