--エーリアン・ベーダー
function c76573247.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76573247,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.seqmovcon)
	e1:SetOperation(aux.seqmovop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c76573247.dircon)
	c:RegisterEffect(e2)
end
function c76573247.dircon(e)
	return e:GetHandler():GetColumnGroup():FilterCount(Card.IsControler,nil,1-e:GetHandlerPlayer())==0
end
