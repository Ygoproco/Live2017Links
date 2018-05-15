--No.67 パラダイスマッシャー
--Number 67: Paradicesmasher
--Scripted by Eerie Code
function c35772782.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	--roll dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetDescription(aux.Stringid(35772782,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c35772782.condition)
	e1:SetCost(c35772782.cost)
	e1:SetTarget(c35772782.target)
	e1:SetOperation(c35772782.operation)
	c:RegisterEffect(e1)
	--result to 7
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c35772782.dicecon)
	e2:SetOperation(c35772782.diceop)
	c:RegisterEffect(e2)
end
c35772782.xyz_number=67
function c35772782.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c35772782.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c35772782.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function c35772782.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=0
	local d2=0
	local d3=0
	local d4=0
	d1,d2,d3,d4=Duel.TossDice(tp,2,2)
	local t1=d1+d2
	local t2=d3+d4
	if t1==t2 then return end
	local p=0
	if t1>t2 then p=tp else p=1-tp end
	--cannot trigger
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c35772782.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,p)
	--cannot attack
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,p)
end
function c35772782.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c35772782.dicecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and c:GetFlagEffect(35772782)==0
end
function c35772782.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c35772782[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(35772782,1)) then
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		Duel.Hint(HINT_CARD,0,35772782)
		if ct>1 then
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		dc[ac]=7
		Duel.SetDiceResult(table.unpack(dc))
		c35772782[0]=cid
		e:GetHandler():RegisterFlagEffect(35772782,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
