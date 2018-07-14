--百雷のサンダー・ドラゴン
--The Hundred Thunder Dragons
--script by Naim
function c82045034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82045034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c82045034.target)
	e1:SetOperation(c82045034.activate)
	c:RegisterEffect(e1)
end
function c82045034.spfilter(c,e,tp)
	return c:IsRace(RACE_THUNDER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82045034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c82045034.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82045034.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82045034.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c82045034.spfilter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82045034.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sg=Duel.GetMatchingGroup(c82045034.spfilter2,tp,LOCATION_GRAVE,0,nil,code,e,tp)
		if ft<=0 or sg:GetCount()==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(82045034,0)) then
			local g=sg:Select(tp,ft,ft,nil)
			local dg=g:GetFirst()
			while dg do
				Duel.SpecialSummonStep(dg,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(LOCATION_REMOVED)
				e1:SetReset(RESET_EVENT+0x47e0000)
				dg:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetAbsoluteRange(tp,1,0)
				e2:SetTarget(c82045034.splimit)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				dg:RegisterEffect(e2,true)
				dg=g:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c82045034.splimit(e,c)
	return not c:IsRace(RACE_THUNDER)
end
