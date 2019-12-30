--サイバーダーク・インパクト！
--Cyberdark Impact!
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
function s.ffilter(c,e)
	return c:IsFusionCode(41230939,77625948,3019642) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
		and (not e or not c:IsImmuneToEffect(e))
end
function s.spfilter(c,e,tp,sg)
	return c:IsCode(40418351) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function s.fcheck(c,sg,g,code,...)
	if not c:IsFusionCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(s.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function s.chkfreezone(c,tp,sg)
	return Duel.GetLocationCountFromEx(tp,tp,sg,c)>0
end
function s.rescon(ssg)
	return function(sg,e,tp,mg)
		return sg:IsExists(s.fcheck,1,nil,sg,Group.CreateGroup(),41230939,77625948,3019642) and ssg:IsExists(s.chkfreezone,1,nil,tp,sg)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if chk==0 then
		local ssg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		return aux.SelectUnselectGroup(mg,e,tp,3,3,s.rescon(ssg),0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.cfilter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsOnField() and c:IsFacedown())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ffilter),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	local ssg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(mg,e,tp,3,3,s.rescon(ssg),1,tp,HINTMSG_TODECK)
	if #sg<3 then return end
	local cg=sg:Filter(s.cfilter,nil)
	if #cg>0 then
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
	end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=ssg:FilterSelect(tp,s.chkfreezone,1,1,nil,tp,sg)
	if #g>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
