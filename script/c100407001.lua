--ミレニアム・アイズ・イリュージョニスト
--Millennium-Eyes Illusionist
function c100407001.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100407001,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100407001)
	e1:SetCost(c100407001.eqcost)
	e1:SetTarget(c100407001.eqtg)
	e1:SetOperation(c100407001.eqop)
	c:RegisterEffect(e1)	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100407001,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100407001+100)
	e2:SetCondition(c100407001.thcon)
	e2:SetTarget(c100407001.thtg)
	e2:SetOperation(c100407001.thop)
	c:RegisterEffect(e2)
end
function c100407001.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100407001.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler() 
		and Duel.IsExistingMatchingCard(c100407001.eqfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c100407001.eqfilter(c,ec,tp)
	local eff={c:GetCardEffect(100407001)}
	if c:IsFacedown() or ((not c:IsSetCard(0x20a) or not c:IsType(TYPE_FUSION)) and not c:IsCode(64631466,63519819)) then return false end
	for _,te in ipairs(eff) do
		if te:GetValue()(ec,c,tp) then return true end
	end
	return false
end
function c100407001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100407001.filter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c100407001.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100407001.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100407001.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c100407001.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc1,tp)
	local tc2=g:GetFirst()
	if not tc2 then return end
	local te=tc2:GetCardEffect(100407001)
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc1:IsControler(1-tp) then
		te:GetOperation()(tc2,te:GetLabelObject(),tp,tc1)
	end
end
function c100407001.thfilter(c,e)
	return (c:IsSetCard(0x20a) and c:IsType(TYPE_FUSION)) or c:IsCode(64631466,63519819)
end
function c100407001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100407001.thfilter,1,nil)
end
function c100407001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100407001.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
