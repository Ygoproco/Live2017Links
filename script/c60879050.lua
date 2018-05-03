--機関連結
--Train Connection
function c60879050.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c60879050.filter,c60879050.eqlimit,c60879050.cost)
	--Atk Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c60879050.value)
	c:RegisterEffect(e1)
	--Pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c60879050.ftarget)
	c:RegisterEffect(e3)
end
function c60879050.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60879050.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c60879050.rmfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(10) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function c60879050.rescon(sg,e,tp,mg)
	return Duel.IsExistingTarget(c60879050.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,sg)
end
function c60879050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60879050.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,c60879050.rescon,0) end
	local rg=aux.SelectUnselectGroup(g,e,tp,2,2,c60879050.rescon,1,tp,HINTMSG_REMOVE)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c60879050.value(e,c)
	return c:GetBaseAttack()*2
end
function c60879050.ftarget(e,c)
	return e:GetHandler():GetEquipTarget()~=c
end
