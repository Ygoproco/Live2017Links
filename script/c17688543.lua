--深すぎた墓穴
--Excessively Deep Grave
--Script by nekrozar
function c17688543.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c17688543.target)
	e1:SetOperation(c17688543.activate)
	c:RegisterEffect(e1)
end
function c17688543.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c17688543.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c17688543.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c17688543.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c17688543.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c17688543.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local res=(Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp) and 2 or 1
	local turn_asc=(Duel.GetCurrentPhase()<PHASE_STANDBY and Duel.GetTurnPlayer()==tp) and 0 or (Duel.GetTurnPlayer()==tp) and 2 or 1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,res)
	e1:SetLabel(turn_asc+Duel.GetTurnCount())
	e1:SetLabelObject(tc)
	e1:SetCondition(c17688543.spcon)
	e1:SetOperation(c17688543.spop)
	Duel.RegisterEffect(e1,tp)
end
function c17688543.spcon(e,tp)
	return Duel.GetTurnCount()==e:GetLabel() and Duel.GetTurnPlayer()==tp
end
function c17688543.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
