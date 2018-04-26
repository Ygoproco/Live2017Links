--真竜戦士イグニスH
function c22499034.initial_effect(c)
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22499034,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c22499034.otcon)
	e1:SetOperation(c22499034.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22499034,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c22499034.thcon)
	e2:SetTarget(c22499034.thtg)
	e2:SetOperation(c22499034.thop)
	c:RegisterEffect(e2)
end
function c22499034.otfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsReleasable()
end
function c22499034.exfilter(c,g,sc)
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
function c22499034.val(c,sc,ma)
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
function c22499034.req(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsLocation(LOCATION_SZONE)
end
function c22499034.unreq(c,tp)
	return c:IsControler(1-tp) and not c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsHasEffect(EFFECT_EXTRA_RELEASE_SUM)
end
function c22499034.rescon(sg,e,tp,mg)
	local c=e:GetHandler()
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then mi=ma end
	if not sg:IsExists(c22499034.req,1,nil) or not aux.ChkfMMZ(1)(sg,e,tp,mg) 
		or sg:FilterCount(c22499034.unreq,nil,tp)>1 then return false end
	local ct=sg:GetCount()
	return sg:CheckWithSumEqual(c22499034.val,mi,ct,ct,c,ma) or sg:CheckWithSumEqual(c22499034.val,ma,ct,ct,c,ma)
end
function c22499034.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c22499034.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c22499034.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-ma and aux.SelectUnselectGroup(g,e,tp,1,ma,c22499034.rescon,0)
end
function c22499034.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetTributeGroup(c)
	local exg=Duel.GetMatchingGroup(c22499034.otfilter,tp,LOCATION_SZONE,0,nil)
	g:Merge(exg)
	local opg=Duel.GetMatchingGroup(c22499034.exfilter,tp,0,LOCATION_MZONE,nil,g,c)
	g:Merge(opg)
	local mi,ma=c:GetTributeRequirement()
	if mi<1 then mi=1 end
	local sg=aux.SelectUnselectGroup(g,e,tp,mi,ma,c22499034.rescon,1,tp,HINTMSG_RELEASE,c22499034.rescon)
	local remc=sg:Filter(c22499034.unreq,nil,tp):GetFirst()
	if remc then
		local rele=remc:GetCardEffect(EFFECT_EXTRA_RELEASE_SUM)
		rele:Reset()
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c22499034.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and rp~=tp
end
function c22499034.thfilter(c,tp)
	return c:IsSetCard(0xf9) and c:GetType()==0x20002
		and (c:IsAbleToHand() or (c:GetActivateEffect():IsActivatable(tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0))
end
function c22499034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22499034.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22499034.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22499034,3))
	local g=Duel.SelectMatchingCard(tp,c22499034.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(22499034,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
