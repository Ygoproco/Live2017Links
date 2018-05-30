--地底のアラクネー
function c63465535.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),1,1,aux.NonTunerEx(Card.IsRace,RACE_INSECT),1,1)
	c:EnableReviveLimit()
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c63465535.aclimit)
	e1:SetCondition(c63465535.actcon)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63465535,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c63465535.eqcon)
	e2:SetTarget(c63465535.eqtg)
	e2:SetOperation(c63465535.eqop)
	c:RegisterEffect(e2)
	aux.AddEREquipLimit(c,c63465535.eqcon,function(ec,_,tp) return ec:IsControler(1-tp) end,c63465535.equipop,e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c63465535.desreptg)
	e3:SetOperation(c63465535.desrepop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c63465535.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c63465535.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c63465535.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c63465535.eqfilter,nil)
	return g:GetCount()==0
end
function c63465535.eqfilter(c)
	return c:GetFlagEffect(63465535)~=0 
end
function c63465535.filter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c63465535.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c63465535.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c63465535.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c63465535.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c63465535.equipop(c,e,tp,tc)
	aux.EquipByEffectAndLimitRegister(c,e,tp,tc,63465535)
end
function c63465535.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c63465535.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_RULE) end
	end
end
function c63465535.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipGroup():Filter(c63465535.eqfilter,nil):GetFirst()
	if chk==0 then return c:IsReason(REASON_BATTLE) and ec and ec:IsHasCardTarget(c)
		and ec:IsDestructable(e) and not ec:IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c63465535.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipGroup():Filter(c63465535.eqfilter,nil):GetFirst()
	Duel.Destroy(ec,REASON_EFFECT+REASON_REPLACE)
end
