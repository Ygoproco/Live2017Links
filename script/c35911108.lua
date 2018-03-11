--ランチャー・コマンダー
function c35911108.initial_effect(c)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c35911108.atktg)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35911108,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c35911108.descost)
	e3:SetTarget(c35911108.destg)
	e3:SetOperation(c35911108.desop)
	c:RegisterEffect(e3)
end
function c35911108.atktg(e,c)
	return c:IsRace(RACE_CYBERSE) and c~=e:GetHandler()
end
function c35911108.descfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c35911108.desfilter(c,e)
	return c:IsFaceup() and (not e or c:IsCanBeEffectTarget(e))
end
function c35911108.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(c35911108.desfilter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c35911108.descfilter,1,false,aux.ReleaseCheckTarget,nil,dg) end
	local sg=Duel.SelectReleaseGroupCost(tp,c35911108.descfilter,1,1,false,aux.ReleaseCheckTarget,nil,dg)
	Duel.Release(sg,REASON_COST)
end
function c35911108.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c35911108.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
