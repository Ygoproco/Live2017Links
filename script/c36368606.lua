--サイバネット・リフレッシュ
--Cynet Refresh
--Scripted by Eerie Code
function c36368606.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c36368606.condition)
	e1:SetTarget(c36368606.target)
	e1:SetOperation(c36368606.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c36368606.immcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c36368606.immop)
	c:RegisterEffect(e2)
end
function c36368606.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttacker():IsRace(RACE_CYBERSE)
end
function c36368606.desfilter(c)
	return c:GetSequence()<5
end
function c36368606.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c36368606.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c36368606.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c36368606.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(og)
		e1:SetOperation(c36368606.spop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c36368606.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,c:GetControler())
end
function c36368606.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c36368606.spfilter,nil,e,tp)
	if g:GetCount()==0 then return end
	for p=0,1 do
		local tg=g:Filter(Card.IsControler,nil,p)
		local lc=Duel.GetLocationCount(p,LOCATION_MZONE)
		if tg:GetCount()>lc then
			tg=tg:Select(tp,lc,lc,nil)
		end
		for tc in aux.Next(tg) do
			Duel.SpecialSummonStep(tc,0,tp,p,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
end
function c36368606.immcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c36368606.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c36368606.etarget)
	e1:SetValue(c36368606.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c36368606.etarget(e,c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
end
function c36368606.efilter(e,te,c)
	return te:GetOwner()~=c
end

