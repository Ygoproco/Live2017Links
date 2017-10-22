--Link Summon
function Auxiliary.AddLinkProcedure(c,f,min,max,specialchk,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1076)
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max,specialchk))
	e1:SetTarget(Auxiliary.LinkTarget(f,min,max,specialchk))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max,specialchk))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function Auxiliary.LConditionFilter(c,f,lc,tp)
	return c:IsCanBeLinkMaterial(lc,tp) and (not f or f(c,lc,SUMMON_TYPE_LINK,tp))
end
function Auxiliary.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.LCheckRecursive(c,tp,sg,mg,mustg,lc,ct,minc,maxc,f,specialchk)
	if mustg:GetCount()>maxc then return false end
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.LCheckGoal(tp,sg,mustg,lc,minc,ct,f,specialchk)
		or (ct<maxc and mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,mustg,lc,ct,minc,maxc,f,specialchk))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.LCheckGoal(tp,sg,mustg,lc,minc,ct,f,specialchk)
	return ct>=minc and sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),ct,ct) 
		and (not specialchk or specialchk(sg,lc,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and sg:Includes(mustg)
end
function Auxiliary.LinkCondition(f,minc,maxc,specialchk)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_LINK)
				if mustg:IsExists(aux.NOT(Card.IsCanBeLinkMaterial),1,nil,c,tp) then return false end
				local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				local mg=g:Filter(Auxiliary.LConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				return mg:Includes(mustg) and mg:IsExists(Auxiliary.LCheckRecursive,1,nil,tp,sg,mg,mustg,c,0,minc,maxc,f,specialchk)
			end
end
function Auxiliary.LinkTarget(f,minc,maxc,specialchk)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				local mg=g:Filter(Auxiliary.LConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_LINK)
				local sg=Group.CreateGroup()
				local cancel=false
				sg:Merge(mustg)
				while sg:GetCount()<maxc do
					local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,mustg,c,sg:GetCount(),minc,maxc,f,specialchk)
					if cg:GetCount()==0 then break end
					if sg:GetCount()>=minc and sg:GetCount()<=maxc and Auxiliary.LCheckGoal(tp,sg,mustg,c,minc,sg:GetCount(),f,specialchk) then
						cancel=true
					else
						cancel=false
					end
					local tc=Group.SelectUnselect(cg,sg,tp,cancel,sg:GetCount()==0 or cancel,1,1)
					if not tc then break end
					if mustg:GetCount()==0 or not mustg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if sg:GetCount()>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.LinkOperation(f,min,max,specialchk)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
