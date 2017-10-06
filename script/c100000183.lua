--マタタビ・タービン
function c100000183.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c100000183.filter)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c100000183.vala)
	c:RegisterEffect(e4)
	aux.CallToken(420)
end
function c100000183.filter(c)
	return c:IsCat() or c:IsNeko()
end
function c100000183.vala(e,c)
	return c:GetControler()~=e:GetHandlerPlayer()
end
