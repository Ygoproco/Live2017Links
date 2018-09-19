--サラマングレイト・ギフト
--Salamangreat Gift
--Scripted by Eerie Code
function c20788863.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20788863.target)
	c:RegisterEffect(e1)
	--draw (default)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20788863,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c20788863.cost)
	e2:SetTarget(c20788863.drtg1)
	e2:SetOperation(c20788863.drop1)
	c:RegisterEffect(e2)
	--draw (reinc)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(20788863,1))
	e3:SetCondition(c20788863.drcon)
	e3:SetTarget(c20788863.drtg2)
	e3:SetOperation(c20788863.drop2)
	c:RegisterEffect(e3)
	--recarnation check
	if not c20788863.g_chk then
		c20788863.g_chk=true
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MATERIAL_CHECK)
		e1:SetValue(c20788863.val)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge1:SetLabelObject(e1)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetTarget(c20788863.gtg)
		Duel.RegisterEffect(ge1,0)
	end
end
function c20788863.gtg(e,c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x119)
end
function c20788863.val(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,c:GetCode()) and c:IsSummonType(SUMMON_TYPE_LINK) then
		c:RegisterFlagEffect(41463181,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE-RESET_TEMP_REMOVE,0,1)
	end
end
function c20788863.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetCategory(0)
	e:SetOperation(nil)
	if not c20788863.cost(e,tp,eg,ep,ev,re,r,rp,0) then return end
	local b1=c20788863.drtg1(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c20788863.drcon(e,tp,eg,ep,ev,re,r,rp) and c20788863.drtg2(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(20788863,0),aux.Stringid(20788863,1))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(20788863,1))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(20788863,0))
		end
		c20788863.cost(e,tp,eg,ep,ev,re,r,rp,1)
		if op==0 then
			e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
			e:SetOperation(c20788863.drop1)
			c20788863.drtg1(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_DRAW)
			e:SetOperation(c20788863.drop2)
			c20788863.drtg2(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c20788863.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x119) and c:IsDiscardable()
end
function c20788863.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20788863)==0
		and Duel.IsExistingMatchingCard(c20788863.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.RegisterFlagEffect(tp,20788863,RESET_PHASE+PHASE_END,0,1)
	Duel.DiscardHand(tp,c20788863.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c20788863.gyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x119) and c:IsAbleToGrave()
end
function c20788863.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c20788863.gyfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20788863.drop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20788863.gyfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c20788863.lkfilter(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK) and c:GetFlagEffect(41463181)~=0--c:GetMaterial():IsExists(Card.IsLinkCode,1,nil,c:GetCode())
end
function c20788863.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20788863.lkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20788863.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c20788863.drop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
