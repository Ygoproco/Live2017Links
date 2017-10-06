--エアロの爪
function c100000297.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,76812113))
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--tograve replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetTarget(c100000297.reptg)
	e4:SetOperation(c100000297.repop)
	c:RegisterEffect(e4)
end
function c100000297.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eq=e:GetHandler():GetEquipTarget()
	if chk==0 then return eq and c:GetDestination()==LOCATION_GRAVE 
		and Duel.IsExistingMatchingCard(c100000297.filter,tp,LOCATION_MZONE,0,1,eq) end
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c100000297.filter,tp,LOCATION_MZONE,0,1,1,eq)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		return true
	else return false end
end
function c100000297.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Equip(tp,e:GetHandler(),tc)
end
