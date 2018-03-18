--煉獄の狂宴
function c31548814.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c31548814.cost)
	e1:SetTarget(c31548814.target)
	e1:SetOperation(c31548814.activate)
	c:RegisterEffect(e1)
end
function c31548814.costfilter(c,ft)
	return c:IsSetCard(0xc5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost() 
		and (ft>0 or (c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5))
end
function c31548814.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:CheckWithSumEqual(Card.GetLevel,8,1,ft)
end
function c31548814.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c31548814.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c31548814.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),ft)
	Duel.SendtoGrave(g,REASON_COST)
end
function c31548814.spfilter(c,e,tp)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c31548814.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if e:GetLabel()==0 and ft<=0 then return false end
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(c31548814.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return g:GetCount()>0 and g:CheckWithSumEqual(Card.GetLevel,8,1,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c31548814.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),3)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c31548814.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:CheckWithSumEqual(Card.GetLevel,8,1,ft) then
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,8,1,ft)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
