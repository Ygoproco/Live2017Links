--鉄騎龍ティアマトン
--Tiamaton the Steel Battalion Dragon
--Script by nekrozar, completed by Eerie Code
function c101004032.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004032,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101004032)
	e2:SetCondition(c101004032.spcon)
	e2:SetTarget(c101004032.sptg)
	e2:SetOperation(c101004032.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101004032,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c101004032.destg)
	e3:SetOperation(c101004032.desop)
	c:RegisterEffect(e3)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c101004032.operation)
	c:RegisterEffect(e4)
end
function c101004032.cfilter(c)
	return c:GetColumnGroupCount()>1
end
function c101004032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101004032.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c101004032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101004032.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
function c101004032.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetColumnGroup()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,cg:GetCount(),0,0)
end
function c101004032.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local cg=c:GetColumnGroup()
		Duel.Destroy(cg,REASON_EFFECT)
	end
end
function c101004032.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pe=e:GetLabelObject()
	if pe then pe:Reset() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c101004032.disop)
	c:RegisterEffect(e1)
	e:SetLabelObject(e1)
end
function c101004032.disop(e,tp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local nseq=4-seq
	local flag=0
	if Duel.CheckLocation(tp,LOCATION_MZONE,seq) then flag=flag+(2^seq) end
	if Duel.CheckLocation(tp,LOCATION_SZONE,seq) then flag=flag+((2^seq)<<8) end
	if Duel.CheckLocation(1-tp,LOCATION_MZONE,nseq) then flag=flag+((2^nseq)<<16) end
	if Duel.CheckLocation(1-tp,LOCATION_SZONE,nseq) then flag=flag+((2^nseq)<<24) end
	if seq==1 then flag=flag+(2^5) end
	if seq==3 then flag=flag+(2^6) end
	return flag
end
