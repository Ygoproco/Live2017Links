--Sin パラレルギア
function c74509280.initial_effect(c)
	--hand synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetLabel(74509280)
	e3:SetValue(c74509280.synval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(73941492+TYPE_SYNCHRO)
	e4:SetValue(c74509280.synfilter)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetOperation(c74509280.synop)
	c:RegisterEffect(e1)
end
function c74509280.synfilter(e,c)
	return c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x23) and c:IsControler(e:GetHandlerPlayer())
end
function c74509280.synval(e,c,sc)
	if c:IsSetCard(0x23) and c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(74509280)
		e1:SetTarget(c74509280.synchktg)
		c:RegisterEffect(e1)
		return true
	else return false end
end
function c74509280.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==74509280 then return true end
	end
	return false
end
function c74509280.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:GetCount()>=2 or (not tg:IsExists(c74509280.chk2,1,c) and not ntg:IsExists(c74509280.chk2,1,c) 
			and not sg:IsExists(c74509280.chk2,1,c)) then return false end
		local ttg=tg:Filter(c74509280.chk2,nil)
		local nttg=ntg:Filter(c74509280.chk2,nil)
		local trg=tg:Clone()
		local ntrg=ntg:Clone()
		trg:Sub(ttg)
		ntrg:Sub(nttg)
		return res,trg,ntrg
	else
		return sg:GetCount()<2
	end
end
function c74509280.synop(e,tg,ntg,sg,lv,sc,tp)
	return sg:GetCount()==2,false
end
