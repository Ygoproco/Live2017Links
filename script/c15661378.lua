--氷獄龍 トリシューラ
--Trishula, the Ice Prison Dragon
--Scripted by Eerie Code; fixed by senpaizuri
function c15661378.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local eff=aux.AddFusionProcMixN(c,true,true,c15661378.ffilter,3)
	eff[1]:SetValue(c15661378.matfilter)
	aux.AddContactFusion(c,c15661378.contactfil,c15661378.contactop,c15661378.splimit)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15661378,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,15661378)
	e1:SetCondition(c15661378.remcon)
	e1:SetTarget(c15661378.remtg)
	e1:SetOperation(c15661378.remop)
	c:RegisterEffect(e1)
end
function c15661378.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return (not sg or not sg:IsExists(c15661378.fusfilter,1,c,c:GetFusionCode()))
end
function c15661378.fusfilter(c,code)
	return c:IsFusionCode(code) and not c:IsHasEffect(511002961)
end
function c15661378.matfilter(c,fc,sub,sub2,mg,sg,tp,contact)
	return c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c15661378.filteraux(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c15661378.contactfil(tp)
	return Duel.GetMatchingGroup(c15661378.filteraux,tp,LOCATION_ONFIELD,0,nil)
end
function c15661378.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
function c15661378.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c15661378.mfilter(c)
	return c:GetOriginalRace()~=RACE_DRAGON
end
function c15661378.remcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	return mg and not mg:IsExists(c15661378.mfilter,1,nil)
end
function c15661378.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_DECK+LOCATION_EXTRA)
end
function c15661378.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if #g1>0 and #g2>0 and #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.ConfirmDecktop(1-tp,1)
		Duel.ConfirmCards(tp,g3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(g2)
		sg1:Merge(sg3)
		Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
	end
end
