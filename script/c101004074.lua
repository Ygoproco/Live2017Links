--霊神統一
--Elemental Training
--Scripted by Eerie Code; fixed by senpaizuri
function c101004074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c101004074.target)
	c:RegisterEffect(e1)
	--indes/untarget
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c101004074.intg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101004074,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c101004074.spcost)
	e4:SetTarget(c101004074.sptg)
	e4:SetOperation(c101004074.spop)
	c:RegisterEffect(e4)
	--discard & salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101004074,1))
	e5:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c101004074.thcost)
	e5:SetTarget(c101004074.thtg)
	e5:SetOperation(c101004074.thop)
	c:RegisterEffect(e5)
end
function c101004074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=c101004074.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c101004074.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c101004074.thcost(e,tp,eg,ep,ev,re,r,rp,0) and c101004074.thtg(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(101004074,0),aux.Stringid(101004074,1))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(101004074,0))
		else op=Duel.SelectOption(tp,aux.Stringid(101004074,1))+1 end
		if op==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetOperation(c101004074.spop)
			c101004074.spcost(e,tp,eg,ep,ev,re,r,rp,1)
			c101004074.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			e:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
			e:SetOperation(c101004074.thop)
			c101004074.thcost(e,tp,eg,ep,ev,re,r,rp,1)
			c101004074.thtg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c101004074.intg(e,c)
	return c:IsFaceup() and c:IsCode(101004060)
end
function c101004074.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return e:GetHandler():GetFlagEffect(101004074)==0 end
	e:GetHandler():RegisterFlagEffect(101004074,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c101004074.filter1(c,e,tp)
	return Duel.IsExistingMatchingCard(c101004074.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalAttribute())
		and Duel.GetMZoneCount(tp,c)>0
end
function c101004074.filter2(c,e,tp,att)
	return c:IsSetCard(0x400d) and c:GetOriginalAttribute()~=att and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101004074.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c101004074.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c101004074.filter1,1,1,nil,e,tp)
	e:SetLabelObject(rg:GetFirst())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101004074.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local att=e:GetLabelObject():GetOriginalAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101004074.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,att)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101004074.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101004074.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x212) and c:IsAbleToHand()
end
function c101004074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=hg:GetCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c101004074.thfilter,tp,LOCATION_GRAVE,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,hg,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_GRAVE)
end
function c101004074.thop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101004074.thfilter),tp,LOCATION_GRAVE,0,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
