--機皇創世
function c100000068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c100000068.condition)
	e1:SetCost(c100000068.cost)
	e1:SetTarget(c100000068.target)
	e1:SetOperation(c100000068.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100000068.decon)
	e2:SetTarget(c100000068.destg)
	e2:SetValue(c100000068.desval)
	c:RegisterEffect(e2)
	if not c100000068.global_check then
		c100000068.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c100000068.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100000068.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c100000068.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(63468625)
end
function c100000068.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100000068.filter,tp,0x13,0,1,nil,e,tp)
end
function c100000068.costfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c100000068.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000068.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,100000055)
 		and Duel.IsExistingMatchingCard(c100000068.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,100000066)
		and Duel.IsExistingMatchingCard(c100000068.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,100000067) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOREMOVE)
	local g1=Duel.SelectMatchingCard(tp,c100000068.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,100000055)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c100000068.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,100000066)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c100000068.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,100000067)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c100000068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100000068.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c100000068.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c100000068.filter,tp,0x13,0,1,1,nil,e,tp):GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)==0 then return end
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c100000068.eqlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)		
		c:RegisterEffect(e1)
	end
end
function c100000068.eqlimit(e,c)
	return c:IsCode(63468625)
end
function c100000068.cfilter(c)
	return (c:IsWisel() or c:IsGranel() or c:IsSkiel()) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c100000068.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetHandler():GetEquipTarget())
		and Duel.IsExistingMatchingCard(c100000068.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(100000068,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100000068.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c100000068.desval(e,c)
	return c==e:GetHandler():GetEquipTarget()
end
