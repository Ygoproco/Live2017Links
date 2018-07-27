--Contact Gate
--Scripted by Eerie Code
function c41933425.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,41933425+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c41933425.cost)
	e1:SetTarget(c41933425.target)
	e1:SetOperation(c41933425.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c41933425.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c41933425.sptg)
	e2:SetOperation(c41933425.spop)
	c:RegisterEffect(e2)
end
c41933425.listed_names={CARD_NEOS }
function c41933425.cfilter(c)
	return c:IsSetCard(0x1f) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c41933425.filter(c,e,tp)
	return c:IsSetCard(0x1f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c41933425.rescon1(sg,e,tp,mg)
	local g=Duel.GetMatchingGroup(c41933425.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,sg,e,tp)
	return aux.ChkfMMZ(2)(sg,e,tp,mg) and sg:GetClassCount(Card.GetCode)==2 
		and aux.SelectUnselectGroup(g,e,tp,2,2,c41933425.rescon2,0)
end
function c41933425.rescon2(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==2
end
function c41933425.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(c41933425.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,2,c41933425.rescon1,0) end
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,c41933425.rescon1,1,tp,HINTMSG_REMOVE)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c41933425.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c41933425.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c41933425.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c41933425.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c41933425.rescon2,1,tp,HINTMSG_SPSUMMON)
	if #sg==2 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c41933425.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c41933425.spcfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and aux.IsMaterialListCode(c,CARD_NEOS)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c41933425.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c41933425.spcfilter,1,nil,tp)
end
function c41933425.spfilter(c,e,tp)
	return c41933425.filter(c,e,tp) and c:IsFaceup()
end
function c41933425.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c41933425.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,1,nil,tp,LOCATION_REMOVED)
end
function c41933425.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c41933425.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
