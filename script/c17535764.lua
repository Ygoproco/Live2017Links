--ゴキポール
--Gokipole
--Scripted by AlphaKretin
function c17535764.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17535764,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,17535764)
	e1:SetTarget(c17535764.target)
	e1:SetOperation(c17535764.operation)
	c:RegisterEffect(e1)
end
function c17535764.filter(c)
	return c:IsLevel(4) and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function c17535764.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17535764.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17535764.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk)		
end
function c17535764.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17535764.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_NORMAL) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(17535764,1)) then
			local ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local dg=Duel.GetMatchingGroup(c17535764.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
			if ct>0 and #dg>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dc=dg:Select(tp,1,1,nil)
				if #dc>0 then
					Duel.Destroy(dc,REASON_EFFECT)
				end
			end
		end
	end
end
--They see me rollin'
--They hatin'

