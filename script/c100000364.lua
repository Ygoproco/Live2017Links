--Eternal Reverse
function c100000364.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Turn Set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100000364.tstg)
	e3:SetOperation(c100000364.tsop)
	c:RegisterEffect(e3)
	--Save Monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c100000364.destg)
	e4:SetOperation(c100000364.desop)
	c:RegisterEffect(e4)
end
function c100000364.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c100000364.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c100000364.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000364.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100000364.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c100000364.tsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN)
	end
end
function c100000364.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=c:GetEquipTarget()
	if chk==0 then return c and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and tg and tg:IsReason(REASON_BATTLE) end
	return Duel.SelectYesNo(tp,aux.Stringid(100000364,0))
end
function c100000364.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
