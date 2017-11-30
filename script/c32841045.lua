--魔弾の射手 カスパール
--Magibullet Shooter Caspar
function c32841045.initial_effect(c)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--search
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c32841045.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+32841045)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,32841045)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c32841045.thtg)
	e4:SetOperation(c32841045.thop)
	c:RegisterEffect(e4)
	e3:SetLabelObject(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c32841045.regop2)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	e4:SetLabelObject(e5)
	if not SameColumnChain then SameColumnChain={} end
end
function c32841045.thfilter(c,g)
	return c:IsSetCard(0x108) and c:IsAbleToHand() and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c32841045.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re or re==e:GetLabelObject() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32841045.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32841045.thfilter,tp,LOCATION_DECK,0,1,1,nil,eg)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c32841045.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsFacedown() then
		SameColumnChain[e:GetLabelObject()]=nil
		return
	end
	if Duel.GetCurrentPhase()&PHASE_DAMAGE+PHASE_DAMAGE_CAL~=0 or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or c:GetFlagEffect(1)<=0 
		or not e:GetLabelObject():IsActivatable(tp) then return end
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE==0 or rc:IsControler(1-p) then
		if rc:IsLocation(LOCATION_SZONE) and rc:IsControler(p) then
			seq=rc:GetSequence()
		else
			seq=rc:GetPreviousSequence()
		end
	end
	if not c:IsColumn(seq,p,LOCATION_SZONE) then return end
	c:RegisterFlagEffect(32841046,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
	if not SameColumnChain[e:GetLabelObject()] then
		SameColumnChain[e:GetLabelObject()]=Group.CreateGroup()
		SameColumnChain[e:GetLabelObject()]:KeepAlive()
	end
	SameColumnChain[e:GetLabelObject()]:AddCard(rc)
	e:GetLabelObject():GetLabelObject():SetLabel(1)
end
function c32841045.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if c:GetFlagEffect(32841046)==0 and e:GetLabel()==1 then
		e:SetLabel(0)
		if SameColumnChain[te] and Duel.IsExistingMatchingCard(c32841045.thfilter,tp,LOCATION_DECK,0,1,nil,SameColumnChain[te]) and Duel.SelectEffectYesNo(tp,c) then
			Duel.RaiseEvent(SameColumnChain[te],EVENT_CUSTOM+32841045,e,REASON_EFFECT,rp,ep,ev)
		end
		SameColumnChain[te]=nil
	end
end
