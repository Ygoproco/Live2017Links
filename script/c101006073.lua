--雷龍放電
--Thunder Dragon Streamer
--script by Naim
function c101006073.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c101006073.efilter)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101006073,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101006073.condition)
	e3:SetTarget(c101006073.target)
	e3:SetOperation(c101006073.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c101006073.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsRace(RACE_THUNDER)
end
function c101006073.cncfilter(c,tp)
	return c:IsFaceup() and  c:IsSetCard(0x222) and c:IsControler(tp)
end
function c101006073.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101006073.cncfilter,1,nil,tp)
end
function c101006073.rmfilter(c)
	return c:IsAbleToRemove() and c:IsRace(RACE_THUNDER)
end
function c101006073.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101006073.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101006073.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101006073.rmfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingTarget(c101006073.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101006073.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101006073.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101006073.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	local rc=g:GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
