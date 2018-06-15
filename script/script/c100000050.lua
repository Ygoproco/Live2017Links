--機皇帝ワイゼル∞
function c100000050.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(c100000050.val)
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
	e3:SetValue(c100000050.effval)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000050,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c100000050.eqtg)
	e4:SetOperation(c100000050.eqop)
	c:RegisterEffect(e4)
	aux.AddEREquipLimit(c,nil,c100000050.eqval,c100000050.equipop,e4)
	--only 1 can exists
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetCondition(c100000050.excon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_SPSUMMON_CONDITION)
	e7:SetValue(c100000050.splimit)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetCondition(c100000050.descon)
	c:RegisterEffect(e8)
	if not c100000050.global_check then
		c100000050.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c100000050.archchk)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100000050.archchk(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,420)==0 then 
		Duel.CreateToken(tp,420)
		Duel.CreateToken(1-tp,420)
		Duel.RegisterFlagEffect(0,420,0,0,0)
	end
end
function c100000050.eqval(ec,c,tp)
	return ec:IsControler(1-tp) and ec:IsType(TYPE_SYNCHRO)
end
function c100000050.filter(c)
	return c:IsFaceup() and (c:IsWisel() or c:IsGranel() or c:IsSkiel())
end
function c100000050.val(e,c)
	local wup=0
	local wg=Duel.GetMatchingGroup(c100000050.filter,c:GetControler(),LOCATION_MZONE,0,c)
	local wbc=wg:GetFirst()
	while wbc do
		wup=wup+wbc:GetAttack()
		wbc=wg:GetNext()
	end
	return wup
end
function c100000050.effval(e,re)
	return re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function c100000050.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function c100000050.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100000050.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100000050.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100000050.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100000050.equipop(c,e,tp,tc)
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
function c100000050.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c100000050.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c100000050.exfilter(c,fid)
	return c:IsFaceup() and c:IsSetCard(0x3013) and (fid==nil or c:GetFieldID()<fid)
end
function c100000050.excon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c100000050.exfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c100000050.splimit(e,se,sp,st,spos,tgp)
	if bit.band(spos,POS_FACEDOWN)~=0 then return true end
	return not Duel.IsExistingMatchingCard(c100000050.exfilter,tgp,LOCATION_ONFIELD,0,1,nil)
end
function c100000050.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c100000050.exfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil,c:GetFieldID())
end
