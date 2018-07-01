--銀河の修道師
--Galaxy Cleric
--Scripted by Eerie Code
function c101006010.initial_effect(c)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101006010)
	e1:SetTarget(c101006010.mattg)
	e1:SetOperation(c101006010.matop)
	c:RegisterEffect(e1)
	--shuffle & draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006010,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101006010)
	e2:SetTarget(c101006010.drtg)
	e2:SetOperation(c101006010.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101006010.matfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsType(TYPE_XYZ)
end
function c101006010.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101006010.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101006010.matfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101006010.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101006010.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c101006010.tdfilter(c,e)
	return (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c101006010.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==#sg
end
function c101006010.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local tg=Duel.GetMatchingGroup(c101006010.tdfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and aux.SelectUnselectGroup(tg,e,tp,5,5,c101006010.rescon,0) end
	local g=aux.SelectUnselectGroup(tg,e,tp,5,5,c101006010.rescon,1,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101006010.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
