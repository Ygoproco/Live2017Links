--Chimeratech Megafleet Dragon
--Scripted by Eerie Code
function c100240002.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1093),1,99,c100240002.matfilter)
	aux.AddContactFusion(c,c100240002.contactfil,c100240002.contactop,c100240002.splimit)
	--cannot be fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
c100240002.material_setcode={0x93,0x1093}
function c100240002.matfilter(c)
	return c:GetSequence()>4 and c:IsLocation(LOCATION_MZONE)
end
function c100240002.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c100240002.contactfil(tp)
	return Duel.GetMatchingGroup(c100240002.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
end
function c100240002.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function c100240002.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(g:GetCount()*1200)
	c:RegisterEffect(e1)
end
