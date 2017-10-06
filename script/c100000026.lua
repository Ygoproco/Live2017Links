--新生代化石騎士 スカルポーン
function c100000026.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c100000026.min_material_count=2
	c100000026.max_material_count=2
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c100000026.fcon)
	e0:SetOperation(c100000026.fop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100000026.splimit)
	c:RegisterEffect(e1)
end
function c100000026.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and se:GetHandler():IsCode(100000025)
end
function c100000026.filter1(c,tp)
	return (c:IsRace(RACE_ROCK) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)) or c:IsHasEffect(511002961)
end
function c100000026.filter2(c,tp)
	return (c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp)) or c:IsHasEffect(511002961)
end
function c100000026.ffilter(c,fc,tp)
	if not c:IsCanBeFusionMaterial(fc) then return false end
	return c100000026.filter1(c,tp) or c100000026.filter2(c,tp)
end
function c100000026.FCheckGoal(tp,sg,fc)
	local g=Group.CreateGroup()
	return sg:IsExists(c100000026.FCheck,1,nil,tp,sg,g,c100000026.filter1,c100000026.filter2) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0
		and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc))
end
function c100000026.FCheck(c,tp,mg,sg,fun1,fun2)
	if fun2 then
		sg:AddCard(c)
		mg:RemoveCard(c)
		local res=fun1(c,tp) and mg:IsExists(c100000026.FCheck,1,sg,tp,mg,sg,fun2)
		sg:RemoveCard(c)
		mg:AddCard(c)
		return res
	else
		return fun1(c,tp)
	end
end
function c100000026.filterchk(c,tp,mg,sg,fc)
	sg:AddCard(c)
	mg:RemoveCard(c)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if sg:IsExists(aux.TuneMagFilter,1,c,eff[i],f) then
				mg:Merge(rg)
				return false
			end
			local sg2=sg:Filter(function(c) return not aux.TuneMagFilterFus(c,eff[i],f) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	if sg:GetCount()<2 then
		res=mg:IsExists(c100000026.filterchk,1,tp,mg,sg,fc)
	else
		res=c100000026.FCheckGoal(tp,sg,fc)
	end
	sg:RemoveCard(c)
	mg:AddCard(c)
	mg:Merge(rg)
	return res
end
function c100000026.fcon(e,g,gc,chkfnf)
	if g==nil then return true end
	local tp=e:GetHandlerPlayer()
	local mg=g:Filter(c100000026.ffilter,c,c,tp)
	if gc then
		if not mg:IsContains(gc) then return false end
		return c100000026.filterchk(gc,tp,mg,Group.CreateGroup(),fc)
	end
	local sg=Group.CreateGroup()
	return mg:IsExists(c100000026.filterchk,1,nil,tp,mg,sg,c)
end
function c100000026.fop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local tp=e:GetHandlerPlayer()
	local mg=eg:Filter(c100000026.ffilter,c,c,tp)
	local p=tp
	local sfhchk=false
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,mg)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	local sg=Group.CreateGroup()
	if gc then
		sg:AddCard(gc)
		if gc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={gc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				mg=mg:Filter(Auxiliary.TuneMagFilterFus,gc,eff[i],f)
			end
		end
		local tc
		while not tc or tc==gc do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			tc=Group.SelectUnselect(mg:Filter(c100000026.filterchk,sg,tp,mg,sg,c),sg,p)
		end
		sg:AddCard(tc)
	else
		local g1=mg:Filter(c100000026.filter1,nil,tp)
		local g2=mg:Filter(c100000026.filter2,nil,tp)
		::start::
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		sg=g1:FilterSelect(p,c100000026.filterchk,1,1,nil,tp,g2,sg,c)
		local sc=sg:GetFirst()
		if sc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={sc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				g2=g2:Filter(Auxiliary.TuneMagFilterFus,sc,eff[i],f)
			end
		end
		::sec::
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local sc2=Group.SelectUnselect(g2:Filter(c100000026.filterchk,sg,tp,mg,sg,c),sg,p,true,true)
		if not sc2 then goto start end
		if sg:IsContains(sc2) then goto sec end
		sg:AddCard(sc2)
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	if gc then sg:RemoveCard(gc) end
	Duel.SetFusionMaterial(sg)
end
