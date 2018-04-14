--リプロドクス
--Scripted by Eerie Code
function c34989413.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,nil,2,2)
    --change property
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(34989413,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,34989413)
    e1:SetTarget(c34989413.target)
    e1:SetOperation(c34989413.operation)
    c:RegisterEffect(e1)
end
function c34989413.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local op=Duel.SelectOption(tp,aux.Stringid(34989413,1),aux.Stringid(34989413,2))
    e:SetLabel(op)
end
function c34989413.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local eff=0
    local val=0
    if e:GetLabel()==0 then
        eff=EFFECT_CHANGE_RACE
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
        val=Duel.AnnounceRace(tp,1,RACE_ALL)
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
    e1:SetTarget(c34989413.tg)
    e1:SetValue(val)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
function c34989413.tg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end

