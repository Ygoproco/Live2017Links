--くず鉄のかかし 
function c98427577.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c98427577.condition)
	e1:SetCost(c98427577.cost)
	e1:SetTarget(c98427577.target)
	e1:SetOperation(c98427577.activate)
	c:RegisterEffect(e1)
end
function c98427577.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c98427577.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		aux.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c98427577.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c98427577.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	if c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	else
		c:CancelToGrave(false)
	end
end
