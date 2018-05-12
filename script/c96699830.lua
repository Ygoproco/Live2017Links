--ボーン・フロム・ドラコニス
--Born from Draconis
--Scripted by ahtelel
function c96699830.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c96699830.cost)
	e1:SetTarget(c96699830.target)
	e1:SetOperation(c96699830.activate)
	c:RegisterEffect(e1)
end
function c96699830.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c96699830.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsFaceup() and c:IsAbleToRemove()
end
function c96699830.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsLevelAbove(6)
end
function c96699830.mzfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c96699830.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		local mg=Duel.GetMatchingGroup(c96699830.cfilter,tp,LOCATION_MZONE,0,nil)
		local gg=not Duel.IsPlayerAffectedByEffect(tp,69832741) and Duel.GetMatchingGroup(c96699830.cfilter,tp,LOCATION_GRAVE,0,nil) 
			or Group.CreateGroup()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ((mg:GetCount()>0 and mg:FilterCount(c96699830.mzfilter,nil)+ft>0) or (gg:GetCount()>0 and ft>0)) 
			and Duel.IsExistingMatchingCard(c96699830.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	local g
	if Duel.IsPlayerAffectedByEffect(tp,69832741) then
		g=Duel.GetMatchingGroup(c96699830.cfilter,tp,LOCATION_MZONE,0,nil)
	else
		g=Duel.GetMatchingGroup(c96699830.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SetTargetParam(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c96699830.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c96699830.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc then
		if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetReset(RESET_EVENT+0xff0000)
			e1:SetValue(ct*500)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(c96699830.efilter)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
	end
end
function c96699830.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
