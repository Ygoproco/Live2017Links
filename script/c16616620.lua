--コンタクト
function c16616620.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c16616620.target)
	e1:SetOperation(c16616620.activate)
	c:RegisterEffect(e1)
end
function c16616620.spfilter(c,g,e,tp)
	return g:IsExists(aux.IsCodeListed,1,nil,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16616620.cfilter(c)
	return c:GetSequence()<5
end
function c16616620.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x1e)
	if chk==0 then return #g>0 and g:FilterCount(Card.IsAbleToGrave,nil)==#g 
		and g:FilterCount(c16616620.cfilter,nil)+Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c16616620.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,g,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c16616620.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x1e)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if #sg==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=Duel.SelectMatchingCard(tp,c16616620.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,sg,e,tp)
		if #spg>0 then
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
