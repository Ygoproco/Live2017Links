--ハッピー・マリッジ
function c100000137.initial_effect(c)
	aux.AddEquipProcedure(c,nil,nil,nil,nil,nil,nil,c100000137.con)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c100000137.value)
	c:RegisterEffect(e3)
end
function c100000137.filter(c,tp)
	return c:GetOwner()==1-tp and c:IsFaceup()
end
function c100000137.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c100000137.filter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c100000137.value(e,c)
	local wup=0
	local wg=Duel.GetMatchingGroup(c100000137.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,e:GetHandlerPlayer())
	local wbc=wg:GetFirst()
	while wbc do
		wup=wup+wbc:GetAttack()
		wbc=wg:GetNext()
	end
	return wup
end
