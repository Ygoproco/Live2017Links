--Yellow Dragon Ninja
--Scripted by Eerie Code
function c100243013.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100243013.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100243013,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100243013.cost)
	e2:SetTarget(c100243013.target)
	e2:SetOperation(c100243013.operation)
	c:RegisterEffect(e2)
end
function c100243013.splimit(e,se,sp,st)
	return (se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsSetCard(0x2b)) or se:GetHandler():IsSetCard(0x61)
end
function c100243013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100243013.cfilter(c)
	return ((c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2b)) or c:IsSetCard(0x61))
		and (c:IsFaceup() or not c:IsOnField())
		and c:IsAbleToGraveAsCost()
end
function c100243013.filter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (not e or c:IsCanBeEffectTarget(e))
end
function c100243013.costfilter(c,dg)
	local a=0
	local eg=Duel.GetMatchingGroup(c100243013.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if dg:IsContains(c) then a=1 end
	local tc=eg:GetFirst()
	while tc do
		if dg:IsContains(tc) then a=a+1 end
		tc=eg:GetNext()
	end
	return dg:GetCount()-a>=1
end
function c100243013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100243013.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			local rg=Duel.GetMatchingGroup(c100243013.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
			local dg=Duel.GetMatchingGroup(c100243013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
			return rg:IsExists(c100243013.costfilter,1,nil,dg)
		else
			return Duel.IsExistingTarget(c100243013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local rg=Duel.GetMatchingGroup(c100243013.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
		local dg=Duel.GetMatchingGroup(c100243013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=rg:FilterSelect(tp,c100243013.costfilter,1,1,nil,dg)
		Duel.SendtoGrave(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100243013.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c100243013.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
