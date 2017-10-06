--アームド・ドラゴン・カタパルトキャノン
--Armed Dragon Catapult Cannon
--Scripted by Eerie Code
function c100407021.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,84243274,73879377)
	aux.AddContactFusion(c,c100407021.contactfil,c100407021.contactop,c100407021.splimit,c100407021.spcon)
	--inactivate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c100407021.aclimit)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100407021,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCondition(c100407021.rmcon)
	e4:SetCost(c100407021.rmcost)
	e4:SetTarget(c100407021.rmtg)
	e4:SetOperation(c100407021.rmop)
	c:RegisterEffect(e4)
	--register summon
	if not c100407021.global_flag then
		c100407021.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c100407021.regop)
		Duel.RegisterEffect(ge1,tp)
	end
end
function c100407021.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(84243274) then
			Duel.RegisterFlagEffect(tc:GetControler(),100407021,0,0,0)
		elseif tc:IsCode(73879377) then
			Duel.RegisterFlagEffect(tc:GetControler(),100407021+100,0,0,0)
		end
	end
end
function c100407021.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c100407021.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
end
function c100407021.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
function c100407021.spcon(tp)
	return Duel.GetFlagEffect(tp,100407021)~=0 and Duel.GetFlagEffect(tp,100407021+100)~=0
end
function c100407021.acfilter(c,cd)
	return c:IsFaceup() and c:IsCode(cd)
end
function c100407021.aclimit(e,re,tp)
	return Duel.IsExistingMatchingCard(c100407021.acfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil,re:GetHandler():GetCode())
end
function c100407021.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100407021.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100407021.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c100407021.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
