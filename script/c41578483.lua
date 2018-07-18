--ミレニアム・アイズ・サクリファイス
--Millennium-Eyes Restrict
function c41578483.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,64631466,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT))
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41578483,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c41578483.eqcon)
	e1:SetTarget(c41578483.eqtg)
	e1:SetOperation(c41578483.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,c41578483.eqval,c41578483.equipop,e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c41578483.atkval)
	c:RegisterEffect(e2)
	-- def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(c41578483.defval)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0x7f,0x7f)
	e4:SetTarget(c41578483.distg)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetOperation(c41578483.disop)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
	--atk limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0x7f,0x7f)
	e6:SetTarget(c41578483.distg)
	c:RegisterEffect(e6)
end
function c41578483.eqval(ec,c,tp)
	return ec:IsControler(1-tp) and ec:IsType(TYPE_EFFECT)
end
function c41578483.eqcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c41578483.eqfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c41578483.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(1-tp) and c41578483.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c41578483.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c41578483.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c41578483.equipop(c,e,tp,tc)
	aux.EquipByEffectAndLimitRegister(c,e,tp,tc,41578483)
end
function c41578483.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c41578483.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_RULE) end
	end
end
function c41578483.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(41578483)~=0 and tc:IsFaceup() and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()
		end
		tc=g:GetNext()
	end
	return atk
end
function c41578483.defval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(41578483)~=0 and tc:IsFaceup() and tc:GetDefense()>=0 then
			atk=atk+tc:GetDefense()
		end
		tc=g:GetNext()
	end
	return atk
end
function c41578483.disfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(41578483)~=0
end
function c41578483.distg(e,c)
	local g=e:GetHandler():GetEquipGroup():Filter(c41578483.disfilter,nil)
	return c:IsFaceup() and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c41578483.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(aux.AND(c41578483.disfilter,Card.IsActiveType),nil,TYPE_MONSTER+TYPE_EFFECT)
	if g and re and g:IsContains(re:GetOwner()) then
		Duel.NegateEffect(ev)
	end
end
