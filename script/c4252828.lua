--シー・アーチャー
function c4252828.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4252828,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c4252828.eqcon)
	e1:SetTarget(c4252828.eqtg)
	e1:SetOperation(c4252828.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,c4252828.eqcon,c4252828.eqval,c4252828.equipop,e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(c4252828.desreptg)
	e2:SetOperation(c4252828.desrepop)
	c:RegisterEffect(e2)
end
function c4252828.eqval(ec,c,tp)
	return ec:IsControler(tp) and ec:IsLevelBelow(3)
end
function c4252828.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c4252828.eqfilter,nil)
	return g:GetCount()==0
end
function c4252828.eqfilter(c)
	return c:GetFlagEffect(4252828)~=0 
end
function c4252828.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(3)
end
function c4252828.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c4252828.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c4252828.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c4252828.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c4252828.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,4252828) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(800)
	tc:RegisterEffect(e2)
end
function c4252828.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c4252828.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_RULE) end
	end
end
function c4252828.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipGroup():Filter(c4252828.eqfilter,nil):GetFirst()
	if chk==0 then return ec and ec:IsHasCardTarget(c) and ec:IsDestructable(e) and not ec:IsStatus(STATUS_DESTROY_CONFIRMED) 
		and not c:IsReason(REASON_REPLACE) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c4252828.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipGroup():Filter(c4252828.eqfilter,nil):GetFirst()
	Duel.Destroy(ec,REASON_EFFECT+REASON_REPLACE)
end
