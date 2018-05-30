--魅惑の女王 LV7
function c50140163.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c50140163.regop)
	c:RegisterEffect(e1)
end
c50140163.lvupcount=1
c50140163.lvup={23756165}
c50140163.lvdncount=2
c50140163.lvdn={23756165,87257460}
function c50140163.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==SUMMON_TYPE_SPECIAL+1 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(50140163,0))
		e1:SetCategory(CATEGORY_EQUIP)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c50140163.eqcon)
		e1:SetTarget(c50140163.eqtg)
		e1:SetOperation(c50140163.eqop)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		e1:SetLabelObject(e)
		c:RegisterEffect(e1)
		aux.AddEREquipLimit(c,c50140163.eqcon,function(ec,_,tp) return ec:IsControler(1-tp) end,c50140163.equipop,e1,nil,RESET_EVENT+0x1ff0000)
	end
end
function c50140163.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c50140163.eqfilter,nil)
	return g:GetCount()==0
end
function c50140163.eqfilter(c)
	return c:GetFlagEffect(50140163)~=0 
end
function c50140163.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c50140163.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,50140163) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(c50140163.repval)
	tc:RegisterEffect(e2)
end
function c50140163.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c50140163.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_RULE) end
	end
end
function c50140163.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
