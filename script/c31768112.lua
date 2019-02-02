--オイルメン
function c31768112.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),true,false)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31768112,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c31768112.drcon)
	e1:SetTarget(c31768112.drtg)
	e1:SetOperation(c31768112.drop)
	c:RegisterEffect(e1)
end
function c31768112.drcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsUnionState(e) and e:GetHandler():GetEquipTarget()==eg:GetFirst()
end
function c31768112.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c31768112.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
