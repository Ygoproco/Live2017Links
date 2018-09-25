--E・HERO ブラック・ネオス
function c28677304.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,89943723,43237273)
	aux.AddContactFusion(c,c28677304.contactfil,c28677304.contactop,c28677304.splimit)
	aux.EnableNeosReturn(c)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(28677304,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c28677304.discon)
	e5:SetTarget(c28677304.distg)
	e5:SetOperation(c28677304.disop)
	c:RegisterEffect(e5)
end
c28677304.listed_names={89943723}
c28677304.material_setcode={0x8,0x3008,0x9,0x1f}
function c28677304.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c28677304.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function c28677304.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c28677304.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCardTargetCount()==0
end
function c28677304.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c28677304.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c28677304.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28677304.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c28677304.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c28677304.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c28677304.rcon)
		tc:RegisterEffect(e1,true)
	end
end
function c28677304.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
