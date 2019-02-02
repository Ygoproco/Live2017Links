--Vendread Nightmare
--Scripted by Eerie Code
function c33971095.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--increase lv
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33971095.lvcost)
	e2:SetTarget(c33971095.lvtg)
	e2:SetOperation(c33971095.lvop)
	c:RegisterEffect(e2)
	--increase atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,33971095)
	e3:SetCondition(c33971095.atkcon)
	e3:SetOperation(c33971095.atkop)
	c:RegisterEffect(e3)
end
function c33971095.lvcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x106)
end
function c33971095.lvfilter(c,e)
	return c:IsFaceup() and c:IsLevelAbove(1) and (not e or c:IsCanBeEffectTarget(e))
end
function c33971095.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c33971095.lvfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c33971095.lvcfilter,1,true,aux.ReleaseCheckTarget,nil,tg) end
	local g=Duel.SelectReleaseGroupCost(tp,c33971095.lvcfilter,1,99,true,aux.ReleaseCheckTarget,nil,tg)
	e:SetLabel(#g)
	Duel.Release(g,REASON_COST)
end
function c33971095.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33971095.lvfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33971095.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33971095.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c33971095.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and ((a:GetType()&0x81)==0x81 and a:IsSetCard(0x106)) and a:GetBattleTarget():IsControler(1-tp)
end
function c33971095.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c:IsRelateToEffect(e) and tc:IsRelateToBattle() and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

