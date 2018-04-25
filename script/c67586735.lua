--剛鬼ツープラトン
--Gouki Doubleteam
function c67586735.initial_effect(c)
    --atk up
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(67586735,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c67586735.ddcon)
    e1:SetTarget(c67586735.ddtg)
    e1:SetOperation(c67586735.ddop)
    c:RegisterEffect(e1)
    --to deck
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c67586735.tdtg)
    e2:SetOperation(c67586735.tdop)
    c:RegisterEffect(e2)
end
function c67586735.ddcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    return c:IsLocation(LOCATION_GRAVE) and r & REASON_LINK == REASON_LINK
        and rc:IsSetCard(0xfc) and rc:IsType(TYPE_LINK)
end
function c67586735.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(e:GetHandler():GetReasonCard())
end
function c67586735.ddop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sync=c:GetReasonCard()
    if sync:IsRelateToEffect(e) and sync:IsFaceup() and sync:IsSetCard(0xfc) and sync:IsType(TYPE_LINK) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        sync:RegisterEffect(e1)
    end
end
function c67586735.filter(c)
    return c:IsSetCard(0xfc) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c67586735.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c67586735.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c67586735.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c67586735.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c67586735.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
end
