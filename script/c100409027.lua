--ブラック・バード・クローズ
--Black Bird Close
--scripted by Naim
function c100409027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c100409027.condition)
	e1:SetCost(c100409027.cost)
	e1:SetTarget(c100409027.target)
	e1:SetOperation(c100409027.activate)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c100409027.handcon)
	c:RegisterEffect(e2)
end
c100409027.listed_names={9012916}
function c100409027.condition(e,tp,eg,ep,ev,re,r,rp)
	local p,loct=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return loct==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and p~=tp and Duel.IsChainNegatable(ev)
end
function c100409027.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and c:IsAbleToGraveAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100409027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100409027.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100409027.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100409027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100409027.spfilter(c,e,tp)
	return c:IsCode(9012916) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100409027.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local loc=0
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		local g=Duel.GetMatchingGroup(c100409027.spfilter,tp,loc,0,nil,e,tp)
		if loc~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100409027,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end
function c100409027.filter(c)
	return c:IsFaceup() and (c:IsCode(9012916) or (c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO)))
end
function c100409027.handcon(e)
	return Duel.IsExistingMatchingCard(c100409027.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end