--機皇帝グランエル∞
function c100000061.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100000061.spcon)
	e1:SetValue(c100000061.val)
	c:RegisterEffect(e1)
	--defup
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c100000061.efr)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000061,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c100000061.eqtg)
	e4:SetOperation(c100000061.eqop)
	c:RegisterEffect(e4)
	aux.AddEREquipLimit(c,nil,c100000061.eqval,c100000061.equipop,e4)
	--only 1 can exists
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetCondition(c100000061.excon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(c100000061.splimit)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetCondition(c100000061.descon)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(90162951)
	c:RegisterEffect(e9)
end
function c100000061.eqval(ec,c,tp)
	return ec:IsControler(1-tp) and ec:IsType(TYPE_SYNCHRO)
end
function c100000061.spcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetReasonEffect() 
		and c:GetReasonEffect():GetHandler():IsCode(100000067)
end
function c100000061.val(e,c)
	return Duel.GetLP(c:GetControler())/2
end
function c100000061.efr(e,re)
	return re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
function c100000061.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function c100000061.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100000061.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100000061.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100000061.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100000061.equipop(c,e,tp,tc)
	local atk=tc:GetTextAttack()
	if atk<0 then atk=0 end
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc) then return end
	if atk>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function c100000061.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c100000061.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c100000061.exfilter(c,fid)
	return c:IsFaceup() and c:IsSetCard(0x3013) and (fid==nil or c:GetFieldID()<fid)
end
function c100000061.excon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c100000061.exfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c100000061.splimit(e,se,sp,st,spos,tgp)
	if bit.band(spos,POS_FACEDOWN)~=0 then return true end
	return not Duel.IsExistingMatchingCard(c100000061.exfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function c100000061.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c100000061.exfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil,c:GetFieldID())
end
