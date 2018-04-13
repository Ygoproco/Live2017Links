--サクリファイス・アニマ
--Relinquished Anima
--Scripted by ahtelel
function c100203028.initial_effect(c)
	aux.AddLinkProcedure(c,c100203028.matfilter,1,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100203028,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100203028)
	e1:SetCondition(c100203028.eqcon)
	e1:SetTarget(c100203028.eqtg)
	e1:SetOperation(c100203028.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,c100203028.eqcon,function(ec,_,tp) return ec:IsControler(tp,1-tp) end,c100203028.equipop,e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c100203028.adcon)
	e2:SetValue(c100203028.atkval)
	c:RegisterEffect(e2)
end
function c100203028.matfilter(c,lc,sumtype,tp)
	return c:GetLevel()==1 and not c:IsType(TYPE_TOKEN,lc,sumtype,tp)
end 
function c100203028.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c100203028.eqfilter,nil)
	return g:GetCount()==0
end
function c100203028.eqfilter(c)
	return c:GetFlagEffect(100203028)~=0 
end
function c100203028.eqfilter2(c,e,tp,lg)
	return c:IsFaceup() and c:IsAbleToChangeControler() and lg:IsContains(c)
end
function c100203028.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100203028.eqfilter2(chkc,e,tp,lg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100203028.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100203028.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lg)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100203028.equipop(c,e,tp,tc)
	aux.EquipByEffectAndLimitRegister(c,e,tp,tc,100203028)  
end
function c100203028.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() then return end 
	if tc and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) and c100203028.eqcon(e,tp,eg,ep,ev,re,r,rp) then
			c100203028.equipop(c,e,tp,tc)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c100203028.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c100203028.eqfilter,nil)
	return g:GetCount()>0
end
function c100203028.atkval(e,c)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c100203028.eqfilter,nil)
	local atk=g:GetFirst():GetTextAttack()
	if g:GetFirst():GetOriginalType()&TYPE_MONSTER==0 or atk<0 then
		return 0
	else
		return atk
	end
end
