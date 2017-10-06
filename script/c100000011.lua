--時械天使
function c100000011.initial_effect(c)
	--to HAND
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c100000011.thcon)
	e1:SetTarget(c100000011.thtg)
	e1:SetOperation(c100000011.thop)
	c:RegisterEffect(e1)
end
function c100000011.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattlePosition()==POS_FACEUP_ATTACK
end
function c100000011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c100000011.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
