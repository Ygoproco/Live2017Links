--真竜機兵ダースメタトロン
function c57761191.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetDescription(aux.Stringid(57761191,0))
	e1:SetCondition(c57761191.ttcon)
	e1:SetOperation(c57761191.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c57761191.setcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    	e3:SetType(EFFECT_TYPE_SINGLE)
    	e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e3:SetDescription(aux.Stringid(57761191,1))
    	e3:SetCondition(c57761191.ttcon2)
    	e3:SetOperation(c57761191.ttop2)
    	e3:SetValue(SUMMON_TYPE_ADVANCE)
    	c:RegisterEffect(e3)
	--tribute check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c57761191.valcheck)
	c:RegisterEffect(e4)
	--immune reg
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(c57761191.regcon)
	e5:SetOperation(c57761191.regop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(57761191,5))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c57761191.spcon)
	e6:SetTarget(c57761191.sptg)
	e6:SetOperation(c57761191.spop)
	c:RegisterEffect(e6)
end
function c57761191.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function c57761191.exfilter(c,g,sc)
	if not c:IsReleasable() or g:IsContains(c) or c:IsHasEffect(EFFECT_EXTRA_RELEASE) then return false end
	local rele=c:GetCardEffect(EFFECT_EXTRA_RELEASE_SUM)
	if rele then
		local remct,ct,flag=rele:GetCountLimit()
		if remct<=0 then return false end
	else return false end
	local sume={c:GetCardEffect(EFFECT_UNRELEASABLE_SUM)}
	for _,te in ipairs(sume) do
		if type(te:GetValue())=='function' then
			if te:GetValue()(te,sc) then return false end
		else return false end
	end
	return true
end
function c57761191.val(c,sc,ma)
	local eff3={c:GetCardEffect(EFFECT_TRIPLE_TRIBUTE)}
	if ma>=3 then
		for _,te in ipairs(eff3) do
			if type(te:GetValue())~='function' or te:GetValue()(te,sc) then return 0x30001 end
		end
	end
	local eff2={c:GetCardEffect(EFFECT_DOUBLE_TRIBUTE)}
	for _,te in ipairs(eff2) do
		if type(te:GetValue())~='function' or te:GetValue()(te,sc) then return 0x20001 end
	end
	return 1
end
function c57761191.req(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsLocation(LOCATION_SZONE)
end
function c57761191.unreq(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function c57761191.rescon(sg,e,tp,mg)
	local c=e:GetHandler()
	if not sg:IsExists(c57761191.req,1,nil) or not aux.ChkfMMZ(1)(sg,e,tp,mg) 
		or sg:FilterCount(c57761191.unreq,nil,tp)>1 then return false end
	local ct=sg:GetCount()
	return sg:CheckWithSumEqual(c57761191.val,3,ct,ct,c,3)
end
function c57761191.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c57761191.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c57761191.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	return minc<=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and aux.SelectUnselectGroup(g,e,tp,1,3,c57761191.rescon,0)
end
function c57761191.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c57761191.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c57761191.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,3,c57761191.rescon,1,tp,HINTMSG_RELEASE,c57761191.rescon)
	local remc=sg:Filter(c57761191.unreq,nil,tp):GetFirst()
	if remc then
		local rele=remc:GetCardEffect(EFFECT_EXTRA_RELEASE_SUM)
		rele:Reset()
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c57761191.ttcon2(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c57761191.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c57761191.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c57761191.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
		typ=typ|tc:GetOriginalType()&0x7
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function c57761191.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c57761191.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabelObject():GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c57761191.efilter)
	e1:SetLabel(typ)
	c:RegisterEffect(e1)
	if typ&TYPE_MONSTER~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(57761191,2))
	end
	if typ&TYPE_SPELL~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(57761191,3))
	end
	if typ&TYPE_TRAP~=0 then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(57761191,4))
	end
end
function c57761191.efilter(e,te)
	return te:IsActiveType(e:GetLabel()) and te:GetOwner()~=e:GetOwner()
end
function c57761191.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((rp==1-tp) or (r&REASON_BATTLE)>0) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c57761191.spfilter(c,e,tp)
	return c:IsAttribute(0xf) and c:IsType(0x802040) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c57761191.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c57761191.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c57761191.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c57761191.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
