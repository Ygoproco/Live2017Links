--Kai-Den Kendo Spirit
--Scripted by Eerie Code
function c101004000.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c101004000.thcon)
	e1:SetTarget(c101004000.thtg)
	e1:SetOperation(c101004000.thop)
	c:RegisterEffect(e1)
	--gy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c101004000.gytg)
	e2:SetOperation(c101004000.gyop)
	c:RegisterEffect(e2)
end
function c101004000.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)
end
function c101004000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101004000.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
function c101004000.gyfilter(c,tp)
	return c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp)
end
function c101004000.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101004000.gyfilter,tp,LOCATION_PZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c101004000.gyop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetMatchingGroup(c101004000.gyfilter,tp,LOCATION_PZONE,0,nil,tp)
	if #pg==0 then return end
	local pc=nil
	if #pg>1 then
		pc=pg:Select(tp,1,1,nil)
	else
		pc=pg:GetFirst()
	end
	Duel.HintSelection(1-tp,Group.FromCards(pc))
	local g=pc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
