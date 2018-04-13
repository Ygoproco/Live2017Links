--リプロドクス
--Scripted by Eerie Code
function c101005048.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2)
    --change property
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(101005048,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,101005048)
    e1:SetTarget(c101005048.target)
    e1:SetOperation(c101005048.operation)
    c:RegisterEffect(e1)
end
function c101005048.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local op=Duel.SelectOption(tp,aux.Stringid(101005048,1),aux.Stringid(101005048,2))
    e:SetLabel(op)
end
function c101005048.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local eff=0
    local val=0
    if e:GetLabel()==0 then
        eff=EFFECT_CHANGE_RACE
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
        val=Duel.AnnounceRace(tp,1,0xff)
    else
        eff=EFFECT_CHANGE_ATTRIBUTE
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
        val=Duel.AnnounceAttribute(tp,1,0xff)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(eff)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c101005048.tg)
    e1:SetValue(val)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c101005048.tg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
