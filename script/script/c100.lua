function c100.initial_effect(c)
 ---Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c100.activate)
	c:RegisterEffect(e2)
end
function c100.fil(c,tp)
	return c:GetPreviousControler()~=c:GetOwner() and c:GetPreviousControler()==tp
end
function c100.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(c100.fil,nil,tp)
	local g2=eg:Filter(c100.fil,nil,1-tp)
	if g1:GetCount()>0 then
		Duel.SwapDeckAndGrave(tp)
		Duel.SendtoDeck(g1,tp,0,REASON_EFFECT)
		Duel.SwapDeckAndGrave(tp)
	end
	if g2:GetCount()>0 then
		Duel.SwapDeckAndGrave(1-tp)
		Duel.SendtoDeck(g2,1-tp,0,REASON_EFFECT)
		Duel.SwapDeckAndGrave(1-tp)
	end
end

