--魔界の警邏課デスポリス
--Police Patrol of the Underworld
--Scripted by ahtelel
function c100200149.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100200149.regcon)
	e1:SetOperation(c100200149.regop)
	c:RegisterEffect(e1)
end
function c100200149.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100200149.mfilter(c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c100200149.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if c:GetMaterialCount()==2 and g:GetClassCount(Card.GetCode)==g:GetCount() and not g:IsExists(c100200149.mfilter,1,nil) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100200149,0))
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCountLimit(1,100200149)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCost(c100200149.addcost)
		e1:SetTarget(c100200149.addtg)
		e1:SetOperation(c100200149.addop)
		c:RegisterEffect(e1)
	end
end
function c100200149.cfilter(c)
	return Duel.IsExistingTarget(Card.IsCanAddCounter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,0x1049,1)
end
function c100200149.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c100200149.cfilter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,c100200149.cfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function c100200149.addtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100200149,1))
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c100200149.addop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1049,1)
		if tc:GetFlagEffect(100200149)~=0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetTarget(c100200149.reptg)
		e1:SetOperation(c100200149.repop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(100200149,RESET_EVENT+0x1fe0000,0,0)
	end
end
function c100200149.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE) and e:GetHandler():GetCounter(0x1049)>0 end
	return true
end
function c100200149.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():RemoveCounter(tp,0x1049,1,REASON_EFFECT)
end
