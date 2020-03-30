--リターナブル瓶
--Reusable Jar
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.thfilter(c,code)
	return c:IsType(TYPE_TRAP) and not c:IsOriginalCode(code)
end
function s.rmfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,c,c:GetOriginalCode())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return s.thtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return true end
	if s.thcost(e,tp,eg,ep,ev,re,r,rp,0) and s.thtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_TOHAND)
		s.thcost(e,tp,eg,ep,ev,re,r,rp,1)
		s.thtg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(s.thop)
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local tg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(tg,POS_FACEUP,REASON_COST)
	e:SetLabel(tg:GetOriginalCode())
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
		if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
