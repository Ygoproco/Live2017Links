--闇黒世界－シャドウ・ディストピア－
--Lair of Darkness
--Scripted by Eerie Code
function c59160188.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--tribute substitute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59160188,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(59160188)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	e3:SetCondition(c59160188.condition)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c59160188.sptg)
	e5:SetOperation(c59160188.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_RELEASE)
	e6:SetLabelObject(e5)
	e6:SetRange(LOCATION_FZONE)
	e6:SetOperation(c59160188.regop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e7:SetOperation(c59160188.clearop)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD_P)
	e8:SetOperation(c59160188.clearop)
	c:RegisterEffect(e8)
end
function c59160188.condition(e)
	return e:GetHandler():GetFlagEffect(59160188)==0
end
function c59160188.regop(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if ec>0 then
		local val=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(val+ec)
	end	
end
function c59160188.clearop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function c59160188.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c59160188.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	if ct==0 or not e:GetHandler():IsRelateToEffect(e) 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,59160189,0,0x4011,1000,1000,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,p) then return end
	local ct=math.min(Duel.GetLocationCount(p,LOCATION_MZONE),e:GetLabel())
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=math.min(1,ct) end
	if ct==0 then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,59160189)
		Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end
