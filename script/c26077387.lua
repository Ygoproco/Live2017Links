--閃刀姫－レイ
--Brandish Maiden Rei
--Script by nekrozar, completed by Eerie Code
function c26077387.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26077387,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,26077387)
	e1:SetCost(c26077387.spcost1)
	e1:SetTarget(c26077387.sptg1)
	e1:SetOperation(c26077387.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26077387,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26077388)
	e2:SetCondition(c26077387.spcon2)
	e2:SetTarget(c26077387.sptg2)
	e2:SetOperation(c26077387.spop2)
	c:RegisterEffect(e2)
end
function c26077387.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c26077387.spfilter1(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26077387.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_FORCE_MZONE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(96)
		Duel.RegisterEffect(e1,tp)
		local res=Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
			and Duel.IsExistingMatchingCard(c26077387.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		e1:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26077387.spop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_FORCE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(96)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c26077387.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	e1:Reset()
end
function c26077387.cfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:GetPreviousTypeOnField()&TYPE_LINK~=0
		and c:IsPreviousSetCard(0x1115) and (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT)))
end
function c26077387.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26077387.cfilter,1,nil,tp,rp)
end
function c26077387.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26077387.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

