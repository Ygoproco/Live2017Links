--ヘル・ドラゴン
function c47754278.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47754278,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c47754278.descon)
	e1:SetTarget(c47754278.destg)
	e1:SetOperation(c47754278.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47754278,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CVAL_CHECK)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c47754278.spcon)
	e2:SetCost(c47754278.spcost)
	e2:SetTarget(c47754278.sptg)
	e2:SetOperation(c47754278.spop)
	e2:SetValue(c47754278.valcheck)
	c:RegisterEffect(e2)
end
function c47754278.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackAnnouncedCount()~=0
end
function c47754278.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c47754278.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c47754278.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c47754278.cfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) or c:GetSequence()<5)
end
function c47754278.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if Duel.GetFlagEffect(tp,47754278)==0 then
			Duel.RegisterFlagEffect(tp,47754278,RESET_CHAIN,0,1)
			c47754278[tp]=1
		end
		return Duel.CheckReleaseGroupCost(tp,c47754278.cfilter,c47754278[tp],false,aux.ChkfMMZ(1),nil,ft,tp)
	end
	local g=Duel.SelectReleaseGroupCost(tp,c47754278.cfilter,1,1,false,aux.ChkfMMZ(1),nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c47754278.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47754278.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c47754278.valcheck(e)
	c47754278[e:GetHandlerPlayer()]=c47754278[e:GetHandlerPlayer()]+1
end
