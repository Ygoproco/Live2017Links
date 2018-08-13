--ストイック・チャレンジ
function c37364101.initial_effect(c)
	c:SetUniqueOnField(1,0,37364101)
	aux.AddEquipProcedure(c,nil,c37364101.filter)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c37364101.atkval)
	c:RegisterEffect(e1)
	--damage change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c37364101.damcon)
	e2:SetOperation(c37364101.damop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37364101,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c37364101.tgcon)
	e4:SetTarget(c37364101.tgtg)
	e4:SetOperation(c37364101.tgop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c37364101.desop)
	c:RegisterEffect(e5)
end
function c37364101.filter(c)
	return c:GetOverlayCount()>0
end
function c37364101.atkval(e,c)
	return Duel.GetOverlayCount(e:GetHandlerPlayer(),1,0)*600
end
function c37364101.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:GetBattleTarget()~=nil and tc==e:GetHandler():GetEquipTarget()
end
function c37364101.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DoubleBattleDamage(ep)
end
function c37364101.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c37364101.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c37364101.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end
function c37364101.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
