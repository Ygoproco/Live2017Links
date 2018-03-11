--木遁封印式
function c1802450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c1802450.target)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1802450,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c1802450.rmcost)
	e2:SetTarget(c1802450.rmtg)
	e2:SetOperation(c1802450.rmop)
	c:RegisterEffect(e2)
end
function c1802450.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c1802450.rmfilter(c,e)
	return c:IsAbleToRemove() and aux.SpElimFilter(c) and (not e or c:IsCanBeEffectTarget(e))
end
function c1802450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c1802450.rmtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return true end
	if c1802450.rmcost(e,tp,eg,ep,ev,re,r,rp,0) and c1802450.rmtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(1802450,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		c1802450.rmcost(e,tp,eg,ep,ev,re,r,rp,1)
		c1802450.rmtg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c1802450.rmop)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c1802450.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c1802450.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c1802450.cfilter,1,false,aux.ReleaseCheckTarget,nil,dg) end
	local cg=Duel.SelectReleaseGroupCost(tp,c1802450.cfilter,1,1,false,aux.ReleaseCheckTarget,nil,dg)
	Duel.Release(cg,REASON_COST)
end
function c1802450.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c1802450.rmfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(1802450)==0
		and Duel.IsExistingTarget(c1802450.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c1802450.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(1802450,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c1802450.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
