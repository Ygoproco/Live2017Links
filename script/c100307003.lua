--グローアップ・ブルーム
--Glow-Up Bloom
--Scripted by Eerie Code
function c100307003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(100307003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100307003)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c100307003.target)
	e1:SetOperation(c100307003.operation)
	c:RegisterEffect(e1)
end
c100307003.listed_names={4064256}
function c100307003.filter(c,e,tp,chk)
	return c:IsLevelAbove(5) and c:IsRace(RACE_ZOMBIE) and (c:IsAbleToHand() or (chk and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c100307003.fieldcond(c)
	return c:IsFaceup() and c:IsCode(4064256)
end
function c100307003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ck=Duel.IsExistingMatchingCard(c100307003.fieldcond,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
		return Duel.IsExistingMatchingCard(c100307003.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ck)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100307003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100307003.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ck=Duel.IsExistingMatchingCard(c100307003.fieldcond,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,c100307003.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ck):GetFirst()
	if tc then
		if ck and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(100307003,1))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c100307003.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_ZOMBIE)
end
