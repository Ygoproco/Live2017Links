--銀河眼の煌星竜
--Galaxy-Eyes Sol Flare Dragon
--Scripted by Eerie Code
function c101006042.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_LIGHT),2,2,c101006042.lcheck)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006042,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101006042)
	e1:SetCondition(c101006042.thcon)
	e1:SetTarget(c101006042.thtg)
	e1:SetOperation(c101006042.thop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006042,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101006042+100)
	e2:SetCondition(c101006042.descon)
	e2:SetCost(c101006042.descost)
	e2:SetTarget(c101006042.destg)
	e2:SetOperation(c101006042.desop)
	c:RegisterEffect(e2)
end
c101006042.listed_names={93717133}
function c101006042.lcheck(g,lc)
	return g:IsExists(Card.IsAttackAbove,1,nil,2000)
end
function c101006042.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101006042.thfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x55) or c:IsSetCard(0x7b)) and c:IsAbleToHand()
end
function c101006042.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101006042.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101006042.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c101006042.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function c101006042.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101006042.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()&PHASE_MAIN1+PHASE_MAIN2~=0
end
function c101006042.descfilter(c)
	return c:IsDiscardable() and (c:IsSetCard(0x55) or c:IsSetCard(0x7b))
end
function c101006042.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101006042.descfilter,tp,LOCATION_HAND,0,nil)
	local b1=g:IsExists(Card.IsCode,1,nil,93717133)
	local b2=#g>=2
	if chk==0 then return b1 or b2 end
	local sg=Group.CreateGroup()
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(101006042,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		sg=g:FilterSelect(tp,Card.IsCode,1,1,nil,93717133)
		Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
	else
		Duel.DiscardHand(tp,c101006042.descfilter,1,1,REASON_COST,nil)
	end
end
function c101006042.filter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c101006042.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101006042.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101006042.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101006042.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101006042.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
