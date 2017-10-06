--地底のアラクネー
function c100000154.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	aux.AddDarkSynchroProcedure(c,aux.NonTuner(nil),nil,6)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c100000154.aclimit)
	e1:SetCondition(c100000154.actcon)
	c:RegisterEffect(e1)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000154,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100000154.eqcon)
	e3:SetTarget(c100000154.eqtg)
	e3:SetOperation(c100000154.eqop)
	c:RegisterEffect(e3)
	aux.AddEREquipLimit(c,c100000154.eqcon,function(ec,_,tp) return ec:IsControler(1-tp) end,c100000154.equipop,e3)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0x601)
	c:RegisterEffect(e4)
end
function c100000154.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100000154.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c100000154.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c100000154.eqfilter,nil)
	return g:GetCount()==0
end
function c100000154.eqfilter(c)
	return c:GetFlagEffect(100000154)~=0 
end
function c100000154.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100000154.equipop(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,100000154) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
end
function c100000154.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c100000154.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
