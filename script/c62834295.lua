--オルフェゴール・アインザッツ
--Orphegel Einsatz
--AlphaKretin
function c62834295.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave or remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62834295,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,62834295)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c62834295.tgcon)
	e2:SetTarget(c62834295.tgtg)
	e2:SetOperation(c62834295.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c62834295.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c62834295.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c62834295.cfilter,1,nil,1-tp)
end
function c62834295.tgfilter(c)
	return (c:IsSetCard(0xfe) or c:IsSetCard(0x11b)) and c:IsType(TYPE_MONSTER) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c62834295.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62834295.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c62834295.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(62834295,1))
	local g=Duel.SelectMatchingCard(tp,c62834295.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectYesNo(tp,aux.Stringid(62834295,2))) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

