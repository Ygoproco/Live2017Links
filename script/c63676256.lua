--バスター・ショットマン
function c63676256.initial_effect(c)
	aux.AddUnionProcedure(c,nil,true,false)
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(aux.IsUnionState)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(63676256,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c63676256.descon)
	e3:SetTarget(c63676256.destg)
	e3:SetOperation(c63676256.desop)
	c:RegisterEffect(e3)
end
function c63676256.descon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsUnionState(e) and eg:GetCount()==1 and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c63676256.dfilter(c,rac)
	return c:IsFaceup() and c:IsRace(rac)
end
function c63676256.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	local desg=Duel.GetMatchingGroup(c63676256.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetRace())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,desg,desg:GetCount(),0,0)
end
function c63676256.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst():GetBattleTarget()
	local desg=Duel.GetMatchingGroup(c63676256.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetRace())
	Duel.Destroy(desg,REASON_EFFECT)
end
