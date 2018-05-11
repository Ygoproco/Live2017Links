--鉄のハンス
--Iron Hans
--scripted by Naim
function c100227006.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100227006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100227006)
	e1:SetTarget(c100227006.target)
	e1:SetOperation(c100227006.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Change ATK
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(c100227006.condition)
	e4:SetValue(c100227006.value)
	c:RegisterEffect(e4)
end
c100227006.listed_names={100227010}
function c100227006.fieldcond(c)
	return c:IsFaceup() and c:IsCode(100227010)
end
function c100227006.spfilter(c,e,tp)
	return c:IsCode(100227007) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100227006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100227006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100227006.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(c100227006.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		if not Duel.IsExistingMatchingCard(c100227006.fieldcond,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil,tp) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c100227006.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c100227006.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c100227006.atkfilter(c)
	return c:IsFaceup() and c:IsCode(100227007)
end
function c100227006.value(e,c)
	return Duel.GetMatchingGroupCount(c100227006.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*1000
end
function c100227006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100227006.fieldcond,tp,LOCATION_SZONE,SZONE,1,nil)
end