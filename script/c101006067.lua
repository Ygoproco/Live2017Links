--サラマングレイト・ギフト
--Salamangreat Gift
--Scripted by Eerie Code
function c101006067.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101006067.target)
	c:RegisterEffect(e1)
	--draw (default)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006067,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c101006067.cost)
	e2:SetTarget(c101006067.drtg1)
	e2:SetOperation(c101006067.drop1)
	c:RegisterEffect(e2)
	--draw (reinc)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(101006067,1))
	e3:SetCondition(c101006067.drcon)
	e3:SetTarget(c101006067.drtg2)
	e3:SetOperation(c101006067.drop2)
	c:RegisterEffect(e3)
end
function c101006067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not c101006067.cost(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local b1=c101006067.drtg1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c101006067.drcon(e,tp,eg,ep,ev,re,r,rp) and c101006067.drtg2(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(101006067,0),aux.Stringid(101006067,1))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(101006067,1))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(101006067,0))
		end
		c101006067.cost(e,tp,eg,ep,ev,re,r,rp,1)
		if op==0 then
			e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
			e:SetOperation(c101006067.drop1)
			c101006067.drtg1(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_DRAW)
			e:SetOperation(c101006067.drop2)
			c101006067.drtg2(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c101006067.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x220) and c:IsDiscardable()
end
function c101006067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101006067)==0
		and Duel.IsExistingMatchingCard(c101006067.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.RegisterFlagEffect(tp,101006067,RESET_PHASE+PHASE_END,0,1)
	Duel.DiscardHand(tp,c101006067.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c101006067.gyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x220) and c:IsAbleToGrave()
end
function c101006067.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c101006067.gyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101006067.drop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101006067.gyfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c101006067.lkfilter(c)
	return c:IsSetCard(0x220) and c:IsType(TYPE_LINK) and c:GetFlagEffect(101006040)~=0--c:GetMaterial():IsExists(Card.IsLinkCode,1,nil,c:GetCode())
end
function c101006067.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101006067.lkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101006067.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101006067.drop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
