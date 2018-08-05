--女神ヴェルダンディの導き
--Goddess Verdande's Guidance
--Scripted by Eerie Code and AlphaKretin
function c100243009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100243009+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100243009.activate)
	c:RegisterEffect(e1)
	--see top
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100243009,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c100243009.target)
	e3:SetOperation(c100243009.operation)
	c:RegisterEffect(e3)
end
function c100243009.thcfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x228)
end
function c100243009.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c100243009.thcfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c100243009.thfilter(c)
	return c:IsCode(100243010) and c:IsAbleToHand()
end
function c100243009.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100243009.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and c100243009.thcon(e,tp,eg,ep,ev,re,r,rp) and
		Duel.SelectYesNo(tp,aux.Stringid(100243009,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100243009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.SelectOption(tp,70,71,72))
end
function c100243009.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK)<=0
		or not e:GetHandler():IsRelateToEffect(e)then return end
	Duel.DisableShuffleCheck()
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if (opt==0 and tc:IsType(TYPE_MONSTER)) then
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,1-tp,POS_FACEDOWN_DEFENSE) then
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		end
	elseif (opt==1 and tc:IsType(TYPE_SPELL)) then
		Duel.SSet(1-tp,tc)
		Duel.ConfirmCards(tp,g) 
	elseif (opt==2 and tc:IsType(TYPE_TRAP))then
		Duel.SSet(1-tp,tc)
		Duel.ConfirmCards(tp,g)
	else
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	end
end
