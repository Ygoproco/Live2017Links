--毒の魔妖-土蜘蛛
--Poison Mayakashi – Tsuchigumo
function c100410033.initial_effect(c)
	c:SetUniqueOnField(1,0,100410033)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--mill
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100410033,0))
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100410033)
	e1:SetCondition(c100410033.condition)
	e1:SetTarget(c100410033.target)
	e1:SetOperation(c100410033.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100410033,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100410133)
	e2:SetCondition(c100410033.spcon)
	e2:SetTarget(c100410033.sptg)
	e2:SetOperation(c100410033.spop)
	c:RegisterEffect(e2)
end
function c100410033.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_GRAVE and e:GetHandler():GetPreviousControler()==tp
end
function c100410033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsPlayerCanDiscardDeck(1-tp,2) end
end
function c100410033.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,3)
	local g2=Duel.GetDecktopGroup(1-tp,3)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_EFFECT)
end
function c100410033.spfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0
		and c:GetOriginalLevel()==7  and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c100410033.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100410033.spfilter,1,nil,tp)
end
function c100410033.rmfilter(c)
	return c:IsAbleToRemove() and c:IsRace(RACE_ZOMBIE)
end
function c100410033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100410033.rmfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c100410033.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100410033.rmfilter),tp,LOCATION_GRAVE,0,1,1,c)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
