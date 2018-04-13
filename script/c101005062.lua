--魔導研究所
--Magic Lab
--Scripted by Eerie Code
function c101005062.initial_effect(c)
    c:EnableCounterPermit(0x1)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --place counter
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c101005062.ctcon)
    e2:SetOperation(c101005062.ctop)
    c:RegisterEffect(e2)
    --to hand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c101005062.thtg)
    e3:SetOperation(c101005062.thop)
    c:RegisterEffect(e3)
    --Destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTarget(c101005062.desreptg)
    e4:SetOperation(c101005062.desrepop)
    c:RegisterEffect(e4)
end
function c101005062.ctfilter(c)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) 
        and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0 and c:IsPreviousSetCard(0x10d) 
        and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c101005062.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c101005062.ctfilter,1,nil)
end
function c101005062.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x1,2)
end
function c101005062.thfilter(c,tp)
    return c:IsCanAddCounter(0x1,1,false,LOCATION_MZONE) and c:IsLevelAbove(1)
        and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
        and Duel.IsCanRemoveCounter(tp,1,0,0x1,c:GetLevel(),REASON_COST)
end
function c101005062.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c101005062.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
    local g=Duel.GetMatchingGroup(c101005062.thfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,tp)
    local lvt={}
    local tc=g:GetFirst()
    while tc do
        local tlv=tc:GetLevel()
        lvt[tlv]=tlv
        tc=g:GetNext()
    end
    local pc=1
    for i=1,12 do
        if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
    end
    lvt[pc]=nil
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101005062,1))
    local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
    Duel.RemoveCounter(tp,1,0,0x1,lv,REASON_COST)
    e:SetLabel(lv)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c101005062.filter(c,lv)
    return c:IsCanAddCounter(0x1,1,false,LOCATION_MZONE) and c:IsLevel(lv)
        and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c101005062.thop(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c101005062.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c101005062.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
        and e:GetHandler():GetCounter(0x1)>0 end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101005062.desrepop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveCounter(ep,0x1,1,REASON_EFFECT)
end
