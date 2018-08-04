--セコンド・ゴブリン
function c19086954.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsCode,73698349),true)
	--pos change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19086954,2))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.IsUnionState)
	e1:SetTarget(c19086954.postg)
	e1:SetOperation(c19086954.posop)
	c:RegisterEffect(e1)
end
c19086954.listed_names={73698349}
function c19086954.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler():GetEquipTarget(),1,0,0)
end
function c19086954.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c:GetEquipTarget(),POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
