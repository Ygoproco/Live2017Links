--TGトライデント・ランチャー
--T.G. Trident Launcher
function c50750868.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,nil,c50750868.lcheck)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50750868,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,50750868)
	e1:SetCondition(c50750868.spcon)
	e1:SetTarget(c50750868.sptg)
	e1:SetOperation(c50750868.spop)
	c:RegisterEffect(e1)
	--cannot be target/battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c50750868.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c50750868.lcheck(g,lc)
	return g:IsExists(c50750868.mzfilter,1,nil)
end
function c50750868.mzfilter(c)
	return c:IsSetCard(0x27) and c:IsType(TYPE_TUNER)
end
function c50750868.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x27) and c:IsType(TYPE_SYNCHRO)
end
function c50750868.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c50750868.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c50750868.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg
end
function c50750868.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		local g=Duel.GetMatchingGroup(c50750868.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,zone)
		return ct>2 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and aux.SelectUnselectGroup(g,e,tp,3,3,c50750868.spcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c50750868.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c50750868.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,zone)
	if sg:GetCount()==0 then return end
	local rg=aux.SelectUnselectGroup(sg,e,tp,3,3,c50750868.spcheck,1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(rg,0,tp,tp,true,false,POS_FACEUP_DEFENSE,zone)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c50750868.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c50750868.splimit(e,c)
	return not c:IsSetCard(0x27)
end

