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
	e1:SetCost(c20501450.cost)
	e1:SetTarget(c20501450.target)
	e1:SetOperation(c20501450.activate)
	c:RegisterEffect(e1)
end
function c20501450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c20501450.filter(c)
	return c:IsFaceup() and aux.nzdef(c)
end
function c20501450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local costchk=e:GetLabel()==1
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c20501450.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then
		if costchk and Duel.GetActivityCount(tp,ACTIVITY_ATTACK)>0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c20501450.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c20501450.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if costchk then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc:GetFirst())
		e1:SetLabel(tc:GetFirst():GetFieldID())
		e1:SetTarget(c20501450.cafilter)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c20501450.cafilter(e,c)
	return c~=e:GetLabelObject() or c:GetFieldID()~=e:GetLabel()
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

