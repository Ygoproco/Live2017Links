--タツネクロ
--Tatsunecro
--Scripted by Eerie Code
function c100307000.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100307000.sslimit)
	c:RegisterEffect(e1)
	--hand synchro
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_HAND_SYNCHRO)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetLabel(100307000)
	e2:SetCondition(c100307000.syncon)
	e2:SetValue(c100307000.synval)
	c:RegisterEffect(e2)
end
function c100307000.sslimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function c100307000.syncon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c100307000.synval(e,c,sc)
	if c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(100307000)
		e1:SetTarget(c100307000.synchktg)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(100307000,RESET_EVENT+RESETS_STANDARD,0,1)
		return true
	else return false end
end
function c100307000.chk(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()~=100307000 then return false end
	end
	return true
end
function c100307000.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==100307000 then return true end
	end
	return false
end
function c100307000.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=true
		if sg:IsExists(c100307000.chk,1,c) or (not tg:IsExists(c100307000.chk2,1,c) and not ntg:IsExists(c100307000.chk2,1,c) 
			and not sg:IsExists(c100307000.chk2,1,c)) then return false end
		local trg=tg:Filter(c100307000.chk,nil)
		local ntrg=ntg:Filter(c100307000.chk,nil)
		return res,trg,ntrg
	else
		return true
	end
end
