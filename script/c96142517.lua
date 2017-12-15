--RUM－千死蛮巧
--Rank-Up-Magic Admiration of the Thousands
function c96142517.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c96142517.cost)
	e1:SetTarget(c96142517.target)
	e1:SetOperation(c96142517.activate)
	c:RegisterEffect(e1)
end
function c96142517.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c96142517.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c96142517.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetHandler()~=se:GetHandler()
end
function c96142517.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c96142517.filter2,tp,0,LOCATION_GRAVE,1,nil,e,tp,rk,Group.FromCards(c))
end
function c96142517.filter2(c,e,tp,rk,g1)
	local g=g1:Clone()
	g:AddCard(c)
	return c:IsType(TYPE_XYZ) and c:IsRank(rk) and c:IsCanBeEffectTarget(e) 
		and Duel.IsExistingMatchingCard(c96142517.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rk+1,g)
end
function c96142517.spfilter(c,e,tp,rk,g)
	if c:GetRank()~=rk or (not c:IsSetCard(0x1048) and not c:IsSetCard(0x1073)) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	return not c.rum_limit or g:IsExists(function(mc) return c.rum_limit(mc,e) end,1,nil)
end
function c96142517.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingTarget(c96142517.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c96142517.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local rk=g1:GetFirst():GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c96142517.filter2,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,rk,g1)
	g1:Merge(g2)
	local g=Duel.GetMatchingGroup(c96142517.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,rk,g1)
	g:Sub(g1)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(96142517,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,99,nil)
		Duel.SetTargetCard(sg)
		g1:Merge(sg)
	end
	Duel.SetTargetParam(rk)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c96142517.activate(e,tp,eg,ep,ev,re,r,rp)
	local rk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local mg0=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=mg0:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or mg:GetCount()==0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c96142517.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk+1,mg0)
	local sc=g:GetFirst()
	if sc then
		Duel.Overlay(sc,mg)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
