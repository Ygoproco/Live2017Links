--惑星汚染ウイルス
function c39163598.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e1)
	e1:SetCost(c39163598.cost)
	e1:SetTarget(c39163598.target)
	e1:SetOperation(c39163598.activate)
	c:RegisterEffect(e1)
	if not c39163598.global_check then
		c39163598.global_check=true
		c39163598[0]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:SetCountLimit(1)
		ge1:SetOperation(c39163598.endop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c39163598.endop(e,tp,eg,ep,ev,re,r,rp)
	for _,te in ipairs(c39163598[0]) do
		if Duel.GetTurnPlayer()~=te:GetOwnerPlayer() then
			c39163598.reset(te,te:GetOwnerPlayer(),nil,0,0,nil,0,0)
		end
	end
end
function c39163598.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsSetCard,1,false,nil,nil,0xc) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsSetCard,1,1,false,nil,nil,0xc)
	Duel.Release(g,REASON_COST)
end
function c39163598.tgfilter(c)
	return c:IsFaceup() and c:GetCounter(0x100e)==0
end
function c39163598.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c39163598.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c39163598.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c39163598.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c39163598.ctop1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c39163598.ctop2)
	Duel.RegisterEffect(e3,tp)
	local descnum=tp==e:GetHandler():GetOwner() and 0 or 1
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetDescription(aux.Stringid(39163598,descnum))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(1082946)
	e4:SetOwnerPlayer(tp)
	e4:SetLabel(0)
	e4:SetOperation(c39163598.reset)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e4)
	table.insert(c39163598[0],e4)
	c39163598[0][e4]={e1,e2,e3}
end
function c39163598.ctop1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then
		eg:GetFirst():AddCounter(0x100e,1)
	end
end
function c39163598.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetSummonPlayer()~=tp then
			tc:AddCounter(0x100e,1)
		end
		tc=eg:GetNext()
	end
end
function c39163598.reset(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	label=label+1
	e:SetLabel(label)
	if ev==1082946 then
		e:GetOwner():SetTurnCounter(label)
	end
	e:GetOwner():SetTurnCounter(0)
	if label==3 then
		local e1,e2,e3=table.unpack(c39163598[0][e])
		e:Reset()
		if e1 then e1:Reset() end
		if e2 then e2:Reset() end
		if e3 then e3:Reset() end
		c39163598[0][e]=nil
		for i,te in ipairs(c39163598[0]) do
			if te==e then
				table.remove(c39163598[0],i)
				break
			end
		end
	end
end
