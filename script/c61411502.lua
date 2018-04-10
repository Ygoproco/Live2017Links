--エレメンタルバースト
function c61411502.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCost(c61411502.cost)
	e1:SetTarget(c61411502.target)
	e1:SetOperation(c61411502.activate)
	c:RegisterEffect(e1)
end
function c61411502.spcheck(sg,tp)
	return sg:IsExists(c61411502.chk1,1,nil,sg)
end
function c61411502.chk1(c,sg)
	return c:IsAttribute(ATTRIBUTE_EARTH) and sg:IsExists(c61411502.chk2,1,c,sg,Group.FromCards(c))
end
function c61411502.chk2(c,sg,ex)
	local ex2=ex+c
	return c:IsAttribute(ATTRIBUTE_FIRE) and sg:IsExists(c61411502.chk3,1,ex2,sg,ex2)
end
function c61411502.chk3(c,sg,ex)
	local ex2=ex+c
	return c:IsAttribute(ATTRIBUTE_WATER) and sg:IsExists(Card.IsAttribute,1,ex2,ATTRIBUTE_WIND)
end
function c61411502.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsAttribute,4,false,c61411502.spcheck,nil,ATTRIBUTE_WIND+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH) end
	local sg=Duel.SelectReleaseGroupCost(tp,Card.IsAttribute,4,4,false,c61411502.spcheck,nil,ATTRIBUTE_WIND+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH)
	Duel.Release(sg,REASON_COST)
end
function c61411502.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c61411502.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
