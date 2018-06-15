--ironfur grizzly
function c10000.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10000.spcon)
	e1:SetCost(c10000.cost)
	e1:SetTarget(c10000.target)
	e1:SetOperation(c10000.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c10000.atklimit)
	c:RegisterEffect(e2)
	--atk limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c10000.tg)
	e3:SetCondition(c10000.btcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
end
function c10000.spcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph==PHASE_BATTLE and Duel.GetCurrentChain()==0
end
function c10000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fd=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return fd:IsCanRemoveCounter(tp,0xed,lv,REASON_COST) end
	fd:RemoveCounter(tp,0xed,lv,REASON_COST)
	fd:AddCounter(0xee,lv)
end
function c10000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(12345678,RESET_EVENT+0x1fe0000,0,1)
	Duel.SetChainLimit(aux.FALSE)
end
function c10000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c10000.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c10000.tg(e,c)
	return not c:GetFlagEffect(12345678)>0
end
function c10000.btcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12345678)>0
end