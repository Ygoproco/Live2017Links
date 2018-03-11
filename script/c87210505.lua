--騎士の称号
function c87210505.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c87210505.cost)
	e1:SetTarget(c87210505.target)
	e1:SetOperation(c87210505.activate)
	c:RegisterEffect(e1)
end
c87210505.listed_names={46986414,50725996}
function c87210505.costfilter(c,ft,tp)
	return c:IsFaceup() and c:IsCode(46986414) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) and (c:IsFaceup() or c:IsControler(tp))
end
function c87210505.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,c87210505.costfilter,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,c87210505.costfilter,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c87210505.spfilter(c,e,tp)
	return c:IsCode(50725996) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c87210505.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c87210505.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c87210505.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87210505.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
