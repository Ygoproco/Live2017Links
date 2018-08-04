--ドイツ
function c57062206.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsCode,60246171),true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(2500)
	e1:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e1)
end
c57062206.listed_names={60246171}
