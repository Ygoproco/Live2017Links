function c210310305.initial_effect(c)
   --Activate
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_LEAVE_FIELD)
   c:RegisterEffect(e1)
   --special summon
   local e2=Effect.CreateEffect(c)
   e2:SetDescription(aux.String210310305(210310305,0))
   e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
   e2:SetProperty(EFFECT_FLAG_DELAY)
   e2:SetRange(LOCATION_SZONE)
   e2:SetCode(EVENT_LEAVE_FIELD)
   e2:SetCountLimit(1,210310305)
   e2:SetCondition(c210310305.spcon1)
   e2:SetTarget(c210310305.sptg1)
   e2:SetOperation(c210310305.spop1)
   c:RegisterEffect(e2)
   --other special summon
   local e3=e2:Clone()
   e3:SetCountLimit(1,210310305+100)
   e3:SetCondition(c210310305.spcon2)
   e3:SetTarget(c210310305.sptg2)
   e3:SetOperation(c210310305.spop2)
   c:RegisterEffect(e3)
   --add counters
   local e4=Effect.CreateEffect(c)
   e4:SetType(EFFECT_TYPE_IGNITION)
   e4:SetCode(EVENT_FREE_CHAIN)
   e4:SetRange(LOCATION_SZONE)
   e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e4:SetCountLimit(1,210310305+200)
   e4:SetTarget(c210310305.target)
   e4:SetOperation(c210310305.activate)
   c:RegisterEffect(e4)
end
--first type of special summon e2
function c210310305.cfilter1(c,tp)
   return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetPreviousRaceOnField(),RACE_FAIRY)==0 and c:IsSetCard(0x18) and c:IsPreviousPosition(POS_FACEUP)
end
function c210310305.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c210310305.cfilter1,1,nil,tp)
end
function c210310305.spfilter1(c,e,tp)
   return  c:IsSetCard(0x18) and c:IsRace(RACE_AQUA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210310305.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingMatchingCard(c210310305.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c210310305.spop1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c210310305.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--sp effect 2 e3
function c210310305.cfilter2(c,tp)
   return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetPreviousRaceOnField(),RACE_AQUA)==0 and c:IsSetCard(0x18) and c:IsPreviousPosition(POS_FACEUP)
end
function c210310305.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c210310305.cfilter2,1,nil,tp)
end
function c210310305.spfilter2(c,e,tp)
   return  c:IsSetCard(0x18) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210310305.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingMatchingCard(c210310305.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c210310305.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c210310305.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--counter effect
function c210310305.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
   Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c210310305.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
    tc:AddCounter(0x1019,2)
end
