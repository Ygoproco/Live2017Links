--真竜騎将ドライアスⅢ世
function c94982447.initial_effect(c)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(94982447,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c94982447.otcon)
	e1:SetOperation(c94982447.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c94982447.spcon)
	e2:SetTarget(c94982447.sptg)
	e2:SetOperation(c94982447.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c94982447.tgtg)
	e3:SetValue(c94982447.indval)
	c:RegisterEffect(e3)
	--indes
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e4)
end
function c94982447.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function c94982447.exfilter(c,g,sc)
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
function c94982447.val(c,sc,ma)
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
function c94982447.req(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsLocation(LOCATION_SZONE)
end
function c94982447.unreq(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function c94982447.rescon(sg,e,tp,mg)
	local c=e:GetHandler()
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then mi=ma end
	if not sg:IsExists(c94982447.req,1,nil) or not aux.ChkfMMZ(1)(sg,e,tp,mg) 
		or sg:FilterCount(c94982447.unreq,nil,tp)>1 then return false end
	local ct=sg:GetCount()
	return sg:CheckWithSumEqual(c94982447.val,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(c94982447.val,ma,ct,ct,c,ma)
end
function c94982447.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c94982447.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c94982447.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-ma and aux.SelectUnselectGroup(g,e,tp,1,ma,c94982447.rescon,0)
end
function c94982447.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c94982447.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c94982447.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then mi=1 end
	local sg=aux.SelectUnselectGroup(g,e,tp,mi,ma,c94982447.rescon,1,tp,HINTMSG_RELEASE,c94982447.rescon)
	local remc=sg:Filter(c94982447.unreq,nil,tp):GetFirst()
	if remc then
		local rele=remc:GetCardEffect(EFFECT_EXTRA_RELEASE_SUM)
		rele:Reset()
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c94982447.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and
		c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c94982447.spfilter(c,e,tp)
	return c:IsSetCard(0xf9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c94982447.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c94982447.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c94982447.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c94982447.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c94982447.tgtg(e,c)
	return c:IsSetCard(0xf9) and c~=e:GetHandler()
end
function c94982447.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
