--アルカナフォースⅩⅣ－TEMPERANCE
local s,id=GetID()
function s.initial_effect(c)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.damcon)
	e1:SetCost(s.damcost)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.cointg)
	e2:SetOperation(s.coinop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
s.toss_coin=true
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(s.dop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	s.arcanareg(c,res)
end
function s.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(s.rdcon1)
	e1:SetOperation(s.rdop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(s.rdcon2)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function s.rdcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function s.rdcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.HalfBattleDamage(ep)
end
