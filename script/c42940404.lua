--マシンナーズ・ギアフレーム
function c42940404.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),true,false)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(42940404,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c42940404.stg)
	e1:SetOperation(c42940404.sop)
	c:RegisterEffect(e1)
end
function c42940404.sfilter(c)
	return c:IsSetCard(0x36) and c:GetCode()~=42940404 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c42940404.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c42940404.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c42940404.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c42940404.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
c42940404.listed_names={42940404}
