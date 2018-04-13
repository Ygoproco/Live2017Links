--ダブルマジックアームバインド
function c72621670.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c72621670.cost)
	e1:SetTarget(c72621670.target)
	e1:SetOperation(c72621670.activate)
	c:RegisterEffect(e1)
end
function c72621670.chk(sg,tp,exg,dg)
	return dg:IsExists(aux.TRUE,2,sg)
end
function c72621670.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c72621670.filter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,2,false,c72621670.chk,nil,dg) end
	local g=Duel.SelectReleaseGroupCost(tp,nil,2,2,false,c72621670.chk,nil,dg)
	Duel.Release(g,REASON_COST)
end
function c72621670.filter(c,e)
	return c:IsFaceup() and c:IsAbleToChangeControler() and (not e or c:IsCanBeEffectTarget(e))
end
function c72621670.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)>=0
		and Duel.IsExistingTarget(c72621670.filter,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c72621670.filter,tp,0,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c72621670.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c72621670.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c72621670.tfilter,nil,e)
	if g:GetCount()<2 then return end
	local rct=1
	if Duel.GetTurnPlayer()~=tp then rct=2 end
	Duel.GetControl(g,tp,PHASE_END,rct)
end
