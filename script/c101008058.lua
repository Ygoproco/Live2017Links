--雲魔物の雲核
--Cloudian Aerosol
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.ctcost)
    e1:SetTarget(s.cttg)
    e1:SetOperation(s.ctop)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id)
    e2:SetCost(s.spcost)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end
s.counter_add_list={0x1019}
function s.ctcfilter(c)
    return c:IsSetCard(0x18) and c:IsLevelAbove(1) and c:IsDiscardable()
end
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    return true
end
function s.cttfilter(c,ccnt)
    return c:IsCanAddCounter(0x1019,ccnt) and c:IsFaceup()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.cttfilter(chkc,e:GetLabel()) end
    if chk==0 then return Duel.IsExistingMatchingCard(s.ctcfilter,tp,LOCATION_HAND,0,1,nil)
        and Duel.IsExistingTarget(s.cttfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,1) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local dc=Duel.SelectMatchingCard(tp,s.ctcfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
    Duel.SendtoGrave(dc,REASON_COST+REASON_DISCARD)
    e:SetLabelObject(dc)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,s.cttfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,dc:GetLevel())
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local dc=e:GetLabelObject()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and dc then
        tc:AddCounter(0x1019,dc:GetLevel())
    end
end
function s.cfilter(c)
    return c:IsSetCard(0x18) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    g:AddCard(e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.filter(c,e,tp)
    return c:IsSetCard(0x18) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
