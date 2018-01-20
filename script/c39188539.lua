--ストーム・シューター
function c39188539.initial_effect(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(39188539,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(aux.seqmovcon)
	e1:SetCost(c39188539.cost)
	e1:SetOperation(aux.seqmovop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39188539,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c39188539.cost)
	e2:SetTarget(c39188539.thtg)
	e2:SetOperation(c39188539.thop)
	c:RegisterEffect(e2)
end
function c39188539.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c39188539.filter(c,g)
	return g:IsContains(c) and c:IsAbleToHand()
end
function c39188539.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetColumnGroup()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c39188539.filter(chkc,cg) end
	if chk==0 then return Duel.IsExistingTarget(c39188539.filter,tp,0,LOCATION_ONFIELD,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c39188539.filter,tp,0,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c39188539.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
