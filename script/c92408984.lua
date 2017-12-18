--ドラゴンの宝珠
function c92408984.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c92408984.cost)
	e1:SetTarget(c92408984.target)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92408984,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c92408984.discon)
	e2:SetCost(c92408984.discost)
	e2:SetTarget(c92408984.distg)
	e2:SetOperation(c92408984.disop)
	c:RegisterEffect(e2)
	--Double Snare
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(3682106)
	c:RegisterEffect(e6)
end
function c92408984.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c92408984.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c92408984.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(0)
		return true
	end
	local ct=Duel.GetCurrentChain()-1
	if ct<=0 then return end
	local pe,p=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local g=Group.FromCards(pe:GetHandler())
	if c92408984.discon(e,tp,g,p,ct,pe,0,p) and (e:GetLabel()~=1 or c92408984.discost(e,tp,g,p,ct,pe,0,p,0)) and c92408984.distg(e,tp,g,p,ct,pe,0,p,0) then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
		e:SetOperation(c92408984.activate(g,ct,pe))
		if e:GetLabel()==1 then c92408984.discost(e,tp,g,p,ct,pe,0,p,1) end
		c92408984.distg(e,tp,g,p,ct,pe,0,p,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c92408984.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not re:GetHandler():IsType(TYPE_TRAP) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c92408984.cfilter,1,nil) and Duel.IsChainDisablable(ev)
end
function c92408984.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c92408984.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if eg:GetFirst():IsOnField() then
		Duel.SetTargetCard(eg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c92408984.activate(teg,tev,tre)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				if e:GetHandler():IsRelateToEffect(e) and Duel.NegateEffect(tev) and tre:GetHandler():IsRelateToEffect(tre) then
					Duel.Destroy(teg,REASON_EFFECT)
				end
			end
end
function c92408984.disop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
