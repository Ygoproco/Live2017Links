--超弩級砲塔列車ジャガーノート・リーベ
--Super Dreadnought Railway Cannon Juggernaut Reeve
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,11,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
    c:EnableReviveLimit()
    --boost
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(s.atkcost)
    e1:SetOperation(s.atkop)
    c:RegisterEffect(e1,false,1)
    --multi attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
    e2:SetValue(s.raval)
    c:RegisterEffect(e2)
end
function s.ovfilter(c)
    return c:IsFaceup() and c:GetRank()==10 and c:IsRace(RACE_MACHINE)
end
function s.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
    return true
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(2000)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
    local e0=Effect.CreateEffect(e:GetHandler())
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_CANNOT_ATTACK)
    e0:SetTargetRange(LOCATION_MZONE,0)
    e0:SetTarget(s.ftarget)
    e0:SetLabel(c:GetFieldID())
    e0:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e0,tp)
end
function s.ftarget(e,c)
    return e:GetLabel()~=c:GetFieldID()
end
function s.raval(e,c)
    local oc=e:GetHandler():GetOverlayCount()
    return math.max(0,oc)
end

