--超雷龍ーサンダー•ドラゴン
--Superbolt Thunder Dragon
--Scripted by AlphaKretin
function c15291624.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_THUNDER),1,1,31786629)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c15291624.hspcon)
	e2:SetOperation(c15291624.hspop)
	c:RegisterEffect(e2)
	--disable search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c15291624.desreptg)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(15291624,ACTIVITY_CHAIN,c15291624.chainfilter)
end
function c15291624.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_THUNDER)
		and (Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND))
end
function c15291624.hspfilter(c,tp,sc)
	return c:IsRace(RACE_THUNDER) and not c:IsType(TYPE_FUSION,sc,SUMMON_TYPE_FUSION,tp) 
		and c:IsType(TYPE_EFFECT,sc,SUMMON_TYPE_FUSION,tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 
		and Duel.GetCustomActivityCount(15291624,tp,ACTIVITY_CHAIN)~=0
end
function c15291624.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c15291624.hspfilter,1,nil,c:GetControler(),c)
end
function c15291624.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c15291624.hspfilter,1,1,nil,tp,c)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c15291624.repfilter(c)
	return c:IsRace(RACE_THUNDER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c15291624.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
	return not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(c15291624.repfilter,tp,LOCATION_GRAVE,0,1,1,nil) end
	if Duel.SelectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c15291624.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g:GetFirst(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end

