--クルセイド・パラディオン
--Crusade Palladion
function c55312487.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x20)
	e1:SetCountLimit(1,55312487+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c55312487.target)
	c:RegisterEffect(e1)
	--cannot select, except link thing
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c55312487.catcondition)
	e2:SetValue(c55312487.catlimit)
	c:RegisterEffect(e2)
end
function c55312487.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c55312487.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c55312487.sptarget(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,aux.Stringid(55312487,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		c55312487.spcost(e,tp,eg,ep,ev,re,r,rp,1)
		c55312487.sptarget(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c55312487.spoperation)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c55312487.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c55312487.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x116) or c:IsSetCard(0xfe))
		and Duel.IsExistingMatchingCard(c55312487.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c55312487.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x116) or c:IsSetCard(0xfe)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetOriginalCode()~=tc:GetOriginalCode()
end
function c55312487.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroupCost(tp,c55312487.costfilter,1,false,nil,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroupCost(tp,c55312487.costfilter,1,1,false,nil,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c55312487.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55312487.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c55312487.catfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x116) and c:IsType(TYPE_LINK)
end
function c55312487.catcondition(e)
	return Duel.IsExistingMatchingCard(c55312487.catfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c55312487.catlimit(e,c)
	return not c:IsType(TYPE_LINK)
end

