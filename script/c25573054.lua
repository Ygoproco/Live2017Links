--進化する翼
function c25573054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCost(c25573054.cost)
	e1:SetTarget(c25573054.target)
	e1:SetOperation(c25573054.activate)
	c:RegisterEffect(e1)
end
function c25573054.tgfilter(c)
	return c:IsCode(57116033) and c:IsAbleToGraveAsCost()
end
function c25573054.spfilter(c,e,tp)
	return c:IsCode(98585345) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c25573054.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(c25573054.chk,1,nil,sg,e,tp)
end
function c25573054.chk(c,sg,e,tp)
	return c:IsCode(57116033) and c:IsLocation(LOCATION_ONFIELD) and sg:IsExists(Card.IsLocation,2,c,LOCATION_HAND) 
		and Duel.IsExistingMatchingCard(c25573054.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,sg,e,tp)
end
function c25573054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,e:GetHandler())
	local mg=Duel.GetMatchingGroup(c25573054.tgfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local g=hg:Clone()
	g:Merge(mg)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and hg:GetCount()>1 and mg:GetCount()>0 and aux.SelectUnselectGroup(g,e,tp,3,3,c25573054.rescon,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,3,3,c25573054.rescon,1,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c25573054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return true
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c25573054.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c25573054.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c25573054.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
