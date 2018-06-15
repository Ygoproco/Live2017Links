--タイム・ストリーム
function c100000024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100000024.cost)
	e1:SetTarget(c100000024.target)
	e1:SetOperation(c100000024.activate)
	c:RegisterEffect(e1)
end
function c100000024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c100000024.filter(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsAbleToExtra() 
		and Duel.IsExistingMatchingCard(c100000024.spfilter,tp,LOCATION_EXTRA,0,1,c,e,tp,c)
end
function c100000024.spfilter(c,e,tp,rc)
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) 
		or Duel.GetLocationCountFromEx(tp,tp,rc,c)<=0 then return false end
	local res1=c:IsCode(100000027) and rc:IsCode(100000026)
	local res2=c:IsCode(100000028) and rc:IsCode(100000027)
	return res1 or res2
end
function c100000024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100000024.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100000024.filter,tp,LOCATION_MZONE,0,1,nil,e,tp)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100000024.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100000024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c100000024.spfilter,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
end
