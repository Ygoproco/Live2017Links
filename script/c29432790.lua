--青き眼の激臨
--Rampage with Eyes of Blue
--Script by dest
function c29432790.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c29432790.cost)
	e1:SetTarget(c29432790.target)
	e1:SetOperation(c29432790.activate)
	c:RegisterEffect(e1)	
	Duel.AddCustomActivityCounter(29432790,ACTIVITY_SUMMON,c29432790.counterfilter)
	Duel.AddCustomActivityCounter(29432790,ACTIVITY_SPSUMMON,c29432790.counterfilter)
end
c29432790.listed_names={CARD_BLUEEYES_W_DRAGON}
function c29432790.counterfilter(c)
	return c:IsCode(CARD_BLUEEYES_W_DRAGON)
end
function c29432790.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(29432790,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(29432790,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c29432790.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c29432790.splimit(e,c)
	return not c:IsCode(CARD_BLUEEYES_W_DRAGON)
end
function c29432790.spfilter(c,e,tp)
	return c:IsCode(CARD_BLUEEYES_W_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29432790.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c29432790.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and #g>0 and Duel.GetMZoneCount(tp,g)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29432790.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if ft>3 then ft=3 end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c29432790.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

