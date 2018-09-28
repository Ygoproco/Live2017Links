--サイコウィールダー
--Psychic Wheelder
function c101007024.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,101007024)
	e1:SetCondition(c101007024.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007024,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,101007024+100)
	e2:SetCondition(c101007024.con)
	e2:SetTarget(c101007024.tg)
	e2:SetOperation(c101007024.op)
	c:RegisterEffect(e2)
end
function c101007024.spfilter(c)
	return c:IsFaceup() and c:IsLevel(3) and not c:IsCode(101007024)
end
function c101007024.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101007024.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c101007024.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r & REASON_SYNCHRO == REASON_SYNCHRO 
end
function c101007024.filter(c,rc)
	return c:IsFaceup() and c:GetAttack()<rc:GetAttack()
end
function c101007024.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=e:GetHandler():GetReasonCard()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101007024.filter(chkc,rc) end
	if chk==0 then return Duel.IsExistingTarget(c101007024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101007024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101007024.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
