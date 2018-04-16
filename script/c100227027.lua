--虚無械アイン
--Emptiness
--Scripted by Eerie Code
function c100227027.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100227027.target)
	c:RegisterEffect(e1)
	--insd via destroy replace (workaround)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100227027.reptg)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100227027,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c100227027.drcost)
	e3:SetTarget(c100227027.drtg)
	e3:SetOperation(c100227027.drop)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100227027,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c100227027.tdcon)
	e4:SetCost(c100227027.cost)
	e4:SetTarget(c100227027.tdtg)
	e4:SetOperation(c100227027.tdop)
	c:RegisterEffect(e4)
end
function c100227027.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp and e:GetHandler():GetFlagEffect(100227027)==0 end
    c:RegisterFlagEffect(100227027,RESET_EVENT+0x1fe0000,0,1)
	return true
end
function c100227027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c100227027.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c100227027.drcost(e,tp,eg,ep,ev,re,r,rp,0)
		and c100227027.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c100227027.tdcon(e,tp,eg,ep,ev,re,r,rp)
		and c100227027.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c100227027.tdtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(100227027,0),aux.Stringid(100227027,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(100227027,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(100227027,1))+1
		end
		if op==0 then
			e:SetCategory(CATEGORY_DRAW)
			e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e:SetOperation(c100227027.drop)
			c100227027.drcost(e,tp,eg,ep,ev,re,r,rp,1)
			c100227027.drtg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_TODECK)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c100227027.tdop)
			c100227027.cost(e,tp,eg,ep,ev,re,r,rp,1)
			c100227027.tdtg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c100227027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(100227027)==0 end
	c:RegisterFlagEffect(100227027,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100227027.drfilter(c)
	return c:GetLevel()==10 and c:IsDiscardable()
end
function c100227027.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100227027.drfilter,tp,LOCATION_HAND,0,1,nil)
		and c100227027.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.DiscardHand(tp,c100227027.drfilter,1,1,REASON_COST+REASON_DISCARD)
	c100227027.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100227027.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100227027.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c100227027.setfilter(c)
	return c:GetSequence()<5
end
function c100227027.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100227027.setfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c100227027.tdfilter(c)
	return c:IsSetCard(0x4a) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c100227027.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100227027.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100227027.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100227027.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100227027.setfilter(c)
	return c:IsCode(100227028) and c:IsSSetable()
end
function c100227027.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c100227027.setfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100227027,2)) then
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SSet(tp,sc)
		end
	end
end
