
function Auxiliary.TuneMagFilterFus(c,e,f)
	return not f or f(e,c)
end
--material_count: number of different names in material list
--material: names in material list
--Fusion monster, mixed materials
function Auxiliary.AddFusionProcMix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local fun={}
	for _,val in ipairs({...}) do
		table.insert(fun,{val,1,1})
	end
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,table.unpack(fun))
end
--Fusion monster, mixed material * minc to maxc + material + ...
function Auxiliary.AddFusionProcMixRep(c,sub,insf,fun1,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local fun={}
	table.insert(fun,{fun1,minc,maxc})
	for _,val in ipairs({...}) do
		table.insert(fun,{val,1,1})
	end
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,table.unpack(fun))
end
function Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	local mat={}
	local extra={}
	local minc=0
	local maxc=0
	for i=1,#val do
		local f=val[i]
		if type(f[1])=='function' then
			fun[i]={function(c,fc,sub,sub2,mg,sg,tp)
			return (f[1](c,fc,SUMMON_TYPE_FUSION,tp,sub,mg,sg) or (sub2 and c:IsHasEffect(511002961))) and not c:IsHasEffect(6205579) end,f[2], f[3]}
			minc=minc+f[2]
			maxc=maxc+f[3]
		else
			local addmat=true
			fun[i]={function(c,fc,sub,sub2) return c:IsFusionCode(f[1]) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961)) end,f[2], f[3]}
			for index, value in ipairs(mat) do
				if value==f[1] then
					addmat=false
				end
			end
			minc=minc+f[2]
			maxc=maxc+f[3]
			if addmat then table.insert(mat,f[1]) end
		end
	end
	if c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if #mat>0 then
			mt.material_count=#mat
			mt.material=mat
		end
		mt.min_material_count=#{...}
		mt.max_material_count=#{...}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.FConditionMixRepUnfix(insf,sub,minc,maxc,table.unpack(fun)))
	e1:SetOperation(Auxiliary.FOperationMixRepUnfix(insf,sub,minc,maxc,table.unpack(fun)))
	c:RegisterEffect(e1)
	return {e1}
end
function Auxiliary.FConditionMixRepUnfix(insf,sub,minc,maxc,...)
	--g:Material group(nil for Instant Fusion)
	--gc:Material already used
	--chkf: check field, default:PLAYER_NONE
	local funs={...}
	return	function(e,g,gc,chkfnf)
				local mustg=nil
				if g==nil then
					mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,nil,REASON_FUSION)
				return insf and #mustg==0 end
				local chkf=chkfnf&0xff
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=(chkfnf>>8)&0xf~=0
				local contact=(chkfnf>>12)&0xf~=0
				local matcheck=(chkfnf>>16)&0xf==0 and e:GetValue() or 0
				local sub=(sub or notfusion) and not contact
				local mg=g:Filter(Auxiliary.FConditionFilterMixRepUnfix,c,c,sub,sub,contact,matcheck,tp,table.unpack(funs))
				mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_FUSION)
				if contact then mustg:Clear() end
				if not mg:Includes(mustg) or mustg:IsExists(aux.NOT(Card.IsCanBeFusionMaterial),1,nil,c) then return false end
				if gc then
					if gc:IsExists(aux.NOT(Card.IsCanBeFusionMaterial),1,nil,c)
						or gc:IsExists(aux.NOT(Auxiliary.FConditionFilterMixRepUnfix),1,nil,c,sub,sub,contact,matcheck,tp,table.unpack(funs))then return false end
					mustg:Merge(gc)
				end
				local sg=Group.CreateGroup()
				mg:Merge(mustg)
				return mg:IsExists(Auxiliary.FSelectMixRepUnfix,1,nil,tp,mg,sg,mustg,c,sub,sub,contact,minc,maxc,chkf,table.unpack(funs))
			end
end
function Auxiliary.FOperationMixRepUnfix(insf,sub,minc,maxc,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
				local chkf=chkfnf&0xff
				local c=e:GetHandler()
				local tp=c:GetControler()
				local notfusion=(chkfnf>>8)&0xf~=0
				local contact=(chkfnf>>12)&0xf~=0
				local matcheck=(chkfnf>>16)&0xf==0 and e:GetValue() or 0
				local sub=(sub or notfusion) and not contact
				local mg=eg:Filter(Auxiliary.FConditionFilterMixRepUnfix,c,c,sub,sub,contact,matcheck,tp,table.unpack(funs))
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,eg,tp,c,mg,REASON_FUSION)
				if contact then mustg:Clear() end
				local sg=Group.CreateGroup()
				if gc then
					mustg:Merge(gc)
				end
				for tc in aux.Next(mustg) do
					sg:AddCard(tc)
					if not contact and tc:IsHasEffect(73941492+TYPE_FUSION) then
						local eff={gc:GetCardEffect(73941492+TYPE_FUSION)}
						for i=1,#eff do
							local f=eff[i]:GetValue()
							mg=mg:Filter(Auxiliary.TuneMagFilterFus,tc,eff[i],f)
						end
					end
				end
				local p=tp
				local sfhchk=false
				if not contact and Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
					p=1-tp Duel.ConfirmCards(1-tp,mg)
					if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
				end
				while #sg<maxc do
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
					local cg=mg:Filter(Auxiliary.FSelectMixRepUnfix,sg,tp,mg,sg,mustg:Filter(aux.TRUE,sg),c,sub,sub,contact,minc,maxc,chkf,table.unpack(funs))
					if #cg==0 then break end
					local cancel=((sg:IsExists(Auxiliary.FCheckMixRepUnfixSelected,1,nil,tp,sg,sg,mustg,Group.CreateGroup(),c,sub,sub2,contact,chkf,minc,maxc,table.unpack(funs))) or (contact and #sg==0)) and not Auxiliary.FCheckExact
					local tc=Group.SelectUnselect(cg,sg,p,cancel,cancel,minc,maxc)
					if not tc then break end
					if #mustg==0 or not mustg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if sfhchk then Duel.ShuffleHand(tp) end
				Duel.SetFusionMaterial(sg)
			end
end
function Auxiliary.FConditionFilterMixRepUnfix(c,fc,sub,sub,contact,matcheck,tp,...)
	if matcheck~=0 and not matcheck(c,fc,sub,sub2,mg,sg,tp,contact,SUMMON_TYPE_FUSION) then return false end
	if contact then
		if not c:IsCanBeFusionMaterial(fc,tp) then return false end
	else
		if not c:IsCanBeFusionMaterial(fc) then return false end
	end
	for i,f in ipairs({...}) do
		if f[1](c,fc,sub,sub2,mg,sg,tp,contact) then return true end
	end
	return false
end
function Auxiliary.FCheckMixRepUnfixTemplate(c,cond,tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,minc,maxc,...)
	if maxc==0 then return false end
	for i,f in ipairs({...}) do
		if f[1](c,fc,sub,sub2,mg,sg+g,tp,contact) then
			g:AddCard(c)
			local sub=sub and f[1](c,fc,false,sub2,mg,sg+g,tp,contact)
			local t={...}
			local min=f[2]-1
			local max=f[3]-1
			if max>0 then
				t[i]={f[1],min,max}
			else
				table.remove(t,i)
			end
			local mina=minc
			if min>=0 then
				mina=mina-1
			end
			local res=cond(tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,mina,maxc-1,table.unpack(t))
			if not res and min<1 then
				res=cond(tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,mina,maxc-1,table.unpack(t))
			end
			g:RemoveCard(c)
			if res then  return true end
		end
	end
	return false
end
function Auxiliary.FCheckMixRepUnfixSelectedCond(tp,mg,sg,mustg,g,...)
	if #g<#sg then
		return sg:IsExists(Auxiliary.FCheckMixRepUnfixSelected,1,g,tp,mg,sg,mustg,g,...)
	else
		return Auxiliary.FCheckSelectMixRepUnfix(tp,mg,sg,mustg,g,...)
	end
end
function Auxiliary.FCheckMixRepUnfixSelected(c,...)
	return Auxiliary.FCheckMixRepUnfixTemplate(c,Auxiliary.FCheckMixRepUnfixSelectedCond,...)
end
function Auxiliary.FCheckSelectMixRepUnfix(tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,minc,maxc,...)
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,g,fc) then return false end
	if chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 then
		if minc<=0 and g:Includes(mustg) then return true end
		return mg:IsExists(Auxiliary.FCheckSelectMixRepUnfixAll,1,g,tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,minc,maxc,...)
	else
		return mg:IsExists(Auxiliary.FCheckSelectMixRepUnfixM,1,g,tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,minc,maxc,...)
	end
end
function Auxiliary.FCheckSelectMixRepUnfixAll(c,tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,minc,maxc,...)
	if maxc==0 then return false end
	local rg=Group.CreateGroup()
	if not contact then
		if c:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
			for _,fun in ipairs(eff) do
				if (sg+g):IsExists(Auxiliary.TuneMagFilter,1,c,fun,fun:GetValue()) then
					mg:Merge(rg)
					return false
				end
				local sg2=mg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,fun,fun:GetValue()) end,nil)
				rg:Merge(sg2)
				mg:Sub(sg2)
			end
		end
		local g2=(sg+g):Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
		for tc in aux.Next(g2) do
			local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
			for _,fun in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,fun,fun:GetValue()) then
					mg:Merge(rg)
					return false
				end
			end
		end
	end
	for i,f in ipairs({...}) do
		if f[1](c,fc,sub,sub2,mg,sg+g,tp,contact) then
			g:AddCard(c)
			local sub=sub and f[1](c,fc,false,sub2,mg,sg+g,tp,contact)
			local t={...}
			local min=f[2]-1
			local max=f[3]-1
			if max>0 then
				t[i]={f[1],min,max}
			else
				table.remove(t,i)
			end
			local mina=minc
			if min>=0 then
				mina=mina-1
			end
			local res=Auxiliary.FCheckSelectMixRepUnfix(tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,mina,maxc-1,table.unpack(t))
			if not res and min<1 then
				res=Auxiliary.FCheckSelectMixRepUnfix(tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,mina,maxc-1,table.unpack(t))
			end
			g:RemoveCard(c)
			if res then
				mg:Merge(rg)
				return true end
		end
	end
	mg:Merge(rg)
	return false
end
function Auxiliary.FCheckSelectMixRepUnfixM(c,tp,...)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and Auxiliary.FCheckMixRepUnfixTemplate(c,Auxiliary.FCheckSelectMixRepUnfix,tp,...)
end
function Auxiliary.FSelectMixRepUnfix(c,tp,mg,sg,mustg,fc,sub,sub2,contact,minc,maxc,chkf,...)
	if Auxiliary.FCheckExact then
		if Auxiliary.FCheckExact<minc or #mustg>Auxiliary.FCheckExact then return false end
		maxc=Auxiliary.FCheckExact
		minc=Auxiliary.FCheckExact
	end
	local rg=Group.CreateGroup()
	if not contact then
		if c:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
			for _,fun in ipairs(eff) do
				if sg:IsExists(Auxiliary.TuneMagFilter,1,c,fun,fun:GetValue()) then
					mg:Merge(rg)
					return false
				end
				local sg2=mg:Filter(function(c) return not Auxiliary.TuneMagFilterFus(c,fun,fun:GetValue()) end,nil)
				rg:Merge(sg2)
				mg:Sub(sg2)
			end
		end
		local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
		for tc in aux.Next(g2) do
			local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
			for _,fun in ipairs(eff) do
				if Auxiliary.TuneMagFilter(c,fun,fun:GetValue()) then
					mg:Merge(rg)
					return false
				end
			end
		end
	end
	sg:AddCard(c)
	local res=false
	if Auxiliary.FCheckAdditional and not Auxiliary.FCheckAdditional(tp,sg,fc) then
		res=false
	else
		local g=Group.CreateGroup()
		res=sg:IsExists(Auxiliary.FCheckMixRepUnfixSelected,1,nil,tp,mg,sg,mustg,g,fc,sub,sub2,contact,chkf,minc,maxc,...)
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	return res
end
function Auxiliary.AddContactFusion(c,group,op,sumcon,condition,sumtype,desc)
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
	if not desc then
		e1:SetDescription(2)
	else
		e1:SetDescription(desc)
	end
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
		if e:GetValue()~=SUMMON_TYPE_FUSION then
			chkf=chkf+0x10000
		end
		return c:CheckFusionMaterial(m,nil,chkf) and (not fcon or fcon(e:GetHandlerPlayer()))
	end
end
function Auxiliary.ContactTg(f)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local m=f(tp)
		local chkf=tp+0x1000
		if e:GetValue()~=SUMMON_TYPE_FUSION then
			chkf=chkf+0x10000
		end
		local sg=Duel.SelectFusionMaterial(tp,e:GetHandler(),m,nil,chkf)
		if #sg>0 then
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
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code1,1,1},{code2,1,1})
	-- return Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2)
end
--Fusion monster, name + name + name
function Auxiliary.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code1,1,1},{code2,1,1},{code3,1,1})
	-- return Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3)
end
--Fusion monster, name + name + name + name
function Auxiliary.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code1,1,1},{code2,1,1},{code3,1,1},{code4,1,1})
	-- return Auxiliary.AddFusionProcMix(c,sub,insf,code1,code2,code3,code4)
end
--Fusion monster, name * n
function Auxiliary.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code,cc,cc})
	-- local code={}
	-- for i=1,cc do
		-- code[i]=code1
	-- end
	-- return Auxiliary.AddFusionProcMix(c,sub,insf,table.unpack(code))
end
--Fusion monster, name * minc to maxc
function Auxiliary.AddFusionProcCodeRep2(c,code1,minc,maxc,sub,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code,minc,maxc})
	-- return Auxiliary.AddFusionProcMixRep(c,sub,insf,code1,minc,maxc)
end
--Fusion monster, name + condition * n
function Auxiliary.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code1,1,1},{f,cc,cc})
	-- local fun={}
	-- for i=1,cc do
		-- fun[i]=f
	-- end
	-- return Auxiliary.AddFusionProcMix(c,sub,insf,code1,table.unpack(fun))
end
--Fusion monster, condition + condition
function Auxiliary.AddFusionProcFun2(c,f1,f2,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{f1,1,1},{f1,1,1})
	-- return Auxiliary.AddFusionProcMix(c,false,insf,f1,f2)
end
--Fusion monster, condition * n
function Auxiliary.AddFusionProcFunRep(c,f,cc,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{f,cc,cc})
	-- local fun={}
	-- for i=1,cc do
		-- fun[i]=f
	-- end
	-- return Auxiliary.AddFusionProcMix(c,false,insf,table.unpack(fun))
end
--Fusion monster, condition * minc to maxc
function Auxiliary.AddFusionProcFunRep2(c,f,minc,maxc,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{f,minc,maxc})
	-- return Auxiliary.AddFusionProcMixRep(c,false,insf,f,minc,maxc)
end
--Fusion monster, condition1 + condition2 * n
function Auxiliary.AddFusionProcFunFun(c,f1,f2,cc,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{f1,1,1},{f2,cc,cc})
	-- local fun={}
	-- for i=1,cc do
		-- fun[i]=f2
	-- end
	-- return Auxiliary.AddFusionProcMix(c,false,insf,f1,table.unpack(fun))
end
--Fusion monster, condition1 + condition2 * minc to maxc
function Auxiliary.AddFusionProcFunFunRep(c,f1,f2,minc,maxc,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{f1,1,1},{f2,minc,maxc})
	-- return Auxiliary.AddFusionProcMixRep(c,false,insf,f2,minc,maxc,f1)
end
--Fusion monster, name + condition * minc to maxc
function Auxiliary.AddFusionProcCodeFunRep(c,code1,f,minc,maxc,sub,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code1,1,1},{f,minc,maxc})
	-- return Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1)
end
--Fusion monster, name + name + condition * minc to maxc
function Auxiliary.AddFusionProcCode2FunRep(c,code1,code2,f,minc,maxc,sub,insf)
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,{code1,1,1},{code2,1,1},{f,minc,maxc})
	-- return Auxiliary.AddFusionProcMixRep(c,sub,insf,f,minc,maxc,code1,code2)
end
--Fusion monster, any number of name/condition * n - fixed
function Auxiliary.AddFusionProcMixN(c,sub,insf,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local val={...}
	local fun={}
	if #val%2~=0 then return end
	for i=1,#val do
		if i%2~=0 then
			table.insert(fun,{val[i],val[i+1],val[i+1]})
		end
	end
	return Auxiliary.AddFusionProcMixRepUnfix(c,sub,insf,table.unpack(fun))
end
function Auxiliary.FCheckMix(c,mg,sg,fc,sub,sub2,contact,tp,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		if fun1(c,fc,false,sub2,mg,sg,tp,contact) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,sub,sub2,contact,tp,fun2,...)
		elseif sub and fun1(c,fc,true,sub2,mg,sg,tp,contact) then
			res=mg:IsExists(Auxiliary.FCheckMix,1,sg,mg,sg,fc,false,sub2,contact,tp,fun2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		return fun1(c,fc,sub,sub2,mg,sg,tp,contact)
	end
end
function Auxiliary.FConditionFilterMix(c,fc,sub,sub,contact,matcheck,tp,...)
	if matcheck~=0 and not matcheck(c,fc,sub,sub2,mg,sg,tp,contact,SUMMON_TYPE_FUSION) then return false end
	if contact then
		if not c:IsCanBeFusionMaterial(fc,tp) then return false end
	else
		if not c:IsCanBeFusionMaterial(fc) then return false end
	end
	for i,f in ipairs({...}) do
		if f(c,fc,sub,sub2,mg,sg,tp,contact) then return true end
	end
	return false
end
Auxiliary.FCheckExact=nil
Auxiliary.FCheckAdditional=nil

function Auxiliary.FCheckMixGoal(tp,sg,fc,sub,sub2,contact,chkf,...)
	local g=Group.CreateGroup()
	return sg:IsExists(Auxiliary.FCheckMix,1,nil,sg,g,fc,sub,sub2,contact,tp,...) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
		and (not Auxiliary.FCheckAdditional or Auxiliary.FCheckAdditional(tp,sg,fc))
end
--Shaddoll Fusion monster, 1 function + 1 attribute
function Auxiliary.AddShaddollFusionProcMix(c,insf,f,att)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local f1=function(c,fc,sub,sub2,mg,sg,tp,contact) return (f(c,fc,sub,sub2,mg,sg,tp,contact) or c:IsHasEffect(511002961)) and not c:IsHasEffect(6205579) end
	local f2=function(c,fc,sub,sub2,mg,sg,tp,contact) return (c:IsHasEffect(511002961) or c:IsAttribute(att,fc,SUMMON_TYPE_FUSION,tp) or c:IsHasEffect(4904633)) and not c:IsHasEffect(6205579) end
	if c.material_count==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.min_material_count=2
		mt.max_material_count=2
	end
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(Auxiliary.ShaddollFCondition(insf,f1,f2))
	e1:SetOperation(Auxiliary.ShaddollFOperation(insf,f1,f2))
	c:RegisterEffect(e1)
	return {e1}
end
function Auxiliary.ShaddollExFilter(c,g,fc,tp,f1,f2)
	return c:IsFaceup() and c:IsCanBeFusionMaterial(fc) and not g:IsContains(c) 
		and (f1(c,fc,true,true,nil,nil,tp,false) or f2(c,fc,true,true,nil,nil,tp,false))
end
function Auxiliary.ShaddollRecursion(c,tp,mg,sg,exg,mustg,fc,chkf,f1,f2)
	local res
	local rg=Group.CreateGroup()
	if not contact and c:IsHasEffect(73941492+TYPE_FUSION) then
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
	if not contact then
		local g2=sg:Filter(Card.IsHasEffect,nil,73941492+TYPE_FUSION)
		if g2:GetCount()>0 then
			local tc=g2:GetFirst()
			while tc do
				local eff={tc:GetCardEffect(73941492+TYPE_FUSION)}
				for i,f in ipairs(eff) do
					if Auxiliary.TuneMagFilter(c,f,f:GetValue()) then
						mg:Merge(rg)
						return false
					end
				end
				tc=g2:GetNext()
			end
		end
	end
	sg:AddCard(c)
	if sg:GetCount()<2 then
		if exg:IsContains(c) then
			mg:Sub(exg)
			rg:Merge(exg)
		end
		res=mg:IsExists(Auxiliary.ShaddollRecursion,1,sg,tp,mg,sg,exg,mustg,fc,chkf,f1,f2)
	else
		res=sg:Includes(mustg) and Auxiliary.FCheckMixGoal(tp,sg,fc,true,true,false,chkf,f1,f2)
	end
	sg:RemoveCard(c)
	mg:Merge(rg)
	return res
end
function Auxiliary.ShaddollFCondition(insf,f1,f2)
	return	function(e,g,gc,chkf)
				local mustg=nil
				if g==nil then
					if not insf then return false end
					mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,nil,REASON_FUSION)
					return mustg:GetCount()==0 end
				local chkf=chkf&0xff
				local c=e:GetHandler()
				local mg=g:Filter(Auxiliary.FConditionFilterMix,nil,c,true,true,false,0,tp,f1,f2)
				local tp=e:GetHandlerPlayer()
				mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_FUSION)
				if gc then mustg:Merge(gc) end
				local exg=Group.CreateGroup()
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					exg=Duel.GetMatchingGroup(Auxiliary.ShaddollExFilter,tp,0,LOCATION_MZONE,nil,g,c,tp,f1,f2)
					mg:Merge(exg)
				end
				if mustg:GetCount()>2 or (Auxiliary.FCheckExact and Auxiliary.FCheckExact~=2) or not mg:Includes(mustg) or mustg:IsExists(aux.NOT(Card.IsCanBeFusionMaterial),1,nil,c) then return false end
				mg:Merge(mustg)
				return mg:IsExists(Auxiliary.ShaddollRecursion,1,nil,tp,mg,Group.CreateGroup(),exg,mustg,c,chkf,f1,f2)
			end
end
function Auxiliary.ShaddollFilter2(c,tp,mg,sg,exg,mustg,fc,chkf,f1,f2)
	return not exg:IsContains(c) and Auxiliary.ShaddollRecursion(c,tp,mg,sg,exg,mustg,fc,chkf,f1,f2)
end
function Auxiliary.ShaddollFilter3(c,tp,mg,sg,exg,mustg,fc,chkf,f1,f2)
	return exg:IsContains(c) and Auxiliary.ShaddollRecursion(c,tp,mg,sg,exg,mustg,fc,chkf,f1,f2)
end
function Auxiliary.ShaddollFOperation(insf,f1,f2)
	return	function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
				local chkf=chkf&0xff
				local c=e:GetHandler()
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				local tp=e:GetHandlerPlayer()
				local exg=Group.CreateGroup()
				local mg=eg:Filter(Auxiliary.FConditionFilterMix,nil,c,true,true,false,0,tp,f1,f2)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_FUSION)
				if gc then mustg:Merge(gc) end
				local p=tp
				local sfhchk=false
				local urg=Group.CreateGroup()
				if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
					local sg=Duel.GetMatchingGroup(Auxiliary.ShaddollExFilter,tp,0,LOCATION_MZONE,nil,eg,c,tp,f1,f2)
					exg:Merge(sg)
					mg:Merge(sg)
				end
				if mustg:GetCount()>2 or (Auxiliary.FCheckExact and Auxiliary.FCheckExact~=2) or not mg:Includes(mustg) or mustg:IsExists(aux.NOT(Card.IsCanBeFusionMaterial),1,nil,c) then return false end
				if not contact and Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
					p=1-tp
					Duel.ConfirmCards(p,sg)
					if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
				end
				local sg=mustg
				urg:Merge(mustg)
				for tc in aux.Next(mustg) do
					if exg:IsContains(tc) then
						mg:Sub(exg)
						fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
					end
				end
				while sg:GetCount()<2 do
					local tg=mg:Filter(Auxiliary.ShaddollFilter2,sg,tp,mg,sg,exg,mustg,c,chkf,f1,f2)
					local tg2=mg:Filter(Auxiliary.ShaddollFilter3,sg,tp,mg,sg,exg,mustg,c,chkf,f1,f2)
					if tg2:GetCount()>0 then
						tg:AddCard(fc)
					end
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
					local tc=Group.SelectUnselect(tg,sg,p)
					if fc then
						tg:RemoveCard(fc)
					end
					if not tc then break end
					if tc==fc then
						fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
						repeat
							tc=Group.SelectUnselect(tg2,sg,p)
						until not sg:IsContains(tc)
						mg:Sub(exg)
						urg:AddCard(tc)
						sg:AddCard(tc)
					end
					if not urg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if sfhchk then Duel.ShuffleHand(tp) end
				Duel.SetFusionMaterial(sg)
			end
end
