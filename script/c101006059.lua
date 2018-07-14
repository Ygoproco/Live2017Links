--オルフェゴール・アインザッツ
--Orphegel Einsatz
--AlphaKretin
function c101006059.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave or remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006059,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101006059)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101006059.tgcon)
	e2:SetTarget(c101006059.tgtg)
	e2:SetOperation(c101006059.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101006059.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c101006059.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101006059.cfilter,1,nil,1-tp)
end
function c101006059.tgfilter(c)
	return (c:IsSetCard(0xfe) or c:IsSetCard(0x225)) and c:IsType(TYPE_MONSTER) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c101006059.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101006059.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c101006059.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101006059,1))
	local g=Duel.SelectMatchingCard(tp,c101006059.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectYesNo(tp,aux.Stringid(101006059,2))) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
