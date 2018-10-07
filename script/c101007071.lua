--NEXT
--Neospace Extension
--Scripted by AlphaKretin
function c101007071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101007071+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101007071.sptg)
	e1:SetOperation(c101007071.spop)
	c:RegisterEffect(e1)
	--act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(c101007071.handcon)
    c:RegisterEffect(e2)
end
c101007071.listed_names={CARD_NEOS}
function c101007071.filter(c,e,tp)
	return (c:IsSetCard(0x1f) or c:IsCode(CARD_NEOS)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101007071.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101007071.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101007071.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(#sg) and sg:GetClassCount(Card.GetCode)==#sg
end
function c101007071.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>5 then ft=5 end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101007071.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local g=aux.SelectUnselectGroup(sg,e,tp,1,ft,c101007071.rescon,1,tp,HINTMSG_SPSUMMON)
	if #g>0 then
		for tc in aux.Next(g) do
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetAbsoluteRange(tp,1,0)
			e3:SetTarget(c101007071.splimit)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
		end
	end
end
function c101007071.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c101007071.handcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
