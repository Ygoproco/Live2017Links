--飛行エレファント
--Flying Elephant
--Scripted by Eerie Code
function c66765023.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c66765023.reptg)
	c:RegisterEffect(e1)
	--add win effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c66765023.effcon)
	e2:SetOperation(c66765023.effop)
	c:RegisterEffect(e2)
end
function c66765023.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp 
		and Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(66765023)==0 end
	c:RegisterFlagEffect(66765023,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)	
	return true
end
function c66765023.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(66765023)~=0
end
function c66765023.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66765023,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	e1:SetCondition(c66765023.wincon)
	e1:SetOperation(c66765023.winop)
	c:RegisterEffect(e1)
end
function c66765023.wincon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c66765023.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0x1e)
end

