
function Auxiliary.TuneMagFilterFus(c,e,f)
	return not f or f(e,c)
end
--material_count: number of different names in material list
--material: names in material list
--Fusion monster, mixed materials
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,sub2,mg,sg) return (val[i](c,fc,sub,mg,sg) or (sub2 and c:IsHasEffect(511002961))) and not c:IsHasEffect(6205579) end
		else
			local addmat=true
			fun[i]=function(c,fc,sub,sub2) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961)) end
			for index, value in ipairs(mat) do
				if value==val[i] then
					addmat=false
				end
			end
			if addmat then table.insert(mat,val[i]) end
		end
	end
	if c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if #mat>0 then
			mt.material_count=#mat
			mt.material=mat
		end
		--for cards that check number of required materials (Ultra Poly/ Ancient Gear Chaos Fusion)
		mt.min_material_count=#val
		mt.max_material_count=#val
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMix(insf,sub,table.unpack(fun)))
	e1:SetOperation(Auxiliary.FOperationMix(insf,sub,table.unpack(fun)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMix(insf,sub,...)
	--g:Material group(nil for Instant Fusion)
	--gc:Material already used
	--chkf: check field, default:PLAYER_NONE
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf end
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.band(bit.rshift(chkfnf,8),0xf)~=0
				local contact=bit.rshift(chkfnf,12)~=0
				local sub=(sub or notfusion) and not contact
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,sub,contact,table.unpack(funs))
				if gc then
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMix(gc,tp,mg,sg,c,sub,sub,chkf,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMix,1,nil,tp,mg,sg,c,sub,sub,chkf,table.unpack(funs))
			end
end
function Auxiliary.FOperationMix(insf,sub,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.band(bit.rshift(chkfnf,8),0xf)~=0
				local contact=bit.rshift(chkfnf,12)~=0
				local sub=(sub or notfusion) and not contact
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,sub,contact,table.unpack(funs))
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
				end
				local p=tp
				local sfhchk=false
				if not contact and Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
					p=1-tp Duel.ConfirmCards(1-tp,mg)
					if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
				end
				while sg:GetCount()<#funs do
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
					local tc=Group.SelectUnselect(mg:Filter(Auxiliary.FSelectMix,sg,tp,mg,sg,c,sub,sub,chkf,table.unpack(funs)),sg,p,false,contact and sg:GetCount()==0,#funs,#funs)
					if not tc then break end
					if not gc or (gc and tc~=gc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if sfhchk then Duel.ShuffleHand(tp) end
				if gc then sg:RemoveCard(gc) end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FConditionFilterMix(c,fc,sub,sub,contact,...)
	if not c:IsCanBeFusionMaterial(fc) then return false end
	for i,f in ipairs({...}) do
		if f(c,fc,sub,sub2,mg,sg) then return true end
	end
	return false
end
function Auxiliary.FCheckMix(c,mg,sg,fc,sub,sub2,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		if fun1(c,fc,false,sub2,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,sub,sub2,fun2,...)
		elseif sub and fun1(c,fc,true,sub2,mg,sg) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,false,sub2,fun2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		return fun1(c,fc,sub,sub2,mg,sg)
	end
end
Auxiliary.FCheckAdditional=nil
--if sg1 is subset of sg2 then not Auxiliary.FCheckAdditional(tp,sg1,fc) -> not Auxiliary.FCheckAdditional(tp,sg2,fc)
function Auxiliary.FCheckMixGoal(tp,sg,fc,sub,sub2,chkf,...)
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMix,1,nil,sg,g,fc,sub,sub2,...) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
function Auxiliary.FSelectMix(c,tp,mg,sg,fc,sub,sub2,chkf,...)
	local res
	local rg=Group.CreateGroup()
	--c has the fusion limit
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then
				mg:Merge(rg)
				return false
			end
			local sg2=mg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	--A card in the selected group has the fusion lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
	for tc in aux.Next(g2) do
		local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
		for i,f in ipairs(eff) do
			if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then
				mg:Merge(rg)
				return false
			end
		end
	end
	sg:AddCard(c)
	if sg:GetCount()<#{...} then
		res=mg:IsExists(Auxiliary.FSelectMix,1,sg,tp,mg,sg,fc,sub,sub2,chkf,...)
	else
		res=Auxiliary.FCheckMixGoal(tp,sg,fc,sub,sub2,chkf,...)
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	return res
end
--Fusion monster, mixed material * minc to maxc + material + ...
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={fun1,...}
	local fun={}
	local mat={}
	for i=1,#val do
		if type(val[i])=='function' then
			fun[i]=function(c,fc,sub,sub2,mg,sg) return (val[i](c,fc,sub,mg,sg) or (sub2 and c:IsHasEffect(511002961))) and not c:IsHasEffect(6205579) end
		else
			local addmat=true
			fun[i]=function(c,fc,sub,sub2) return c:IsFusionCode(val[i]) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961)) end
			for index, value in ipairs(mat) do
				if value==val[i] then
					addmat=false
				end
			end
			if addmat then table.insert(mat,val[i]) end
		end
	end
	if c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if #mat>0 then
			mt.material_count=#mat
			mt.material=mat
		end
		mt.min_material_count=minc+#{...}
		mt.max_material_count=maxc+#{...}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	e1:SetOperation(Auxiliary.FOperationMixRep(insf,sub,fun[1],minc,maxc,table.unpack(fun,2)))
	c:RegisterEffect(e1)
end
function Auxiliary.FConditionMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,g,gc,chkfnf)
				if g==nil then return insf end
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.band(bit.rshift(chkfnf,8),0xf)~=0
				local contact=bit.rshift(chkfnf,12)~=0
				local sub=(sub or notfusion) and not contact
				local mg=g:Filter(Auxiliary.FConditionFilterMix,c,c,sub,sub,contact,fun1,table.unpack(funs))
				if gc then
					local sg=Group.CreateGroup()
					return Auxiliary.FSelectMixRep(gc,tp,mg,sg,c,sub,sub,chkf,fun1,minc,maxc,table.unpack(funs))
				end
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.FSelectMixRep,1,nil,tp,mg,sg,c,sub,sub,chkf,fun1,minc,maxc,table.unpack(funs))
			end
end
function Auxiliary.FOperationMixRep(insf,sub,fun1,minc,maxc,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local chkf=bit.band(chkfnf,0xff)
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=bit.band(bit.rshift(chkfnf,8),0xf)~=0
				local contact=bit.rshift(chkfnf,12)~=0
				local sub=(sub or notfusion) and not contact
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,c,c,sub,sub,contact,fun1,table.unpack(funs))
				local sg=Group.CreateGroup()
				if gc then sg:AddCard(gc) end
				local p=tp
				local sfhchk=false
				if not contact and Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
					p=1-tp Duel.ConfirmCards(1-tp,mg)
					if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
				end
				while sg:GetCount()<maxc+#funs do
					local cg=mg:Filter(Auxiliary.FSelectMixRep,sg,tp,mg,sg,c,sub,sub,chkf,fun1,minc,maxc,table.unpack(funs))
					if cg:GetCount()==0 then break end
					local cancel=Auxiliary.FCheckMixRepGoal(tp,sg,c,sub,sub,chkf,fun1,minc,maxc,table.unpack(funs)) or (contact and sg:GetCount()==0)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					local tc=Group.SelectUnselect(cg,sg,p,cancel,cancel)
					if not tc then break end
					if not gc or (gc and tc~=gc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if sfhchk then Duel.ShuffleHand(tp) end
				if gc then sg:RemoveCard(gc) end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FCheckMixRep(sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		return sg:IsExists(Auxiliary.FCheckMixRepFilter,1,g,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,fun2,...)
	else
		local ct1=sg:FilterCount(fun1,g,fc,sub,sub2,mg,sg)
		local ct2=sg:FilterCount(fun1,g,fc,false,sub2,mg,sg)
		return ct1==sg:GetCount()-g:GetCount() and ct1-ct2<=1
	end
end
function Auxiliary.FCheckMixRepFilter(c,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,fun2,...)
	if fun2(c,fc,sub,sub2,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun2(c,fc,false,sub2,mg,sg)
		local res=Auxiliary.FCheckMixRep(sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,...)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,sub2,chkf,fun1,minc,maxc,...)
	if sg:GetCount()<minc+#{...} or sg:GetCount()>maxc+#{...} then return false end
	local g=Group.CreateGroup()
	return Auxiliary.FCheckMixRep(sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,...) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
function Auxiliary.FCheckMixRepTemplate(c,cond,tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,...)
	for i,f in ipairs({...}) do
		if f(c,fc,sub,sub2,mg,sg) then
			g:AddCard(c)
			local sub=sub and f(c,fc,false,sub2,mg,sg)
			local t={...}
			table.remove(t,i)
			local res=cond(tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,table.unpack(t))
			g:RemoveCard(c)
			if res then return true end
		end
	end
	if maxc>0 then
		if fun1(c,fc,sub,sub2,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun1(c,fc,false,sub2,mg,sg)
			local res=cond(tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc-1,maxc-1,...)
			g:RemoveCard(c)
			if res then return true end
		end
	end
	return false
end
function Auxiliary.FCheckMixRepSelectedCond(tp,mg,sg,g,...)
	if g:GetCount()<sg:GetCount() then
		return sg:IsExists(Auxiliary.FCheckMixRepSelected,1,g,tp,mg,sg,g,...)
	else
		return Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,...)
	end
end
function Auxiliary.FCheckMixRepSelected(c,...)
	return Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckMixRepSelectedCond,...)
end
function Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,...)
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,fc) then return false end
	if chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 then
		if minc<=0 and #{...}==0 then return true end
		return mg:IsExists(Auxiliary.FCheckSelectMixRepAll,1,g,tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,...)
	else
		return mg:IsExists(Auxiliary.FCheckSelectMixRepM,1,g,tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,...)
	end
end
function Auxiliary.FCheckSelectMixRepAll(c,tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,fun2,...)
	if fun2 then
		if fun2(c,fc,sub,sub2,mg,sg) then
			g:AddCard(c)
			local sub=sub and fun2(c,fc,false,sub2,mg,sg)
			local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc,maxc,...)
			g:RemoveCard(c)
			return res
		end
	elseif maxc>0 and fun1(c,fc,sub,sub2,mg,sg) then
		g:AddCard(c)
		local sub=sub and fun1(c,fc,false,sub2,mg,sg)
		local res=Auxiliary.FCheckSelectMixRep(tp,mg,sg,g,fc,sub,sub2,chkf,fun1,minc-1,maxc-1)
		g:RemoveCard(c)
		return res
	end
	return false
end
function Auxiliary.FCheckSelectMixRepM(c,tp,...)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and Auxiliary.FCheckMixRepTemplate(c,Auxiliary.FCheckSelectMixRep,tp,...)
end
function Auxiliary.FSelectMixRep(c,tp,mg,sg,fc,sub,sub2,chkf,...)
	local rg=Group.CreateGroup()
	--c has the fusion limit
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i,f in ipairs(eff) do
			if sg:IsExists(Auxiliary.TuneMagFilter,1,c,f,f:GetValue()) then
				mg:Merge(rg)
				return false
			end
			local sg2=mg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,f,f:GetValue()) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	--A card in the selected group has the fusion lmit
	local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
	for tc in aux.Next(g2) do
		local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
		for i,f in ipairs(eff) do
			if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then
				mg:Merge(rg)
				return false
			end
		end
	end
	sg:AddCard(c)
	local res=false
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then
		res=false
	elseif Auxiliary.FCheckMixRepGoal(tp,sg,fc,sub,sub2,chkf,...) then
		res=true
	else
		local g=Group.CreateGroup()
		res=sg:IsExists(Auxiliary.FCheckMixRepSelected,1,nil,tp,mg,sg,g,fc,sub,sub2,chkf,...)
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	return res
end
function Auxiliary.AddContactFusion(c,group,op,sumcon,condition,sumtype)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local t={}
	if mt.contactfus then
		t=mt.contactfus
	end
	t[c]=true
	mt.contactfus=t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if sumtype then
		e1:SetValue(sumtype)
	end
	e1:SetCondition(Auxiliary.ContactCon(group,condition))
	e1:SetTarget(Auxiliary.ContactTg(group))
	e1:SetOperation(Auxiliary.ContactOp(op))
	c:RegisterEffect(e1)
	if sumcon then
		--spsummon condition
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EFFECT_SPSUMMON_CONDITION)
		if type(sumcon)=='function' then
			e2:SetValue(sumcon)
		end
		c:RegisterEffect(e2)
	end
end
function Auxiliary.ContactCon(f,fcon)
	return function(e,c)
		if c==nil then return true end
		local m=f(e:GetHandlerPlayer())
		local chkf=c:GetControler()+0x1000
		return c:CheckFusionMaterial(m,nil,chkf) and (not fcon or fcon(e:GetHandlerPlayer()))
	end
end
function Auxiliary.ContactTg(f)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local m=f(tp)
		local chkf=tp+0x1000
		local sg=Duel.SelectFusionMaterial(tp,e:GetHandler(),m,nil,chkf)
		if sg:GetCount()>0 then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
function Auxiliary.ContactOp(f)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		f(g,tp,c)
		g:DeleteGroup()
	end
end
--Fusion monster, name + name
function Auxiliary.AddFusionProcCode2(c,code1,code2,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2)
end
--Fusion monster, name + name + name
function Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3)
end
--Fusion monster, name + name + name + name
function Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3,code4)
end
--Fusion monster, name * n
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	local code={}
	for i=1,cc do
		code[i]=code1
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(code))
end
--Fusion monster, name * minc to maxc
function Auxiliary.AddFusionProcCodeRep2(c,code1,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,code1,minc,maxc)
end
--Fusion monster, name + condition * n
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,code1,table.unpack(fun))
end
--Fusion monster, condition + condition
function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
	Auxiliary.AddFusionProcMix(c,false,insf,f1,f2)
end
--Fusion monster, condition * n
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f
	end
	Auxiliary.AddFusionProcMix(c,false,insf,table.unpack(fun))
end
--Fusion monster, condition * minc to maxc
function Auxiliary.AddFusionProcFunRep2(c,f,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f,minc,maxc)
end
--Fusion monster, condition1 + condition2 * n
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
	local fun={}
	for i=1,cc do
		fun[i]=f2
	end
	Auxiliary.AddFusionProcMix(c,false,insf,f1,table.unpack(fun))
end
--Fusion monster, condition1 + condition2 * minc to maxc
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	Auxiliary.AddFusionProcMixRep(c,false,insf,f2,minc,maxc,f1)
end
--Fusion monster, name + condition * minc to maxc
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1)
end
--Fusion monster, name + name + condition * minc to maxc
function Auxiliary.AddFusionProcCode2FunRep(c,code1,code2,f,minc,maxc,sub,insf)
	Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1,code2)
end
--Fusion monster, any number of name/condition * n - fixed
function Auxiliary.AddFusionProcMixN(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local t={}
	local n={}
	if #val%2~=0 then return end
	for i=1,#val do
		if i%2~=0 then
			table.insert(t,val[i])
		else
			table.insert(n,val[i])
		end
	end
	if #t~=#n then return end
	local fun={}
	for i=1,#t do
		for j=1,n[i] do
			table.insert(fun,t[i])
		end
	end
	Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(fun))
end
