--生命吸収装置
function c14318794.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_STANDBY_PHASE,0)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14318794,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c14318794.reccon)
	e2:SetTarget(c14318794.rectg)
	e2:SetOperation(c14318794.recop)
	c:RegisterEffect(e2)
	if not c14318794.global_check then
		c14318794.global_check=true
		c14318794[0]={}
		c14318794[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c14318794.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetOperation(c14318794.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c14318794.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
		local val=math.ceil(ev/2)
		table.insert(c14318794[ep],val)
	end
end
function c14318794.clear(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	c14318794[p+2]={table.unpack(c14318794[p])}
	c14318794[p]={}
end
function c14318794.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c14318794.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return #c14318794[tp+2]>0 and (c:GetFlagEffect(14318794)==0 or c14318794[tp+2][c:GetFlagEffectLabel(14318794)+1]) end
	local rec
	if c:GetFlagEffect(14318794)==0 then
		rec=c14318794[tp+2][1]
		c:RegisterFlagEffect(14318794,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,1,1)
	else
		rec=c14318794[tp+2][c:GetFlagEffectLabel(14318794)+1]
		c:SetFlagEffectLabel(14318794,c:GetFlagEffectLabel(14318794)+1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,c14318794[2][1])
end
function c14318794.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
