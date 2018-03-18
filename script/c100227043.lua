--トポロジック・ガンブラー・ドラゴン
--Topologic Gamble Dragon
function c100227043.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--discard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100227043,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100227043)
	e1:SetCondition(c100227043.hdcon)
	e1:SetTarget(c100227043.hdtg)
	e1:SetOperation(c100227043.hdop)
	c:RegisterEffect(e1)	
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100227043,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100227043)
	e2:SetCondition(c100227043.hdcon2)
	e2:SetTarget(c100227043.hdtg2)
	e2:SetOperation(c100227043.hdop2)
	c:RegisterEffect(e2)
end
function c100227043.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsControler(1) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c100227043.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100227043.cfilter,1,nil,zone)
end
function c100227043.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rt1 = Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT)
	if rt1>0 then
		local rt2 = Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,0,LOCATION_HAND,nil,REASON_EFFECT)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,rt)
	end
end
function c100227043.hdop(e,tp,eg,ep,ev,re,r,rp)
	local rt1 = math.min(Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT),2)
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT):RandomSelect(tp,rt1)
	local rt2 = Duel.SendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)
	local g2=Duel.GetMatchingGroup(Card.IsDiscardable,tp,0,LOCATION_HAND,nil,REASON_EFFECT):Select(1-tp,rt2,rt2,nil)
	Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)
end
function c100227043.hdcon2(e)
	return e:GetHandler():IsExtraLinked()
end
function c100227043.hdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function c100227043.hdop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsDiscardable,tp,0,LOCATION_HAND,2,2,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then
		Duel.Damage(1-tp,3000,REASON_EFFECT)
	end
end
