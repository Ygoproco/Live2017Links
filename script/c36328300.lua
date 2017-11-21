--究極宝玉陣
--Ultimate Crystal Formation
function c36328300.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c36328300.condition)
	e1:SetCost(c36328300.cost)
	e1:SetTarget(c36328300.target)
	e1:SetOperation(c36328300.activate)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c36328300.plcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c36328300.pltg)
	e2:SetOperation(c36328300.plop)
	c:RegisterEffect(e2)
end
function c36328300.confilter(c,tp)
	return c:IsPreviousSetCard(0x1034) and c:GetPreviousControler()==tp
end
function c36328300.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c36328300.confilter,1,nil,tp)
end
function c36328300.cfilter(c)
	return c:IsSetCard(0x1034) and (c:IsFaceup() or not c:IsOnField()) and c:IsAbleToGraveAsCost()
end
function c36328300.exfilter(c,tp)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c))>0
end
function c36328300.rescon(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)>=7 and Duel.GetLocationCountFromEx(tp,tp,sg)>0
end
function c36328300.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local g=Duel.GetMatchingGroup(c36328300.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=7
		and (Duel.GetLocationCountFromEx(tp)>0 or g:IsExists(c36328300.exfilter,1,nil,tp)) end
	local rg=aux.SelectUnselectGroup(g,e,tp,7,7,c36328300.rescon,1,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(rg,REASON_COST)
end
function c36328300.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2034) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c36328300.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCountFromEx(tp)<=0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c36328300.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c36328300.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c36328300.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c36328300.plcfilter(c,tp)
	return c:IsPreviousSetCard(0x2034) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()~=tp
		and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c36328300.plcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c36328300.plcfilter,1,nil,tp)
end
function c36328300.plfilter(c)
	return c:IsSetCard(0x1034) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c36328300.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c36328300.plfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c36328300.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c36328300.plfilter,tp,LOCATION_GRAVE,0,1,ft,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end

