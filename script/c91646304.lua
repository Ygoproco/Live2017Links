--神樹のパラディオン
--Palladion of the Sacred Tree
--Scripted by ahtelel
function c91646304.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,91646304)
	e1:SetCondition(c91646304.spcon)
	e1:SetValue(c91646304.spval)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e2:SetCountLimit(1,91646305)
	e2:SetTarget(c91646304.reptg)
	e2:SetValue(c91646304.repval)
	e2:SetOperation(c91646304.repop)
	c:RegisterEffect(e2)
end
function c91646304.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=Duel.GetLinkedZone(tp)&0x1f
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c91646304.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())&0x1f
end
function c91646304.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x116) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c91646304.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,91646304)==0 and e:GetHandler():IsAbleToRemove() and eg:IsExists(c91646304.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.RegisterFlagEffect(tp,91646304,RESET_PHASE+PHASE_END,0,1)
		return true
	else
		return false
	end
end
function c91646304.repval(e,c)
	return c91646304.repfilter(c,e:GetHandlerPlayer())
end
function c91646304.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

