--サイコウィールダー
--Psychic Wheelder
function c3233859.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,3233859)
	e1:SetCondition(c3233859.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3233859,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,3233860)
	e2:SetCondition(c3233859.con)
	e2:SetTarget(c3233859.tg)
	e2:SetOperation(c3233859.op)
	c:RegisterEffect(e2)
end
function c3233859.spfilter(c)
	return c:IsFaceup() and c:IsLevel(3) and not c:IsCode(3233859)
end
function c3233859.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3233859.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c3233859.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r & REASON_SYNCHRO == REASON_SYNCHRO 
end
function c3233859.filter(c,rc)
	return c:IsFaceup() and c:GetAttack()<rc:GetAttack()
end
function c3233859.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=e:GetHandler():GetReasonCard()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c3233859.filter(chkc,rc) end
	if chk==0 then return Duel.IsExistingTarget(c3233859.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c3233859.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c3233859.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

