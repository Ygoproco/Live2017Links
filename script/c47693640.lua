--ゾンビタイガー
function c47693640.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsCode,10209545),true)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	e3:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e3)
	--Def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(500)
	e4:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e4)
	--handes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47693640,2))
	e5:SetCategory(CATEGORY_HANDES)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetCondition(c47693640.hdcon)
	e5:SetTarget(c47693640.hdtg)
	e5:SetOperation(c47693640.hdop)
	c:RegisterEffect(e5)
end
c47693640.listed_names={10209545}
function c47693640.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsUnionState(e) and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c47693640.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c47693640.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
