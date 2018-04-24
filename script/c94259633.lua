--サクリファイス・アニマ
--Relinquished Anima
--Scripted by ahtelel
function c94259633.initial_effect(c)
	aux.AddLinkProcedure(c,c94259633.matfilter,1,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(94259633,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,94259633)
	e1:SetCondition(c94259633.eqcon)
	e1:SetTarget(c94259633.eqtg)
	e1:SetOperation(c94259633.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,c94259633.eqcon,function(ec,_,tp) return ec:IsControler(tp,1-tp) end,c94259633.equipop,e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c94259633.adcon)
	e2:SetValue(c94259633.atkval)
	c:RegisterEffect(e2)
end
function c94259633.matfilter(c,lc,sumtype,tp)
	return c:GetLevel()==1 and not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end 
function c94259633.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c94259633.eqfilter,nil)
	return g:GetCount()==0
end
function c94259633.eqfilter(c)
	return c:GetFlagEffect(94259633)~=0 
end
function c94259633.eqfilter2(c,e,tp,lg)
	return c:IsFaceup() and c:IsAbleToChangeControler() and lg:IsContains(c)
end
function c94259633.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c94259633.eqfilter2(chkc,e,tp,lg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c94259633.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c94259633.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lg)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c94259633.equipop(c,e,tp,tc)
	aux.EquipByEffectAndLimitRegister(c,e,tp,tc,94259633)  
end
function c94259633.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() then return end 
	if tc and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) and c94259633.eqcon(e,tp,eg,ep,ev,re,r,rp) then
			c94259633.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c94259633.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c94259633.eqfilter,nil)
	return g:GetCount()>0
end
function c94259633.atkval(e,c)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c94259633.eqfilter,nil)
	local atk=g:GetFirst():GetTextAttack()
	if g:GetFirst():GetOriginalType()&TYPE_MONSTER==0 or atk<0 then
		return 0
	else
		return atk
	end
end
