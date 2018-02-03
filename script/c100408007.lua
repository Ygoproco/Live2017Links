--交血鬼－ヴァンパイア・シェリダン
--Al Dhampir – Vampire Sheridan
--Scripted by Eerie Code
function c100408007.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100408007.lvtg)
	e1:SetValue(c100408007.lvval)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100408007,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100408007.cost)
	e2:SetTarget(c100408007.tgtg)
	e2:SetOperation(c100408007.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100408007,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100408007.spcon)
	e3:SetCost(c100408007.cost)
	e3:SetTarget(c100408007.sptg)
	e3:SetOperation(c100408007.spop)
	c:RegisterEffect(e3)
end
function c100408007.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetOwner()~=e:GetHandlerPlayer()
end
function c100408007.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 6
	else return lv end
end
function c100408007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100408007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c100408007.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c100408007.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(1-tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100408007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100408007.spfilter,1,nil,e,tp)
end
function c100408007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
end
function c100408007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=nil
	local g=eg:Filter(c100408007.spfilter,nil,e,tp)
	if g:GetCount()==0 then return end
	if g:GetCount()==1 then
		tc=g:GetFirst()
	else
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
