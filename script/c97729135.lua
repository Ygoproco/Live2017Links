--にらみ合い
--Starring Contest
function c97729135.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(97729135,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c97729135.mvcon(0))
	e2:SetTarget(c97729135.mvtg1)
	e2:SetOperation(c97729135.mvop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(97729135,1))
	e3:SetCondition(c97729135.mvcon(1))
	e3:SetTarget(c97729135.mvtg2)
	e3:SetOperation(c97729135.mvop2)
	c:RegisterEffect(e3)
end
function c97729135.getzone(p,eg)
	local zone=0
	for tc in aux.Next(eg:Filter(c97729135.cfilter,nil,p)) do
		zone=zone|tc:GetColumnZone(LOCATION_MZONE,0,0,1-p)
	end
	return zone
end
function c97729135.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsInExtraMZone()
end
function c97729135.mvcon(i)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(c97729135.cfilter,1,nil,i-tp)
	end
end
function c97729135.mvtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c97729135.getzone(tp,eg)
	if chkc then return chkc:IsInMainMZone(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsInMainMZone,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(97729135,2))
	Duel.SelectTarget(tp,Card.IsInMainMZone,tp,0,LOCATION_MZONE,1,1,nil)
end
function c97729135.mvop1(e,tp,eg,ep,ev,re,r,rp)
	local zone=c97729135.getzone(tp,eg)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(tp) or tc:IsImmuneToEffect(e)
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,~(zone<<16))>>16,2))
end
function c97729135.mvtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c97729135.getzone(1-tp,eg)
	if chkc then return chkc:IsInMainMZone(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsInMainMZone,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(97729135,2))
	Duel.SelectTarget(tp,Card.IsInMainMZone,tp,LOCATION_MZONE,0,1,1,nil)
end
function c97729135.mvop2(e,tp,eg,ep,ev,re,r,rp)
	local zone=c97729135.getzone(1-tp,eg)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp)
		or Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(tc,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~zone),2))
end

