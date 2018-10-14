--E HERO コズモ・ネオス
--Elemental HERO Cosmo Neos
--Scripted by AlphaKretin
function c90050480.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixN(c,false,false,CARD_NEOS,1,c90050480.ffilter,3)
	aux.AddContactFusion(c,c90050480.contactfil,c90050480.contactop,c90050480.splimit)
	--no activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90050480,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c90050480.nacon)
	e1:SetTarget(c90050480.natg)
	e1:SetOperation(c90050480.naop)
	c:RegisterEffect(e1)
	--neos return
	aux.EnableNeosReturn(c,CATEGORY_DESTROY,c90050480.desinfo,c90050480.desop)
end
c90050480.listed_names={CARD_NEOS}
c90050480.material_setcode={0x8,0x3008,0x9,0x1f}
function c90050480.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsFusionSetCard(0x1f)  and c:GetAttribute(fc,sumtype,tp)~=0 and (not sg or not sg:IsExists(c90050480.fusfilter,1,c,c:GetAttribute(fc,sumtype,tp),fc,sumtype,tp))
end
function c90050480.fusfilter(c,attr,fc,sumtype,tp)
	return c:IsFusionSetCard(0x1f) and c:IsAttribute(attr,fc,sumtype,tp) and not c:IsHasEffect(511002961)
end
function c90050480.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function c90050480.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function c90050480.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c90050480.nacon(e)
	return e:GetHandler():GetSummonLocation()&LOCATION_EXTRA==LOCATION_EXTRA
end
function c90050480.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c90050480.chainlm)
end
function c90050480.chainlm(e,rp,tp)
	return tp==rp
end
function c90050480.naop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c90050480.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90050480.aclimit(e,re,tp)
	return re:GetHandler():IsOnField()
end
function c90050480.desinfo(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function c90050480.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

