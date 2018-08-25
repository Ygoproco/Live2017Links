--古代の遠眼鏡
function c17092736.initial_effect(c)
    --confirm
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c17092736.cftg)
    e1:SetOperation(c17092736.cfop)
    c:RegisterEffect(e1)
end
function c17092736.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
    Duel.SetTargetPlayer(tp)
end
function c17092736.cfop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local ct=math.min(5,Duel.GetFieldGroupCount(p,0,LOCATION_DECK))
    if ct==0 then return end
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
    local ac=Duel.AnnounceLevel(p,1,ct)
    local g=Duel.GetDecktopGroup(1-p,ac)
    if g:GetCount()>0 then
        Duel.ConfirmCards(p,g)
    end
end
