--ドラグニティ・ドライブ
--Dragunity Legion
--Scripted by Eerie Code
function c101005074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c101005074.target)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetLabel(2)
	e2:SetCost(c101005074.cost)
	e2:SetTarget(c101005074.target)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101005074,ACTIVITY_SPSUMMON,c101005074.counterfilter)
end
function c101005074.counterfilter(c)
	return c:IsSetCard(0x29)
end
function c101005074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101005074)==0 and Duel.GetCustomActivityCount(101005074,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RegisterFlagEffect(tp,101005074,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c101005074.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101005074.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x29)
end
function c101005074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then
			return c101005074.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		else
			return c101005074.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		end
	end
	if chk==0 then 
		if e:GetLabel()==0 then
			return c101005074.sptg(e,tp,eg,ep,ev,re,r,rp,0)
		elseif e:GetLabel()==1 then
			return c101005074.eqtg(e,tp,eg,ep,ev,re,r,rp,0)
		else return true end
	end
	local b1=c101005074.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=c101005074.eqtg(e,tp,eg,ep,ev,re,r,rp,0)
	local op=0
	--if c101005074.cost(e,tp,eg,ep,ev,re,r,rp,0) and (b1 or b2) and (op>1 or Duel.SelectYesNo(tp,aux.Stringid(101005074,0))) then
	if (b1 or b2) and (e:GetLabel()>1 or 
		(c101005074.cost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(101005074,0)))) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(101005074,1),aux.Stringid(101005074,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(101005074,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(101005074,2))+1
		end
		if e:GetLabel()>1 then c101005074.cost(e,tp,eg,ep,ev,re,r,rp,1) end
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		if op==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			c101005074.sptg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c101005074.spop)
		else
			e:SetCategory(CATEGORY_EQUIP)
			c101005074.eqtg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c101005074.eqop)
		end
		e:SetLabel(op)
	end
end
function c101005074.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x29) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005074.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c101005074.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101005074.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101005074.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101005074.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101005074.eqfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x29)
end
function c101005074.eqfilter2(c)
	return c:IsSetCard(0x29) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c101005074.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101005074.eqfilter1(chkc) end
	if chk==0 then Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(c101005074.eqfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101005074.eqfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101005074.eqfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c101005074.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local ec=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and ec:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101005074.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if not tc or not Duel.Equip(tp,tc,ec,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c101005074.eqlimit2)
		e1:SetLabelObject(ec)
		tc:RegisterEffect(e1)
	end
end
function c101005074.eqlimit2(e,c)
	return c==e:GetLabelObject()
end
