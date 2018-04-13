--墓守の末裔
function c30213599.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30213599,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c30213599.cost)
	e1:SetTarget(c30213599.target)
	e1:SetOperation(c30213599.operation)
	c:RegisterEffect(e1)
end
function c30213599.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2e)
end
function c30213599.filter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function c30213599.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c30213599.filter,tp,0,LOCATION_ONFIELD,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c30213599.costfilter,1,false,aux.ReleaseCheckTarget,e:GetHandler(),dg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c30213599.costfilter,1,1,false,aux.ReleaseCheckTarget,e:GetHandler(),dg)
	Duel.Release(sg,REASON_COST)
end
function c30213599.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c30213599.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
