--V・HEROウィッチ・レイド
function c82697428.initial_effect(c)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82697428,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c82697428.otcon)
	e1:SetOperation(c82697428.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82697428,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c82697428.descost)
	e2:SetTarget(c82697428.destg)
	e2:SetOperation(c82697428.desop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(82697428,ACTIVITY_SPSUMMON,c82697428.counterfilter)
end
function c82697428.counterfilter(c)
	return c:IsSetCard(0x8)
end
function c82697428.otfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsReleasable()
end
function c82697428.exfilter(c,g,sc)
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
function c82697428.val(c,sc,ma)
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
function c82697428.req(c)
	return c:IsType(TYPE_TRAP) and c:IsLocation(LOCATION_SZONE)
end
function c82697428.unreq(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function c82697428.rescon(sg,e,tp,mg)
	local c=e:GetHandler()
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then mi=ma end
	if not sg:IsExists(c82697428.req,1,nil) or not aux.ChkfMMZ(1)(sg,e,tp,mg) 
		or sg:FilterCount(c82697428.unreq,nil,tp)>1 then return false end
	local ct=sg:GetCount()
	return sg:CheckWithSumEqual(c82697428.val,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(c82697428.val,ma,ct,ct,c,ma)
end
function c82697428.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c82697428.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c82697428.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-ma and aux.SelectUnselectGroup(g,e,tp,1,ma,c82697428.rescon,0)
end
function c82697428.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c82697428.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c82697428.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then mi=1 end
	local sg=aux.SelectUnselectGroup(g,e,tp,mi,ma,c82697428.rescon,1,tp,HINTMSG_RELEASE,c82697428.rescon)
	local remc=sg:Filter(c82697428.unreq,nil,tp):GetFirst()
	if remc then
		local rele=remc:GetCardEffect(EFFECT_EXTRA_RELEASE_SUM)
		rele:Reset()
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c82697428.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(82697428,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c82697428.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c82697428.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x8)
end
function c82697428.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c82697428.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82697428.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c82697428.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82697428.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82697428.desfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
