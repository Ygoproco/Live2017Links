--リンク・インフライヤー
--Link Infra-Flier
--Scripted by Eerie Code
function c65100616.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65100616,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65100616)
	e1:SetCondition(c65100616.spcon)
	e1:SetValue(c65100616.spval)
	c:RegisterEffect(e1)
end
function c65100616.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local zone=Duel.GetLinkedZone(tp)&0x1f
	return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c65100616.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())&0x1f
end
