--氷岩魔獣
function c85359414.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsCode,59364406),true)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(85359414,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c85359414.descon)
	e3:SetTarget(c85359414.destg)
	e3:SetOperation(c85359414.desop)
	c:RegisterEffect(e3)
end
c85359414.listed_names={59364406}
function c85359414.descon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsUnionState(e) and ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c85359414.desfilter(c)
	return c:IsFacedown()
end
function c85359414.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c85359414.desfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c85359414.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c85359414.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
