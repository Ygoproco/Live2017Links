--BF - 毒風のシムーン
--Blackwing – Simoom the Poison Winds
--Scripted by ahtelel
function c100409024.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100409024,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100409024)
	e1:SetCondition(c100409024.tfcon)
	e1:SetCost(c100409024.tfcost)
	e1:SetTarget(c100409024.tftg)
	e1:SetOperation(c100409024.tfop)
	c:RegisterEffect(e1)
end
function c100409024.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c100409024.filter(c)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c100409024.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100409024.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100409024.filter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100409024.tffilter(c,tp)
	return c:IsCode(91351370) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c100409024.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100409024.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c100409024.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c100409024.splimit)
	Duel.RegisterEffect(e0,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.GetFirstMatchingCard(c100409024.tffilter,tp,LOCATION_DECK,0,nil)
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and (c:IsSummonableCard() or c:IsAbleToGrave()) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(c100409024.ntcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if c:IsSummonable(true,nil) and c:IsAbleToGrave() then
			op=Duel.SelectOption(tp,aux.Stringid(100409024,1),aux.Stringid(100409024,2))
		elseif c:IsAbleToGrave() then
			op=Duel.SelectOption(tp,aux.Stringid(100409024,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(100409024,2))+1
		end
		e:SetLabel(op)
		if op==0 then
			Duel.Summon(tp,c,true,nil)
		else		
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCountLimit(1)
	e2:SetOperation(c100409024.gyop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
end
function c100409024.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c100409024.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	Duel.Damage(tp,1000,REASON_EFFECT)
end
function c100409024.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsAttribute(ATTRIBUTE_DARK)
end