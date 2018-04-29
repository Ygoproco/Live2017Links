--Vendread Daybreak
--Scripted by Eerie Code
function c60375194.initial_effect(c)
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60375194+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c60375194.condition)
    e1:SetTarget(c60375194.target)
    e1:SetOperation(c60375194.activate)
    c:RegisterEffect(e1)
end
function c60375194.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function c60375194.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x106) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c60375194.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60375194.filter,tp,LOCATION_MZONE,0,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,0,0,0)
end
function c60375194.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c60375194.filter,tp,LOCATION_MZONE,0,1,1,nil)
    if #g==0 then return end
    Duel.HintSelection(g)
    local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,g)
    if #dg~=0 then
        Duel.Destroy(dg,REASON_EFFECT)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    g:GetFirst():RegisterEffect(e1)
end

