--サイバー・ボンテージ
function c63224564.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,76812113,12206212))
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
c63224564.listed_names={CARD_HARPIE_LADY,CARD_HARPIE_LADY_SISTERS}
