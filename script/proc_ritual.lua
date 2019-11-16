function Auxiliary.CheckMatFilter(matfilter,e,tp,mg,mg2)
	if matfilter then
		if type(matfilter)=="function" then
			mg:Sub(mg:Filter(aux.NOT(matfilter),nil,e,tp))
			mg2:Sub(mg2:Filter(aux.NOT(matfilter),nil,e,tp))
		else
			local f=function(c)
						return not matfilter:IsContains(c)
					end
			mg:Sub(mg:Filter(f,nil))
			mg2:Sub(mg2:Filter(f,nil))
		end
	end
end
--Ritual Summon
function Auxiliary.CreateRitualProc(c,_type,filter,lv,desc,extrafil,extraop,matfilter,stage2,location,forcedselection)
	--lv can be a function (like GetLevel/GetOriginalLevel), fixed level, if nil it defaults to GetLevel
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1057)
	end
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPTarget(filter,_type,lv,extrafil,extraop,matfilter,stage2,location,forcedselection))
	e1:SetOperation(Auxiliary.RPOperation(filter,_type,lv,extrafil,extraop,matfilter,stage2,location,forcedselection))
	return e1
end
function Auxiliary.AddRitualProc(c,_type,filter,lv,desc,extrafil,extraop,matfilter,stage2,location,forcedselection)
	local e1=aux.CreateRitualProc(c,_type,filter,lv,desc,extrafil,extraop,matfilter,stage2,location,forcedselection)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.RPFilter(c,filter,_type,e,tp,m,m2,forcedselection,lv)
	if not c:IsRitualMonster() or (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2-c)
	if c.ritual_custom_condition then
		return c:ritual_custom_condition(mg,forcedselection,_type)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	end
	if c.ritual_custom_check then
		forcedselection=aux.AND(c.ritual_custom_check,forcedselection or aux.TRUE)
	end
	local sg=Group.CreateGroup()
	local lv=(lv and (type(lv)=="function" and lv()) or lv) or c:GetLevel()
	return Auxiliary.RitualCheck(nil,sg,mg,tp,c,lv,forcedselection,e,_type)
end
function Auxiliary.RPTarget(filter,_type,lv,extrafil,extraop,matfilter,stage2,location,forcedselection)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				location = location or LOCATION_HAND
				if chk==0 then
					local mg=Duel.GetRitualMaterial(tp)
					local mg2=extrafil and extrafil(e,tp,eg,ep,ev,re,r,rp,chk) or Group.CreateGroup()
					Auxiliary.CheckMatFilter(matfilter,e,tp,mg,mg2)
					return Duel.IsExistingMatchingCard(Auxiliary.RPFilter,tp,location,0,1,nil,filter,_type,e,tp,mg,mg2,forcedselection,lv)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,location)
			end
end
function Auxiliary.RitualCheck(c,sg,mg,tp,sc,lv,forcedselection,e,_type)
	if c then
		sg:AddCard(c)
	end
	local res=false
	Duel.SetSelectedCard(sg)
	if _type==RITPROC_EQUAL then
		res=mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,#sg,sc)
	else
		res=mg:CheckWithSumGreater(Card.GetRitualLevel,lv,sc)
	end
	res=(res and Duel.GetMZoneCount(tp,sg,tp)>0 and (not forcedselection or forcedselection(e,tp,sg,sc))) or
			mg:IsExists(Auxiliary.RitualCheck,1,sg,sg,mg,tp,sc,lv,forcedselection,e,_type)
	if c then
		sg:RemoveCard(c)
	end
	return res
end
function Auxiliary.RitualSelectMaterials(sc,mg,forcedselection,lv,tp,e,_type)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(Auxiliary.RitualCheck,sg,sg,mg,tp,sc,lv,forcedselection,e,_type)
		if #cg==0 then break end
		local finish=Auxiliary.RitualCheck(nil,sg,sg,tp,sc,lv,forcedselection,e,_type)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local tc=cg:SelectUnselect(sg,tp,finish,finish,lv)
		if not tc then break end
		if not sg:IsContains(tc) then
			sg:AddCard(tc)
		else
			sg:RemoveCard(tc)
		end
	end
	return sg
end
function Auxiliary.RPOperation(filter,_type,lv,extrafil,extraop,matfilter,stage2,location,forcedselection)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				location = location or LOCATION_HAND
				local mg=Duel.GetRitualMaterial(tp)
				local mg2=extrafil and extrafil(e,tp,eg,ep,ev,re,r,rp) or Group.CreateGroup()
				Auxiliary.CheckMatFilter(matfilter,e,tp,mg,mg2)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=Duel.SelectMatchingCard(tp,Auxiliary.RPFilter,tp,location,0,1,1,nil,filter,_type,e,tp,mg,mg2,forcedselection,lv)
				local tc=tg:GetFirst()
				if tc then
					local mat=nil
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					mg:Merge(mg2-tc)
					if tc.ritual_custom_operation then
						tc:ritual_custom_operation(mg,forcedselection,_type)
						mat=tc:GetMaterial()
					else
						if tc.ritual_custom_check then
							forcedselection=aux.AND(tc.ritual_custom_check,forcedselection or aux.TRUE)
						end
						if tc.mat_filter then
							mg=mg:Filter(tc.mat_filter,tc,tp)
						end
						local lv=(lv and (type(lv)=="function" and lv()) or lv) or tc:GetLevel()
						if ft>0 and not forcedselection and not Auxiliary.RitualExtraCheck then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
							if _type==RITPROC_EQUAL then
								mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,lv,1,#mg,tc)
							else
								mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,lv,tc)
							end
						else
							mat=Auxiliary.RitualSelectMaterials(tc,mg,forcedselection,lv,tp,e,_type)
						end
						tc:SetMaterial(mat)
					end
					if extraop then
						extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
					else
						Duel.ReleaseRitualMaterial(mat)
					end
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
					if stage2 then
						stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
					end
				end
			end
end
--Ritual Summon, geq fixed lv
function Auxiliary.AddRitualProcGreater(c,filter,lv,desc,extrafil,extraop,matfilter,stage2,location,forcedselection)
	return aux.AddRitualProc(c,RITPROC_GREATER,filter,lv,desc,extrafil,extraop,matfilter,stage2,location,forcedselection)
end
function Auxiliary.AddRitualProcCode(c,_type,lv,desc,...)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={...}
	end
	return Auxiliary.AddRitualProc(c,_type,Auxiliary.FilterBoolFunction(Card.IsCode,...),lv,desc)
end
function Auxiliary.AddRitualProcGreaterCode(c,lv,desc,...)
	return Auxiliary.AddRitualProcCode(c,RITPROC_GREATER,lv,desc,...)
end
--Ritual Summon, equal to
function Auxiliary.AddRitualProcEqual(c,filter,lv,desc,extrafil,extraop,matfilter,stage2,location)
	return aux.AddRitualProc(c,RITPROC_EQUAL,filter,lv,desc,extrafil,extraop,matfilter,stage2,location)
end
function Auxiliary.AddRitualProcEqualCode(c,lv,desc,...)
	return Auxiliary.AddRitualProcCode(c,RITPROC_EQUAL,lv,desc,...)
end
