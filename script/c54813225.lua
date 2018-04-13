--ダックファイター
function c54813225.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54813225,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,54813225)
	e1:SetCost(c54813225.spcost)
	e1:SetTarget(c54813225.sptg)
	e1:SetOperation(c54813225.spop)
	c:RegisterEffect(e1)
end
function c54813225.spcheck(sg,tp)
	return aux.ReleaseCheckMMZ(sg,tp) and sg:CheckWithSumGreater(Card.GetLevel,3,1,99)
end
function c54813225.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsType,1,false,c54813225.spcheck,nil,TYPE_TOKEN) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsType,1,99,false,c54813225.spcheck,nil,TYPE_TOKEN)
	Duel.Release(g,REASON_COST)
end
function c54813225.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c54813225.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
