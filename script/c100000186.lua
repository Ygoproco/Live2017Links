--スフィア・フィールド
function c100000186.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--XYZ
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000186,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100000186.target)
	e2:SetOperation(c100000186.operation)
	c:RegisterEffect(e2)
end
function c100000186.filter(c,e)
	return c:IsType(TYPE_MONSTER) and (not e or not c:IsImmuneToEffect(e))
end
function c100000186.lvfilter(c,g)
	return g:IsExists(aux.FilterEqualFunction(Card.GetLevel,c:GetLevel()),1,c)
end
function c100000186.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c100000186.filter,tp,LOCATION_HAND,0,nil)
		return Duel.GetLocationCountFromEx(tp)>0 and g:IsExists(c100000186.lvfilter,1,nil,g) 
			and Duel.IsExistingMatchingCard(c100000186.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100000186.xyzfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
end
function c100000186.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp)<=0 then return end
	local g=Duel.GetMatchingGroup(c100000186.filter,tp,LOCATION_HAND,0,nil,e)
	local sg=Duel.GetMatchingGroup(c100000186.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if sg:GetCount()>0 and g:IsExists(c100000186.lvfilter,1,nil,g)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg1=g:FilterSelect(tp,c100000186.lvfilter,1,1,nil,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg2=g:FilterSelect(tp,aux.FilterEqualFunction(Card.GetLevel,mg1:GetFirst():GetLevel()),1,1,mg1)
		mg1:Merge(mg2)
		local xyz=sg:RandomSelect(tp,1):GetFirst()
		if Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP) then
			--destroy
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SELF_DESTROY)
			e1:SetCondition(c100000186.descon)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			xyz:RegisterEffect(e1)
			Duel.Overlay(xyz,mg1)
			Duel.SpecialSummonComplete()	
		end
	end
end
function c100000186.descon(e)
	return e:GetHandler():GetOverlayCount()==0 and Duel.GetCurrentChain()==0
end
