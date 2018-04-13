--クルセイド・パラディオン
--Crusade Palladion
function c101005071.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101005071)
	e1:SetTarget(c101005071.target)
	c:RegisterEffect(e1)
	--cannot select, except link thing
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c101005071.catcondition)
	e2:SetValue(c101005071.catlimit)
	c:RegisterEffect(e2)
end
function c101005071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c101005071.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c101005071.sptarget(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,aux.Stringid(101005071,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		c101005071.spcost(e,tp,eg,ep,ev,re,r,rp,1)
		c101005071.sptarget(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c101005071.spoperation)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c101005071.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c101005071.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x217) or c:IsSetCard(0xfe))
		and Duel.IsExistingMatchingCard(c101005071.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c101005071.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x217) or c:IsSetCard(0xfe)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetOriginalCode()~=tc:GetOriginalCode()
end
function c101005071.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroupCost(tp,c101005071.costfilter,1,false,nil,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroupCost(tp,c101005071.costfilter,1,1,false,nil,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101005071.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101005071.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101005071.catfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x217) and c:IsType(TYPE_LINK)
end
function c101005071.catcondition(e)
	return Duel.IsExistingMatchingCard(c101005071.catfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101005071.catlimit(e,c)
	return not c:IsType(TYPE_LINK)
end
