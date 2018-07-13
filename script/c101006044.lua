--オルフェゴール・ロンギルス
--Orphegel Longirus
function c101006044.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,nil,c101006044.matcheck)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(c101006044.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006044,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101006044)
	e2:SetTarget(c101006044.tdtg)
	e2:SetOperation(c101006044.tdop)
	c:RegisterEffect(e2)
end
function c101006044.matcheck(g,lc,tp)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x225)
end
function c101006044.indcon(e)
	return e:GetHandler():IsLinkState()
end
function c101006044.tdfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function c101006044.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c101006044.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101006044.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101006044.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c101006044.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if #og==0 then return end
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local g=Duel.GetMatchingGroup(Card.IsLinkState,tp,0,LOCATION_MZONE,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101006044,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
