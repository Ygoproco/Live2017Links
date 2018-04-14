--サイバース・マジシャン
--Cyberse Magician
--Scripted by ahtelel
function c24731391.initial_effect(c)
	c:EnableReviveLimit()
	--halve damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetLabel(tp)
	e1:SetValue(c24731391.val)
	c:RegisterEffect(e1)
	--target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(c24731391.atcon)
	e2:SetValue(c24731391.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c24731391.atcon)
	e3:SetTarget(c24731391.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c24731391.atkcon)
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(24731391,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c24731391.thcon)
	e5:SetTarget(c24731391.thtg)
	e5:SetOperation(c24731391.thop)
	c:RegisterEffect(e5)
end
function c24731391.val(e,re,dam,r,rp,rc)
	if r&REASON_BATTLE>0 and Duel.IsPlayerAffectedByEffect(e:GetLabel(),92481084) then return dam end
	if r&REASON_EFFECT~=0 or r&REASON_BATTLE~=0 then
		return dam/2
	else
		return dam
	end
end
function c24731391.filter(c)
	return c:IsType(TYPE_LINK)
end
function c24731391.atcon(e)
	return Duel.IsExistingMatchingCard(c24731391.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c24731391.atlimit(e,c)
	return c~=e:GetHandler()
end
function c24731391.tglimit(e,c)
	return c~=e:GetHandler()
end
function c24731391.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsType(TYPE_LINK)
end
function c24731391.thfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c24731391.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp~=tp and c:GetPreviousControler()==tp
end
function c24731391.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c24731391.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c24731391.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c24731391.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c24731391.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

