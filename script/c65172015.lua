--AtoZ−ドラゴン・バスターキャノン
function c65172015.initial_effect(c)
	c:EnableReviveLimit()
	if not c:IsStatus(STATUS_COPYING_EFFECT) then
		aux.AddContactFusion(c,c65172015.contactfil,c65172015.contactop,aux.FALSE)
		if c.material_count==nil then
			c65172015.material_count=2
			c65172015.material={1561110,91998119}
			c65172015.min_material_count=2
			c65172015.max_material_count=2
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_FUSION_MATERIAL)
		e1:SetCondition(Auxiliary.FConditionMix(true,true,c65172015.ffilter(1561110),c65172015.ffilter(91998119)))
		e1:SetOperation(Auxiliary.FOperationMix(true,true,c65172015.ffilter(1561110),c65172015.ffilter(91998119)))
		c:RegisterEffect(e1)
	end
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65172015,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65172015.discon)
	e2:SetCost(c65172015.discost)
	e2:SetTarget(c65172015.distg)
	e2:SetOperation(c65172015.disop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65172015,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c65172015.sptg)
	e3:SetOperation(c65172015.spop2)
	c:RegisterEffect(e3)
end
function c65172015.ffilter(code)
	return function(c,fc,sub,sub2,mg,sg,tp,contact)
		if contact then
			return c:GetOriginalCode()==code
		else
			return c:IsFusionCode(code) or (sub and c:CheckFusionSubstitute(fc)) or (sub2 and c:IsHasEffect(511002961))
		end
	end
end
function c65172015.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c65172015.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
function c65172015.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c65172015.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65172015.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c65172015.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c65172015.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsCode(1561110) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c65172015.spfilter3,tp,LOCATION_REMOVED,0,1,c,e,tp)
end
function c65172015.spfilter3(c,e,tp)
	return c:IsFaceup() and c:IsCode(91998119) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65172015.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return ft>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingTarget(c65172015.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c65172015.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c65172015.spfilter3,tp,LOCATION_REMOVED,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,tp,LOCATION_REMOVED)
end
function c65172015.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
