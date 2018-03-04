--真竜皇バハルストスF
function c82321037.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82321037)
	e1:SetTarget(c82321037.sptg)
	e1:SetOperation(c82321037.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,82321038)
	e2:SetCondition(c82321037.spcon2)
	e2:SetTarget(c82321037.sptg2)
	e2:SetOperation(c82321037.spop2)
	c:RegisterEffect(e2)
end
function c82321037.desfilter(c)
	return c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
end
function c82321037.locfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c82321037.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c82321037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c82321037.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,loc2,c)
	if chk==0 then return ft>-2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=2 and aux.SelectUnselectGroup(g,e,tp,2,2,c82321037.rescon,0) end
	if (g:GetCount()==2 and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==1) or not g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,loc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c82321037.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c82321037.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c82321037.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,loc2,c)
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c82321037.rescon,1,tp,HINTMSG_DESTROY)
	local rm=sg:IsExists(Card.IsAttribute,2,nil,ATTRIBUTE_WATER)
	if Duel.Destroy(sg,REASON_EFFECT)==2 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
			return
		end
		local rg=Duel.GetMatchingGroup(c82321037.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		if rm and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(82321037,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=rg:Select(tp,1,2,nil)
			Duel.HintSelection(tg)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c82321037.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c82321037.thfilter(c,e,tp)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c82321037.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82321037.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c82321037.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82321037.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
