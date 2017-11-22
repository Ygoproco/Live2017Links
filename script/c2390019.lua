--おジャマ改造
--Ojamadification
function c2390019.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c2390019.cost)
	e1:SetTarget(c2390019.target)
	e1:SetOperation(c2390019.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c2390019.drtg)
	e2:SetOperation(c2390019.drop)
	c:RegisterEffect(e2)
end
function c2390019.ffilter(c,e,tp,rg,ft)
	if not c.material then return false end
	local g=Duel.GetMatchingGroup(c2390019.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,table.unpack(c.material))
	return g:GetCount()>0 and c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) 
		and aux.SelectUnselectGroup(rg,e,tp,nil,1,c2390019.rescon1(g,ft),0)
end
function c2390019.cfilter(c)
	return c:IsSetCard(0xf) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_HAND) or aux.SpElimFilter(c,true,true))
end
function c2390019.spfilter(c,e,tp,...)
	return c:IsCode(...) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2390019.rescon1(g,ft)
	return	function(sg,e,tp,mg)
				local ct=sg:GetCount()
				local tg=g:Filter(aux.TRUE,sg)
				return ft+sg:FilterCount(aux.MZFilter,nil,tp)>=ct and aux.SelectUnselectGroup(tg,e,tp,ct,ct,c2390019.rescon2,0)
			end
end
function c2390019.rescon2(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)>=sg:GetCount()
end
function c2390019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c2390019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetMatchingGroup(c2390019.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and rg:GetCount()>0 and Duel.IsExistingMatchingCard(c2390019.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rg,ft)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,c2390019.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rg,ft):GetFirst()
	Duel.ConfirmCards(1-tp,rc)
	local sg=Duel.GetMatchingGroup(c2390019.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,table.unpack(rc.material))
	local maxc=math.min((Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or 5),rc.material_count)
	local g=aux.SelectUnselectGroup(rg,e,tp,nil,maxc,c2390019.rescon1(sg,ft),1,tp,HINTMSG_REMOVE,c2390019.rescon1(sg,ft))
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local ct=g:GetCount()
	Duel.SetTargetCard(rc)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c2390019.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rc=Duel.GetFirstTarget()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=math.min(ft,1) end
	if not rc or ct>ft then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c2390019.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,nil,e,tp,table.unpack(rc.material))
	local g=aux.SelectUnselectGroup(mg,e,tp,ct,ct,c2390019.rescon2,1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c2390019.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf) and c:IsAbleToDeck()
end
function c2390019.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c2390019.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c2390019.tdfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c2390019.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c2390019.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
