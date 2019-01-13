--No.93 希望皇ホープ・カイザー
function c23187256.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c23187256.xyzfilter,nil,2,nil,nil,99,nil,false,c23187256.xyzcheck)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23187256,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c23187256.target)
	e1:SetOperation(c23187256.operation)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c23187256.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end
c23187256.xyz_number=93
function c23187256.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsSetCard(0x48) and c:GetOverlayCount()>0
end
function c23187256.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetRank)==1
end
function c23187256.check(c,rk)
	return c:GetRank()~=rk and not c:IsHasEffect(511001175)
end
function c23187256.filter(c,e,tp)
	return c:IsRankBelow(9) and c:IsAttackBelow(3000) and c:IsSetCard(0x48)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23187256.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c23187256.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c23187256.gfilter(c,rank)
	return c:GetRank()==rank
end
function c23187256.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect~=nil then ft=math.min(ft,ect) end
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c23187256.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local ct=c:GetOverlayGroup():GetClassCount(Card.GetCode)
	if ct>ft then ct=ft end
	if g1:GetCount()>0 and ct>0 then
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=g1:Select(tp,1,1,nil)
			local tc=g2:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			g1:Remove(c23187256.gfilter,nil,tc:GetRank())
			ct=ct-1
		until g1:GetCount()==0 or ct==0 or not Duel.SelectYesNo(tp,aux.Stringid(23187256,1))
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c23187256.dcon)
	e3:SetOperation(c23187256.dop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
end
function c23187256.dcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c23187256.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.HalfBattleDamage(ep)
end
function c23187256.indfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48)
end
function c23187256.indcon(e)
	return Duel.IsExistingMatchingCard(c23187256.indfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
