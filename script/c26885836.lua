--H・C ウォー・ハンマー
function c26885836.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26885836,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCondition(c26885836.eqcon)
	e1:SetTarget(c26885836.eqtg)
	e1:SetOperation(c26885836.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,c26885836.eqconc,function(ec,_,tp) return ec:IsControler(1-tp) end,c26885836.equipop,e1)
end
function c26885836.eqconc(e)
	local g=e:GetHandler():GetEquipGroup():Filter(c26885836.eqfilter,nil)
	return g:GetCount()==0
end
function c26885836.eqfilter(c)
	return c:GetFlagEffect(26885836)~=0 
end
function c26885836.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return aux.bdogcon(e,tp,eg,ep,ev,re,r,rp) and not tc:IsForbidden() 
		and c26885836.eqconc(e)
end
function c26885836.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local tc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c26885836.equipop(c,e,tp,tc)
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,26885836) then return end
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
function c26885836.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		c26885836.equipop(c,e,tp,tc)
	end
end
function c26885836.eqlimit(e,c)
	return e:GetOwner()==c
end
