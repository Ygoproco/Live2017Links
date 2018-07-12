--オルフェゴール・コア
--Orphegel Core
--Scripted by andré and Eerie Code
function c101006071.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101006071.target)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006071,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c101006071.immcost)
	e2:SetTarget(c101006071.immtg)
	e2:SetOperation(c101006071.immop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c101006071.reptg)
	e3:SetValue(c101006071.repval)
	e3:SetOperation(c101006071.repop)
	c:RegisterEffect(e3)
end
function c101006071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c101006071.immcost(e,tp,eg,ep,ev,re,r,rp,0) and c101006071.immtg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c101006071.immop)
		c101006071.immcost(e,tp,eg,ep,ev,re,r,rp,1)
		c101006071.immtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c101006071.cfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and aux.SpElimFilter(c,false,true)
		and Duel.IsExistingTarget(c101006071.filter,tp,LOCATION_ONFIELD,0,1,c)
end
function c101006071.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x225) or c:IsSetCard(0xfe)) and not c:IsCode(101006071)
end
function c101006071.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(101006071)==0
		and Duel.IsExistingMatchingCard(c101006071.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	e:GetHandler():RegisterFlagEffect(101006071,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectMatchingCard(tp,c101006071.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101006071.immtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c101006071.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101006071.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SelectTarget(tp,c101006071.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c101006071.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c101006071.repfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x225) or c:IsSetCard(0xfe)) and c:IsOnField()
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c101006071.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and not eg:IsContains(e:GetHandler())
		and eg:IsExists(c101006071.repfilter,1,e:GetHandler(),tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		return true
	else
		return false
	end
end
function c101006071.repval(e,c)
	return c101006071.repfilter(c,e:GetHandlerPlayer())
end
function c101006071.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
