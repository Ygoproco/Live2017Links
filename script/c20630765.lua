--魔石術師 クルード
function c20630765.initial_effect(c)
	c:EnableCounterPermit(0x16)
	c:SetCounterLimit(0x16,1)
	--Add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c20630765.ctcon)
	e1:SetOperation(c20630765.ctop)
	c:RegisterEffect(e1)
	--attackup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c20630765.defup)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20630765,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c20630765.rmcost)
	e3:SetTarget(c20630765.rmtg)
	e3:SetOperation(c20630765.rmop)
	c:RegisterEffect(e3)
end
function c20630765.ctcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and c:GetFlagEffect(1)>0
end
function c20630765.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x16,1)
end
function c20630765.defup(e,c)
	return c:GetCounter(0x16)*300
end
function c20630765.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x16,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x16,1,REASON_COST)
end
function c20630765.rmfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c)
end
function c20630765.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c20630765.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20630765.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c20630765.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c20630765.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
