--サイバーダーク・インパクト！
function c80033124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c80033124.target)
	e1:SetOperation(c80033124.activate)
	c:RegisterEffect(e1)
end
function c80033124.ffilter(c,e)
	return c:IsFusionCode(41230939,77625948,3019642) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
		and (not e or not c:IsImmuneToEffect(e))
end
function c80033124.spfilter(c,e,tp)
	return c:IsCode(40418351) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c80033124.fcheck(c,sg,g,code,...)
	if not c:IsFusionCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c80033124.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c80033124.rescon(sg,e,tp,mg)
	return Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c80033124.fcheck,1,nil,sg,Group.CreateGroup(),41230939,77625948,3019642)
end
function c80033124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c80033124.ffilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(c80033124.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return false end
		return aux.SelectUnselectGroup(mg,e,tp,3,3,c80033124.rescon,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80033124.cfilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsOnField() and c:IsFacedown())
end
function c80033124.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c80033124.ffilter),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	local sg=aux.SelectUnselectGroup(mg,e,tp,3,3,c80033124.rescon,1,tp,HINTMSG_TODECK)
	if sg:GetCount()<3 then return end
	local cg=sg:Filter(c80033124.cfilter,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
	end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c80033124.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
