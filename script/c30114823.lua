--コード・ジェネレーター
--Code Generator
--Scripted by AlphaKretin
--extra material only by edo9300
function c30114823.initial_effect(c)
	--Extra Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetOperation(c30114823.extracon)
	e1:SetValue(c30114823.extraval)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30114823,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,30114823)
	e2:SetCondition(c30114823.tgcon)
	e2:SetTarget(c30114823.tgtg)
	e2:SetOperation(c30114823.tgop)
	c:RegisterEffect(e2)
end
function c30114823.extracon(c,e,tp,sg,mg,lc,og,chk)
	return (sg+mg):Filter(Card.IsLocation,nil,LOCATION_MZONE):IsExists(Card.IsRace,og,1,RACE_CYBERSE) and
	#(sg&sg:Filter(c30114823.flagcheck,nil))<2
end
function c30114823.flagcheck(c)
	return c:GetFlagEffect(30114823)>0
end
function c30114823.extraval(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		if not summon_type==SUMMON_TYPE_LINK or not sc:IsSetCard(0x101) or Duel.GetFlagEffect(tp,30114823)>0 then
			return Group.CreateGroup()
		else
			local feff=c:RegisterFlagEffect(30114823,0,0,1)
			local eff=Effect.CreateEffect(c)
			eff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			eff:SetCode(EVENT_ADJUST)
			eff:SetOperation(function(e)feff:Reset() e:Reset() end)
			Duel.RegisterEffect(eff,0)
			return Group.FromCards(c)
		end
	else
		local sg,sc,tp=...
		if summon_type&SUMMON_TYPE_LINK == SUMMON_TYPE_LINK and #sg>0 then
			Duel.Hint(HINT_CARD,tp,30114823)
			Duel.RegisterFlagEffect(tp,30114823,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c30114823.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x101)
end
function c30114823.tgfilter(c,chk)
	return c:IsRace(RACE_CYBERSE) and c:IsAttackBelow(1200) and (c:IsAbleToGrave() or (chk==1 and c:IsAbleToHand()))
end
function c30114823.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30114823.tgfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c30114823.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c30114823.tgfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		local tc=g:GetFirst()
		if e:GetLabel()==1 and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(30114823,1))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
