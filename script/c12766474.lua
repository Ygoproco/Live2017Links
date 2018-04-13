--影王デュークシェード
--Duke Shade, King of the Umbra
--Scripted by Eerie Code
function c12766474.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12766474)
	e1:SetCost(c12766474.spcost)
	e1:SetTarget(c12766474.sptg)
	e1:SetOperation(c12766474.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12766475)
	e2:SetCost(c12766474.cost)
	e2:SetTarget(c12766474.thtg)
	e2:SetOperation(c12766474.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(12766474,ACTIVITY_SPSUMMON,c12766474.counterfilter)
end
function c12766474.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c12766474.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(12766474,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12766474.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12766474.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c12766474.spcheck(sg,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or sg:IsExists(Card.IsInMainMZone,1,nil,tp)
end
function c12766474.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c12766474.cost(e,tp,eg,ep,ev,re,r,rp,0) 
		and Duel.CheckReleaseGroupCost(tp,Card.IsAttribute,1,false,c12766474.spcheck,nil,ATTRIBUTE_DARK) end
	c12766474.cost(e,tp,eg,ep,ev,re,r,rp,1)
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsAttribute,1,99,false,c12766474.spcheck,nil,ATTRIBUTE_DARK)
	local ct=Duel.Release(g,REASON_COST)
	e:SetLabel(ct)
end
function c12766474.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12766474.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500*e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c12766474.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c12766474.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12766474.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12766474.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c12766474.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c12766474.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end