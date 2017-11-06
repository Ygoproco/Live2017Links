--スーパーバグマン
function c86804246.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,86804246)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCondition(c86804246.spcon)
	e1:SetOperation(c86804246.spop)
	c:RegisterEffect(e1)
	--swap ad
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SWAP_AD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c86804246.adfilter)
	c:RegisterEffect(e2)
end
function c86804246.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c86804246.chk,1,nil,sg,Group.CreateGroup(),87526784,23915499,50319138)
end
function c86804246.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res=true
	if ... then
		g:AddCard(c)
		res=sg:IsExists(c86804246.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	end
	return res
end
function c86804246.spfilter(c,...)
	return c:IsCode(...) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c86804246.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg1=Duel.GetMatchingGroup(c86804246.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,87526784)
	local rg2=Duel.GetMatchingGroup(c86804246.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,23915499)
	local rg3=Duel.GetMatchingGroup(c86804246.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,50319138)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	rg:Merge(rg3)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and rg1:GetCount()>0 and rg2:GetCount()>0 and rg3:GetCount()>0 
		and aux.SelectUnselectGroup(rg,e,tp,3,3,c86804246.rescon,0)
end
function c86804246.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c86804246.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,87526784,23915499,50319138)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,c86804246.rescon,1,tp,HINTMSG_REMOVE)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c86804246.adfilter(e,c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
