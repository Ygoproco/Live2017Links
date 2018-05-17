--トークバック・ランサー
--Talkback Lancer
--scripted by Larry126
function c100334043.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100334043.matfilter,1,1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100334043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100334043)
	e1:SetTarget(c100334043.sptg)
	e1:SetOperation(c100334043.spop)
	c:RegisterEffect(e1)
end
function c100334043.matfilter(c,lc,sumtype,tp)
	return c:IsLevelBelow(2) and c:IsRace(RACE_CYBERSE,lc,sumtype,tp)
end
function c100334043.spfilter(c,e,tp,zone,code)
	if zone==0 then zone=0xff end
	return c:IsSetCard(0x101) and c:GetOriginalCode()~=code
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c100334043.spcfilter(c,g,zone,e,tp)
	return c:IsRace(RACE_CYBERSE) and (zone~=0 or g:IsContains(c))
		and Duel.IsExistingTarget(c100334043.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone,c:GetOriginalCode()) 
end
function c100334043.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local zone=c:GetFreeLinkedZone()&0x1f
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100334043.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c100334043.spcfilter,1,false,nil,c,lg,zone,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.SelectReleaseGroupCost(tp,c100334043.spcfilter,1,1,false,nil,c,lg,zone,e,tp)
	Duel.Release(tc,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100334043.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c:GetFreeLinkedZone()&0x1f,tc:GetFirst():GetOriginalCode())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c100334043.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetFreeLinkedZone()&0x1f
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
