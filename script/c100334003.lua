--デフコンバード
--Defcon Bird
--scripted by Larry126
function c100334003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100334003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100334003)
	e1:SetCost(c100334003.spcost)
	e1:SetTarget(c100334003.sptg)
	e1:SetOperation(c100334003.spop)
	c:RegisterEffect(e1)
	--DEF
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100334003,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100334003.deftg)
	e2:SetOperation(c100334003.defop)
	c:RegisterEffect(e2)
end
function c100334003.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsDiscardable()
end
function c100334003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100334003.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c100334003.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c100334003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100334003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100334003.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if chk==0 then return at and at:IsControler(tp) and at:IsRace(RACE_CYBERSE)　and at:IsFaceup() end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,at,1,tp,at:GetBaseAttack()/2)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,at,1,tp,at:GetBaseAttack()/2)
end
function c100334003.defop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetFirstTarget()
	if not at or not at:IsRelateToEffect(e) or at:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(at:GetBaseAttack()*2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	at:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	at:RegisterEffect(e2)
	if not at:IsImmuneToEffect(e1) and not at:IsImmuneToEffect(e2) and at:IsAttackPos()
		and at:IsCanChangePosition() and Duel.SelectYesNo(tp,aux.Stringid(100334003,2)) then
		Duel.BreakEffect()
		Duel.ChangePosition(at,POS_FACEUP_DEFENSE)
	end
end
