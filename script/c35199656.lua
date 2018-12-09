--トリックスター・マンジュシカ
function c35199656.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35199656,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c35199656.cost)
	e1:SetTarget(c35199656.target)
	e1:SetOperation(c35199656.operation)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c35199656.damcon)
	e3:SetOperation(c35199656.damop)
	c:RegisterEffect(e3)
	if not c35199656.global_check then
		c35199656.global_check=true
		c35199656[0]=0
		c35199656[1]=0
		local gettp=Effect.CreateEffect(c)
		gettp:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		gettp:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
		gettp:SetCode(EVENT_ADJUST)
		gettp:SetOperation(function(e)
			local ge1=Effect.CreateEffect(e:GetHandler())
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_TO_HAND)
			ge1:SetOperation(c35199656.checkop)
			Duel.RegisterEffect(ge1,e:GetHandler():GetControler())
		end)
		gettp:SetCountLimit(1)
		Duel.RegisterEffect(gettp,0)
	end
end
function c35199656.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(35199656)==0 end
	c:RegisterFlagEffect(35199656,RESET_CHAIN,0,1)
end
function c35199656.filter(c)
	return c:IsSetCard(0xfb) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(35199656)
end
function c35199656.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c35199656.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c35199656.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c35199656.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c35199656.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c35199656.damcon(e,tp,eg,ep,ev,re,r,rp)
	return (c35199656[1-tp])>0
end
function c35199656.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,35199656)
	Duel.Damage(1-tp,c35199656[1-tp]*200,REASON_EFFECT)
	c35199656[0]=0
	c35199656[1]=0
end

function c35199656.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=eg:FilterCount(Card.IsControler,nil,tp)
	local ct2=eg:FilterCount(Card.IsControler,nil,1-tp)
	c35199656[tp]=c35199656[tp]+ct1
	c35199656[1-tp]=c35199656[1-tp]+ct2
	if Duel.GetCurrentChain()==0 then
		Duel.Hint(HINT_CARD,0,35199656)
		Duel.Damage(1-tp,c35199656[1-tp]*200,REASON_EFFECT)
		c35199656[0]=0
		c35199656[1]=0
	end
end
