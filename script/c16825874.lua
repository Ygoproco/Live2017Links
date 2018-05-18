--エキセントリック・ボーイ
function c16825874.initial_effect(c)
	--be material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(c16825874.ccon)
	e2:SetOperation(c16825874.cop)
	c:RegisterEffect(e2)
	--hand synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetLabel(16825874)
	e3:SetValue(c16825874.synval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(73941492+TYPE_SYNCHRO)
	e4:SetValue(c16825874.synfilter)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetOperation(c16825874.synop)
	c:RegisterEffect(e1)
end
function c16825874.synfilter(e,c)
	return c:IsLocation(LOCATION_HAND) and c:IsControler(e:GetHandlerPlayer())
end
function c16825874.ccon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c16825874.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--leave redirect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+0x7e0000)
	rc:RegisterEffect(e1)
	--cannot trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e3)
end
function c16825874.synval(e,c,sc)
	if c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(16825874)
		e1:SetTarget(c16825874.synchktg)
		c:RegisterEffect(e1)
		return true
	else return false end
end
function c16825874.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==16825874 then return true end
	end
	return false
end
function c16825874.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:GetCount()>=2 or (not tg:IsExists(c16825874.chk2,1,c) and not ntg:IsExists(c16825874.chk2,1,c) 
			and not sg:IsExists(c16825874.chk2,1,c)) then return false end
		local ttg=tg:Filter(c16825874.chk2,nil)
		local nttg=ntg:Filter(c16825874.chk2,nil)
		local trg=tg:Clone()
		local ntrg=ntg:Clone()
		trg:Sub(ttg)
		ntrg:Sub(nttg)
		return res,trg,ntrg
	else
		return sg:GetCount()<2
	end
end
function c16825874.synop(e,tg,ntg,sg,lv,sc,tp)
	return sg:GetCount()==2,false
end
