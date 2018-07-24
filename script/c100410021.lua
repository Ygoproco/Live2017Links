--プランキッズ・バウワウ
--Prankids Bow Wow
--Scripted by AlphaKretin
function c100410021.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x226),2,2)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c100410021.atktg)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100410021,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100410021)
	e2:SetCondition(c100410021.thcon)
	e2:SetCost(c100410021.thcost)
	e2:SetTarget(c100410021.thtg)
	e2:SetOperation(c100410021.thop)
	c:RegisterEffect(e2)
end
function c100410021.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x226)
end
function c100410021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100410021.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100410021.thfilter(c,e)
	return c:IsSetCard(0x226) and not c:IsType(TYPE_LINK) 
		and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c100410021.thcheck(sg,e,tp)
	return sg:GetClassCount(Card.GetCode)==2
end
function c100410021.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c100410021.thfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,c100410021.thcheck,0) end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,c100410021.thcheck,1,tp,HINTMSG_ATOHAND)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function c100410021.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c100410021.indtg)
	e2:SetValue(c100410021.indval)
	Duel.RegisterEffect(e2,tp)
end
function c100410021.indtg(e,c)
	return c:IsSetCard(0x226)
end
function c100410021.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end