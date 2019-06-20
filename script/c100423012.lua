--斬機超階乗
--Processlayer Superfactorial
--Scripted by AlphaKretin
local s,id=GetID()
function s.initial_effect(c)
    --synchro summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.announcecost)
    e1:SetTarget(s.syntg)
    e1:SetOperation(s.synop)
    c:RegisterEffect(e1)
    --xyz summon
    local e2=e1:Clone()
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetTarget(s.xyztg)
    e2:SetOperation(s.xyzop)
    c:RegisterEffect(e2)
end
s.listed_series={0x231}
function s.announcecost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.relfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.matfilter(c,e,tp)
    return c:IsSetCard(0x231) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.synfilter(c,tun,mg,lv)
    return c:IsSetCard(0x231) and c:IsSynchroSummonable(tun,mg) and (not lv or tun:GetSynchroLevel(c)+mg:GetSum(Card.GetSynchroLevel,c)==c:GetLevel())
end
function s.tunefilter(c,e,tp,exg,mg)
    return c:IsType(TYPE_TUNER) and aux.SelectUnselectGroup(mg,e,tp,1,2,s.syncheck(c,exg),0)
end
function s.syncheck(tun,exg)
    return  function(sg,e,tp,mg)
                return aux.dncheck(sg,e,tp,mg) and not sg:IsExists(Card.IsCode,1,nil,tun:GetCode()) and exg:IsExists(s.synfilter,1,nil,tun,sg,true)
            end
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
    local exg=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,nil,mg)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.GetLocationCountFromEx(tp)>0
        and mg:IsExists(s.tunefilter,1,nil,e,tp,exg,mg) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg1=mg:FilterSelect(tp,s.tunefilter,1,1,nil,e,tp,exg,mg)
    sg1:GetFirst():RegisterFlagEffect(id,RESET_CHAIN,0,0)
    local sg2=aux.SelectUnselectGroup(mg,e,tp,1,2,s.syncheck(sg1:GetFirst(),exg),chk,tp,HINTMSG_SPSUMMON)
    sg1:Merge(sg2)
    Duel.SetTargetCard(sg1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,#sg1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
    local g=Duel.GetTargetCards(e)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<#g then return end
    if g:FilterCount(s.relfilter,nil,e,tp)<#g then return end
    g=g:Filter(s.relfilter,nil,e,tp)
    for tc in aux.Next(g) do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e2)
    end
    Duel.SpecialSummonComplete()
    if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
    Duel.BreakEffect()
    local tun=g:Filter(Card.GetFlagEffect,nil,id):GetFirst()
    g:RemoveCard(tun)
    local syng=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,tun,g,true)
    if #syng>0 then
	Auxiliary.SynchroSend=5
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local syn=syng:Select(tp,1,1,nil):GetFirst()
        Duel.SynchroSummon(tp,syn,tun,g)
    end
end
function s.xyzfilter(c,mg)
    return c:IsSetCard(0x231) and c:IsType(TYPE_XYZ) and (not mg or c:IsXyzSummonable(mg,#mg,#mg))
end
function s.xrescon(exg)
    return function(sg,e,tp,mg)
        return aux.dncheck(sg,e,tp,mg) and exg:IsExists(Card.IsXyzSummonable,1,nil,sg,#sg,#sg)
    end
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
    local exg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	Debug.Message(#exg)
	local min=math.min(math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and 1 or 99),1)
	Debug.Message(min)
    if chk==0 then return min>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
        and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
        and Duel.GetLocationCountFromEx(tp)>0
        and aux.SelectUnselectGroup(mg,e,tp,3,3,s.xrescon(exg),0) end
    local sg=aux.SelectUnselectGroup(mg,e,tp,1,3,s.xrescon(exg),chk,tp,HINTMSG_SPSUMMON,s.xrescon(exg))
    Duel.SetTargetCard(sg)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e):Filter(s.relfilter,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<#g or #g==0 or (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and #g>1) then return end
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,#g)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
