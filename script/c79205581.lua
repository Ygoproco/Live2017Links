--強制終了
function c79205581.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79205581.cost)
	e1:SetTarget(c79205581.target)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79205581,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c79205581.bpcon)
	e2:SetCost(c79205581.bpcost)
	e2:SetOperation(c79205581.bpop)
	c:RegisterEffect(e2)
end
function c79205581.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c79205581.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		e:SetLabel(0)
		return true
	end
	if c79205581.bpcon(e,tp,eg,ep,ev,re,r,rp) and (e:GetLabel()~=1 or c79205581.bpcost(e,tp,eg,ep,ev,re,r,rp,0)) 
		and Duel.SelectYesNo(tp,94) then
		if e:GetLabel()==1 then c79205581.bpcost(e,tp,eg,ep,ev,re,r,rp,1) end
		e:SetOperation(c79205581.bpop)
	else
		e:SetOperation(nil)
	end
end
function c79205581.bpcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_BATTLE) 
		and (not e:GetHandler():IsStatus(STATUS_CHAINING) or e:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c79205581.bpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c79205581.bpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
