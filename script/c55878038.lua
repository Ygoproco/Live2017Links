--混源龍レヴィオニア
--Levionia the Primordial Chaos Dragon
--Scripted by Eerie Code
function c55878038.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55878038,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(1)
	e1:SetCondition(c55878038.hspcon)
	e1:SetOperation(c55878038.hspop)
	c:RegisterEffect(e1)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c55878038.condition)
	e2:SetCost(c55878038.cost)
	e2:SetTarget(c55878038.target)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c55878038.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg)
end
function c55878038.hspfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c55878038.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c55878038.hspfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,3,3,c55878038.rescon,0)
end
function c55878038.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(c55878038.hspfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	local g=aux.SelectUnselectGroup(rg,e,tp,3,3,c55878038.rescon,1,tp,HINTMSG_REMOVE)
	local lt=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	local dt=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	local lbl=1
	if dt==0 then lbl=ATTRIBUTE_LIGHT 
	elseif lt==0 then lbl=ATTRIBUTE_DARK end
	e:GetLabelObject():SetLabel(lbl)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c55878038.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c55878038.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function c55878038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c55878038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=e:GetLabel()
	if chk==0 then
		if op==0 then return false end
		local res=false
		if op==ATTRIBUTE_LIGHT then
			res=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c55878038.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		elseif op==ATTRIBUTE_DARK then
			res=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)
		else
			res=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0
		end
		if not res then e:SetLabel(0) end
		return res
	end
	if op==0 then
		e:SetCategory(0)
		e:SetOperation(nil)
	elseif op==ATTRIBUTE_LIGHT then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c55878038.spop)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif op==ATTRIBUTE_DARK then
		e:SetCategory(CATEGORY_TODECK)
		e:SetOperation(c55878038.tdop)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(c55878038.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	end
	e:SetLabel(0)
end
function c55878038.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c55878038.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c55878038.tdop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if #hg>0 then
		local sg=hg:RandomSelect(tp,1)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c55878038.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

