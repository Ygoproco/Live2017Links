--セフィラ・メタトロン
--Zefra Metaltron
--Scripted by Eerie Code
function c85216896.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c85216896.matfilter,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c85216896.regcon)
	e1:SetOperation(c85216896.regop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c85216896.regcon2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85216896,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_CUSTOM+85216896)
	e3:SetCountLimit(1,85216896)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c85216896.thtg)
	e3:SetOperation(c85216896.thop)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(85216896,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,85216897)
	e4:SetTarget(c85216896.rmtg)
	e4:SetOperation(c85216896.rmop)
	c:RegisterEffect(e4)
end
function c85216896.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c85216896.thcfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c85216896.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c85216896.thcfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c85216896.thcfilter2(c,tp,zone)
	return c:IsReason(REASON_DESTROY) and c85216896.thcfilter(c,tp,zone)
end
function c85216896.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c85216896.thcfilter2,1,nil,tp,e:GetHandler():GetLinkedZone()) and rp~=tp
end
function c85216896.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+85216896,e,0,tp,0,0)
end
function c85216896.thfilter(c)
	return (not c:IsLocation(LOCATION_EXTRA) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c85216896.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85216896.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c85216896.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c85216896.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c85216896.rmfilter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToRemove()
end
function c85216896.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c85216896.rmfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c85216896.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c85216896.rmfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c85216896.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c85216896.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(85216896,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(g)
	e1:SetCountLimit(1)
	e1:SetCondition(c85216896.retcon)
	e1:SetOperation(c85216896.retop)
	Duel.RegisterEffect(e1,tp)
end
function c85216896.retfilter(c)
	return c:GetFlagEffect(85216896)~=0
end
function c85216896.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c85216896.retfilter,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c85216896.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c85216896.retfilter,nil)
	g:DeleteGroup()
	local tc=g:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=g:GetNext()
	end
end
