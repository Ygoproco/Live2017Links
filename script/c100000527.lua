--運命の戦車
function c100000527.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x55b),true)
	--direct_attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000527,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(aux.IsUnionState)
	e5:SetCost(c100000527.atkcost)
	e5:SetOperation(c100000527.atkop)
	c:RegisterEffect(e5)
end
function c100000527.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(c100000527.value)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)		
end
function c100000527.value(e,c)
	return c:GetAttack()/2
end
function c100000527.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e3)
end
