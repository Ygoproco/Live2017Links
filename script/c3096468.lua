--タツネクロ
--Tatsunecro
--Scripted by Eerie Code
function c3096468.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c3096468.sslimit)
	c:RegisterEffect(e1)
	--hand synchro
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_HAND_SYNCHRO)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabel(3096468)
	e2:SetCondition(c3096468.syncon)
	e2:SetValue(c3096468.synval)
	c:RegisterEffect(e2)
end
function c3096468.sslimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function c3096468.syncon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c3096468.synval(e,c,sc)
	if c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(3096468)
		e1:SetTarget(c3096468.synchktg)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(3096468,RESET_EVENT+RESETS_STANDARD,0,1)
		return true
	else return false end
end
function c3096468.chk(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()~=3096468 then return false end
	end
	return true
end
function c3096468.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==3096468 then return true end
	end
	return false
end
function c3096468.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:IsExists(c3096468.chk,1,c) or (not tg:IsExists(c3096468.chk2,1,c) and not ntg:IsExists(c3096468.chk2,1,c) 
			and not sg:IsExists(c3096468.chk2,1,c)) then return false end
		local trg=tg:Filter(c3096468.chk,nil)
		local ntrg=ntg:Filter(c3096468.chk,nil)
		return res,trg,ntrg
	else
		return true
	end
end

