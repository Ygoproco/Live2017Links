--エンドレス・オブ・ザ・ワールド
--Endless of the World
function c32828635.initial_effect(c)
	aux.AddRitualProcGreater(c,c32828635.ritualfil,nil,nil,nil,c32828635.forcedgroup)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32828635,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c32828635.thcon)
	e2:SetCost(c32828635.thcost)
	e2:SetTarget(c32828635.thtg)
	e2:SetOperation(c32828635.thop)
	c:RegisterEffect(e2)
end
c32828635.fit_monster={46427957,72426662}
function c32828635.ritualfil(c)
	return c:IsCode(46427957,72426662) and c:IsRitualMonster()
end
function c16494704.forcedgroup(c,e,tp)
	return c:IsLocation(LOCATION_ONFIELD)
end
function c32828635.thcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function c32828635.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c32828635.filter(c)
	return c:IsCode(8198712) and c:IsAbleToHand()
end
function c32828635.filter2(c)
	return c:IsCode(46427957,72426662) and c:IsAbleToHand()
end
function c32828635.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32828635.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32828635.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32828635.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c32828635.filter2),tp,LOCATION_GRAVE,0,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(32828635,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

