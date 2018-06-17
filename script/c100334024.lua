--サイバネット・コーデック
--Cynet Codec
--Scripted by Eerie Code
function c100334024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100334024.thtg)
	e2:SetOperation(c100334024.thop)
	c:RegisterEffect(e2)
	--register attributes
	if not c100334024.global_flag then
		c100334024.global_flag=true
		c100334024.attr_list={}
		c100334024.attr_list[0]=0
		c100334024.attr_list[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetCondition(c100334024.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100334024.resetop(e,tp,eg,ep,ev,re,r,rp)
	c100334024.attr_list[0]=0
	c100334024.attr_list[1]=0
	return false
end
function c100334024.thcfilter(c,e,tp)
	local attr=c:GetAttribute()
	return c:IsSetCard(0x101) and c:IsControler(tp) 
		and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_EXTRA)
		and c100334024.attr_list[tp]&attr==0
		and c:IsCanBeEffectTarget(e)		
		and Duel.IsExistingMatchingCard(c100334024.thfilter,tp,LOCATION_DECK,0,1,nil,attr)
end
function c100334024.thfilter(c,attr)
	return c:IsRace(RACE_CYBERSE) and c:IsAttribute(attr) and c:IsAbleToHand()
end
function c100334024.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c100334024.thcfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c100334024.thcfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=eg:FilterSelect(tp,c100334024.thcfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100334024.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100334024.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			c100334024.attr_list[tp]=c100334024.attr_list[tp]|tc:GetAttribute()
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100334024.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100334024.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_EXTRA)
end
