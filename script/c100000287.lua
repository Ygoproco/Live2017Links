--バリアンズ・バトル・マスター
function c100000287.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000287.cost)
	e1:SetOperation(c100000287.op)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetCondition(c100000287.condition)
	e2:SetTarget(c100000287.target)
	e2:SetOperation(c100000287.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_BATTLE_END+TIMING_BATTLE_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c100000287.dcon)
	e3:SetCost(c100000287.dcost)
	e3:SetTarget(c100000287.dtg)
	e3:SetOperation(c100000287.dop)
	c:RegisterEffect(e3)
	if not c100000287.global_check then
		c100000287.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c100000287.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100000287.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c100000287.costfilter(c)
	return c:IsBarians() and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c100000287.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000287.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREMOVE)
	local g=Duel.SelectMatchingCard(tp,c100000287.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if Duel.GetAttacker()~=nil and Duel.GetAttacker():IsOnField() and Duel.GetAttacker():IsCanBeEffectTarget(e)
	and Duel.SelectYesNo(tp,aux.Stringid(100000287,0)) then
		e:SetLabel(1)
		Duel.SetTargetCard(Duel.GetAttacker())
		e:GetHandler():RegisterFlagEffect(100000287,RESET_PHASE+PHASE_END,0,1)
	else e:SetLabel(0) end
end
function c100000287.op(e,tp,eg,ep,ev,re,r,rp)
	if	e:GetHandler():GetFlagEffect(100000287)>0 then
		Duel.NegateAttack()
	end
end
function c100000287.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()~=nil and Duel.GetFlagEffect(tp,100000287)==0
end
function c100000287.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c100000287.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
	if e:GetHandler():GetFlagEffect(100000287)>0 then
		Duel.RegisterFlagEffect(tp,100000287,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100000287.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and Duel.GetTurnPlayer()~=tp
end
function c100000287.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c100000287.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
		and Duel.IsExistingTarget(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEUP_ATTACK)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,Card.IsPosition,tp,0,LOCATION_MZONE,1,1,nil,POS_FACEUP_ATTACK)
end
function c100000287.dop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<=1 then return end
	local a=g:GetFirst()
	local d=g:GetNext()
	Duel.CalculateDamage(a,d)
end
