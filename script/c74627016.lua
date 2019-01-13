--T.G. Tank Larva
--Logical Nonsense
function c74627016.initial_effect(c)
	--Non-tuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(c74627016.ntval)
	c:RegisterEffect(e1)
	--Token summoning
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74627016,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,74627016)
	e2:SetCondition(c74627016.tcon)
	e2:SetTarget(c74627016.ttg)
	e2:SetOperation(c74627016.top)
	c:RegisterEffect(e2)
end
function c74627016.ntval(c,sc,tp)
	return sc and sc:IsSetCard(0x27)
end
	--If monster was sent to GY for synchro summon of "T.G." monster
function c74627016.tcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and c:GetReasonCard():IsSetCard(0x27)
end
	--Activation legality
function c74627016.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,74627017,0x27,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
	--Performing the effect of special summoning token
function c74627016.top(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,74627017,0x27,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,74627017)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
