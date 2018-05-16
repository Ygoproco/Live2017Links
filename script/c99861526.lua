--サブマリンロイド
--Submarineroid
function c99861526.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--damage reduce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c99861526.rdcon)
	e2:SetOperation(c99861526.rdop)
	c:RegisterEffect(e2)
	--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99861526,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c99861526.poscon)
	e3:SetOperation(c99861526.posop)
	c:RegisterEffect(e3)
end
function c99861526.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
		and e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
		and Duel.IsExistingMatchingCard(aux.NOT(Card.IsHasEffect),tp,0,LOCATION_MZONE,1,nil,EFFECT_IGNORE_BATTLE_TARGET)
end
function c99861526.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local effs={c:GetCardEffect(EFFECT_DIRECT_ATTACK)}
	local eg=Group.CreateGroup()
	for _,eff in ipairs(effs) do
		eg:AddCard(eff:GetOwner())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local ec = #eg==1 and eg:GetFirst() or eg:Select(tp,1,1,nil):GetFirst()
	if c==ec then
		Duel.ChangeBattleDamage(ep,c:GetBaseAttack(),false)
	end
end
function c99861526.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsAttackPos()
end
function c99861526.posop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end