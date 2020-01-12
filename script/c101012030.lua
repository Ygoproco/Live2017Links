--獣神王バルバロス
--Beast Lord Barbaros
--Scripted by AlphaKretin; rework for Lair by senpaizuri
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.listed_series={0x23c}
function s.rescon(sg,tp)
	local lv=sg:GetSum(Card.GetLevel)
	return aux.ChkfMMZ(1)(sg,nil,tp) and lv>=8 and not sg:IsExists(s.rescheck,1,nil,lv)
end
function s.rescheck(c,lv)
	return lv-c:GetLevel()>=8
end
function s.cfilter(c,tp)
	return c:IsReleasable() and c:IsHasLevel() and (c:IsControler(tp) or (c:IsFaceup() and c:IsHasEffect(59160188)))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsHasLevel,1,false,s.rescon,nil) end
	--local rg=Duel.SelectReleaseGroupCost(tp,Card.IsHasLevel,1,99,false,s.rescon,nil)
	--local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	--if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,#g,s.rescon,0) end
	--local rg=aux.SelectUnselectGroup(g,e,tp,1,#g,s.rescon,1,tp,HINTMSG_RELEASE)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,tp)
		local res=g:CheckWithSumGreater(Card.GetLevel,8)
		if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil,tp) then
			for tc in aux.Next(Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE,nil,tp)) do
				g:AddCard(tc)
				res=res or g:CheckWithSumGreater(Card.GetLevel,8)
				g:RemoveCard(tc)
			end
		end
		return res
	end
	local rg=Group.CreateGroup()
	while not rg:CheckWithSumGreater(Card.GetLevel,8) do
		local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		if rg:IsExists(Card.IsControler,1,nil,1-tp) then g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,tp) end
		local mg=g:Filter(Auxiliary.SelectUnselectLoop,rg,rg,g,e,tp,1,99,s.rescon)
		if mg:GetCount()<=0 or rg:GetCount()>=99 then break end
		Duel.Hint(HINT_SELECTMrg,tp,HINTMrg_RELEASE)
		local tc=mg:SelectUnselect(rg,tp)
		if not tc then break end
		if rg:IsContains(tc) then
			rg:RemoveCard(tc)
		else
			rg:AddCard(tc)
		end
	end
	--lair register
	if rg:IsExists(Card.IsControler,1,nil,1-tp) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(59160188,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
	Duel.Release(rg,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.desfilter(c,tp)
	return c:IsSetCard(0x23c) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true,true)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetCards(e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
