--ゼロ・エクストラリンク
--Zero Extra Link
--scripted by Larry126
function c60162470.initial_effect(c)
    aux.AddPersistentProcedure(c,0,c60162470.filter)
    --eff
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(aux.PersistentTargetFilter)
    e1:SetValue(c60162470.atkval)
    c:RegisterEffect(e1)
    --material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47882565,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetLabelObject(e1)
    e2:SetCondition(c60162470.atkcon)
    e2:SetOperation(c60162470.atkop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_LEAVE_FIELD_P)
    e3:SetRange(LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCondition(c60162470.matcon)
    e3:SetOperation(c60162470.matop)
    c:RegisterEffect(e3)
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(5851097,0))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLED)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTarget(c60162470.descon)
    e4:SetOperation(c60162470.desop)
    c:RegisterEffect(e4)
end
function c60162470.exfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and (c:GetSequence()==5 or c:GetSequence()==6)
end
function c60162470.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetMutualLinkedGroup():IsExists(c60162470.exfilter,1,nil)
end
function c60162470.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c60162470.atkval(e,c)
    local val=Duel.GetMatchingGroupCount(c60162470.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*800
    e:SetLabel(val)
    return val
end
function c60162470.atkfilter(c,tc)
    return c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetFlagEffect(60162470)>0
end
function c60162470.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60162470.atkfilter,1,nil)
end
function c60162470.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:Filter(c60162470.atkfilter,1,nil):GetFirst()
    if tc then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabelObject():GetLabel())
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c60162470.matfilter(c,ec)
    return ec:IsHasCardTarget(c) and c:IsReason(REASON_MATERIAL+REASON_LINK)
end
function c60162470.matcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c60162470.matfilter,1,nil,e:GetHandler())
end
function c60162470.matop(e,tp,eg,ep,ev,re,r,rp)
    eg:Filter(c60162470.matfilter,nil,e:GetHandler()):GetFirst():GetReasonCard():RegisterFlagEffect(60162470,RESET_EVENT+0xfe0000,0,1)
end
function c60162470.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsHasCardTarget(Duel.GetAttacker())
end
function c60162470.desop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    end
end

