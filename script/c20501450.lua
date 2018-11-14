--コンセントレイト
--Rockin'-Outlet
function c20501450.initial_effect(c)
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20501450.condition)
	e1:SetCost(c20501450.cost)
	e1:SetTarget(c20501450.target)
	e1:SetOperation(c20501450.activate)
	c:RegisterEffect(e1)
	if not c20501450.global_check then
		c20501450.global_check=true
		c20501450[0]=0
		c20501450[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c20501450.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c20501450.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c20501450.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetFlagEffect(20501450)==0 then
		c20501450[ep]=c20501450[ep]+1
		tc:RegisterFlagEffect(20501450,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c20501450.clear(e,tp,eg,ep,ev,re,r,rp)
	c20501450[0]=0
	c20501450[1]=0
end
function c20501450.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c20501450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c20501450.filter(c,tp,costchk)
	return c:IsFaceup() and aux.nzdef(c) and (not costchk or c20501450[tp]==0 or c:GetFlagEffect(20501450)~=0)
end
function c20501450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local costchk=e:GetLabel()==1
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20501450.filter(chkc,tp,costchk) and chkc:IsControler(tp) end
	if chk==0 then
		if costchk and c20501450[tp]>=2 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c20501450.filter,tp,LOCATION_MZONE,0,1,nil,tp,costchk)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20501450.filter,tp,LOCATION_MZONE,0,1,1,nil,tp,costchk)
	if costchk then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_OATH)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c20501450.ftarget)
		e1:SetLabel(g:GetFirst():GetFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c20501450.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c20501450.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetDefense())
		tc:RegisterEffect(e1)
	end
end

