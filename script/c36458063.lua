--魔女の一撃
--Witch's Strike
--Scripted by Eerie Code, credits to Larry126 and andré for the workaround
function c36458063.initial_effect(c)
	local EVENT_SUMMON_NEGATED = EVENT_CUSTOM+36458064
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36458063,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CUSTOM+36458063)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c36458063.condition1)
	e1:SetTarget(c36458063.target)
	e1:SetOperation(c36458063.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_NEGATED)
	e2:SetCondition(c36458063.condition2)
	c:RegisterEffect(e2)
	if not c36458063.global_check then
		c36458063.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(c36458063.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c36458063.checkop(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	if de then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+36458063,e,0,dp,0,0)
	end
end
function c36458063.cfilter(c,p)
	return c:GetReasonPlayer()~=p and (c:IsSummonType(SUMMON_TYPE_NORMAL) or c:IsSummonType(SUMMON_TYPE_SPECIAL))
end
function c36458063.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c36458063.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c36458063.cfilter,1,nil,tp)
end
function c36458063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c36458063.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
end
