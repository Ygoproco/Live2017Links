--ハイパーサイコライダー
--Hyper Psychic Riser
--Scripted by Eerie Code
function c99115354.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--limit attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTarget(c99115354.atktg)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(c99115354.aclimit)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,99115354)
	e3:SetCondition(c99115354.thcon)
	e3:SetTarget(c99115354.thtg)
	e3:SetOperation(c99115354.thop)
	c:RegisterEffect(e3)
end
function c99115354.atktg(e,c)
	return c:GetAttack()<e:GetHandler():GetAttack()
end
function c99115354.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()>e:GetHandler():GetAttack()
end
function c99115354.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY)
end
function c99115354.thfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function c99115354.thcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetAttribute)==1
		and sg:GetClassCount(Card.GetRace)==1
		and sg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
		and sg:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
end
function c99115354.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c99115354.thfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,c99115354.thcheck,0) end
	local sg=aux.SelectUnselectGroup(g,e,tp,2,2,c99115354.thcheck,1,tp,HINTMSG_ATOHAND)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function c99115354.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

