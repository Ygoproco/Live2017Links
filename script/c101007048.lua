--転生炎獣サンライトウルフ
--Salamangreat Sunlight Wolf
--Scripted by Eerie Code
function c101007048.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101007048.matfilter,2,2)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007048,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101007048)
	e1:SetCondition(c101007048.thcon1)
	e1:SetTarget(c101007048.thtg1)
	e1:SetOperation(c101007048.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101007048,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101007048+100)
	e3:SetCondition(c101007048.thcon2)
	e3:SetTarget(c101007048.thtg2)
	e3:SetOperation(c101007048.thop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c101007048.valcheck)
	c:RegisterEffect(e4)
end
function c101007048.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_EFFECT,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_FIRE,scard,sumtype,tp)
end
function c101007048.thcfilter(c,g)
	return g:IsContains(c)
end
function c101007048.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101007048.thcfilter,1,nil,e:GetHandler():GetLinkedGroup())
end
function c101007048.thfilter1(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101007048.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101007048.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c101007048.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101007048.thfilter1),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c101007048.sumlimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e3,tp)
	end
end
function c101007048.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c101007048.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffect(101007048)~=0
end
function c101007048.thfilter2(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101007048.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101007048.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c101007048.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101007048.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101007048.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,101007048) and c:IsSummonType(SUMMON_TYPE_LINK) then
		c:RegisterFlagEffect(101007048,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE-RESET_TEMP_REMOVE,0,1)
	end
end
