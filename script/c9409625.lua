--虚無械アイン
--Empty Machine
--Scripted by Eerie Code
function c9409625.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9409625.target)
	c:RegisterEffect(e1)
	--insd via destroy replace (workaround)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c9409625.reptg)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9409625,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c9409625.drcost)
	e3:SetTarget(c9409625.drtg)
	e3:SetOperation(c9409625.drop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9409625,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c9409625.tdcon)
	e4:SetCost(c9409625.cost)
	e4:SetTarget(c9409625.tdtg)
	e4:SetOperation(c9409625.tdop)
	c:RegisterEffect(e4)
end
function c9409625.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp and e:GetHandler():GetFlagEffect(9409626)==0 end
    c:RegisterFlagEffect(9409626,RESET_EVENT+0x1fe0000,0,1)
	return true
end
function c9409625.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c9409625.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c9409625.drcost(e,tp,eg,ep,ev,re,r,rp,0)
		and c9409625.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c9409625.tdcon(e,tp,eg,ep,ev,re,r,rp)
		and c9409625.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c9409625.tdtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(9409625,0),aux.Stringid(9409625,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(9409625,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(9409625,1))+1
		end
		if op==0 then
			e:SetCategory(CATEGORY_DRAW)
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e:SetOperation(c9409625.drop)
			c9409625.drcost(e,tp,eg,ep,ev,re,r,rp,1)
			c9409625.drtg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_TODECK)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c9409625.tdop)
			c9409625.cost(e,tp,eg,ep,ev,re,r,rp,1)
			c9409625.tdtg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c9409625.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9409625)==0 end
	c:RegisterFlagEffect(9409625,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c9409625.drfilter(c)
	return c:GetLevel()==10 and c:IsDiscardable()
end
function c9409625.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9409625.drfilter,tp,LOCATION_HAND,0,1,nil)
		and c9409625.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.DiscardHand(tp,c9409625.drfilter,1,1,REASON_COST+REASON_DISCARD)
	c9409625.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c9409625.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9409625.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9409625.stfilter(c)
	return c:GetSequence()<5
end
function c9409625.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9409625.stfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c9409625.tdfilter(c)
	return c:IsSetCard(0x4a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c9409625.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9409625.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9409625.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9409625.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c9409625.setfilter(c)
	return c:IsCode(36894320) and c:IsSSetable()
end
function c9409625.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c9409625.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9409625,2)) then
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SSet(tp,sc)
			Duel.ConfirmCards(1-tp,sc)
		end
	end
end

