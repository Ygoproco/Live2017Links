--Z－メタル・キャタピラー
function c64500000.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsCode,62651957,65622692))
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(600)
	c:RegisterEffect(e1)
	--Def up
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
c64500000.listed_names={62651957,65622692}
