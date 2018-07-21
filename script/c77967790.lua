--ダイナレスラー・キング・Ｔレッスル
--Dinowrestler King T Wrextle
--script anime version by Larry126, update by Naim
function c77967790.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x11a),2)
	c:EnableReviveLimit()
	--activation limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c77967790.aclimit)
	e1:SetCondition(c77967790.actcon)
	c:RegisterEffect(e1)
	--attack limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c77967790.atlimit)
	c:RegisterEffect(e2)
	--target lock
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77967790,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77967790.atkcon)
	e3:SetTarget(c77967790.atktg)
	e3:SetOperation(c77967790.atkop)
	c:RegisterEffect(e3)
end
function c77967790.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c77967790.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c77967790.atlimit(e,c)
	return c~=e:GetHandler()
end
function c77967790.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c77967790.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAttackPos() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
end
function c77967790.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(77967790,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCondition(c77967790.atkcon2)
		e1:SetTarget(c77967790.atktg2)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(77967790,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetLabelObject(tc)
		e2:SetCondition(c77967790.descon)
		e2:SetOperation(c77967790.desop)
		e2:SetReset(RESET_PHASE+PHASE_BATTLE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c77967790.descon(e)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(77967790)~=0 and tc:GetAttackAnnouncedCount()==0
end
function c77967790.atkcon2(e)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(77967790)~=0 and tc:GetAttackAnnouncedCount()==0
end
function c77967790.atktg2(e,c)
	return c~=e:GetLabelObject()
end
function c77967790.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(77967790)~=0 and tc:GetAttackAnnouncedCount()==0
end
function c77967790.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,77967790)
	Duel.Destroy(tc,REASON_EFFECT)
end
