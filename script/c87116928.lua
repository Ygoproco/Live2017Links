--Chimeratech Megafleet Dragon
function c87116928.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c87116928.matfilter,1,99,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1093))
	aux.AddContactFusion(c,c87116928.contactfil,c87116928.contactop,c87116928.splimit)
	--cannot be fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
c87116928.material_setcode={0x93,0x1093}
function c87116928.matfilter(c)
	return c:GetSequence()>4 and c:IsLocation(LOCATION_MZONE)
end
function c87116928.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c87116928.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
end
function c87116928.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(g:GetCount()*1200)
	c:RegisterEffect(e1)
end
