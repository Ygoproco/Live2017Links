--ワンハンドレッド·アイ·ドラゴン
function c100000150.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	aux.AddDarkSynchroProcedure(c,aux.NonTuner(nil),nil,8)
	--copy	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetOperation(c100000150.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000150,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c100000150.thtg)
	e3:SetOperation(c100000150.thop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c100000150.atkop)
	c:RegisterEffect(e4)
	--add setcode
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetValue(0x601)
	c:RegisterEffect(e5)
	--Randomizer
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(13582837,0))
	e6:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetLabel(13582837)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c100000150.con)
	e6:SetTarget(c100000150.rndtg)
	e6:SetOperation(c100000150.rndop)
	c:RegisterEffect(e6)
	--Necromancer
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(56209279,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetLabel(56209279)
	e7:SetCondition(c100000150.con)
	e7:SetTarget(c100000150.necrotg)
	e7:SetOperation(c100000150.necroop)
	c:RegisterEffect(e7)
	--Doom Dragon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e8:SetDescription(aux.Stringid(72896720,0))
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetLabel(72896720)
	e8:SetCondition(c100000150.con)
	e8:SetCost(c100000150.ddcost)
	e8:SetTarget(c100000150.ddtg)
	e8:SetOperation(c100000150.ddop)
	c:RegisterEffect(e8)
end
function c100000150.filter(c)
	return c:IsSetCard(0xb) and c:IsType(TYPE_MONSTER)
end
function c100000150.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100000150.filter,tp,LOCATION_GRAVE,0,nil)
	g:Remove(c100000150.codefilter,nil,13582837)
	g:Remove(c100000150.codefilter,nil,56209279)
	g:Remove(c100000150.codefilter,nil,72896720)
	g:Remove(c100000150.codefilterchk,nil,e:GetHandler())
	if c:IsFacedown() or g:GetCount()<=0 then return end
	repeat
		local tc=g:GetFirst()
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
		c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,0)
		local e0=Effect.CreateEffect(c)
		e0:SetCode(100000150)
		e0:SetLabel(code)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabel(cid)
		e1:SetLabelObject(e0)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c100000150.resetop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
		g:Remove(c100000150.codefilter,nil,code)
	until g:GetCount()<=0
end
function c100000150.codefilter(c,code)
	return c:GetOriginalCode()==code and c:IsSetCard(0xb)
end
function c100000150.codefilterchk(c,sc)
	return sc:GetFlagEffect(c:GetOriginalCode())>0
end
function c100000150.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100000150.filter,tp,LOCATION_GRAVE,0,nil)
	if not g:IsExists(c100000150.codefilter,1,nil,e:GetLabelObject():GetLabel()) or c:IsDisabled() then
		c:ResetEffect(e:GetLabel(),RESET_COPY)
		c:ResetFlagEffect(e:GetLabelObject():GetLabel())
	end
end
function c100000150.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c100000150.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c100000150.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c100000150.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c100000150.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c100000150.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100000150.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and not e:GetHandler():IsDisabled() 
		and Duel.IsExistingMatchingCard(c100000150.codefilter,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel())
end
function c100000150.rndtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
end
function c100000150.rndop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=0 
		or not Duel.IsExistingMatchingCard(c100000150.codefilter,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel()) then return end
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
		else
			Duel.Damage(tp,500,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c100000150.necrofilter(c,e,tp)
	return c:IsSetCard(0xb) and c:GetCode()~=56209279 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000150.necrotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100000150.necrofilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100000150.necrofilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100000150.necrofilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100000150.necroop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c100000150.codefilter,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel()) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100000150.ddcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c100000150.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	local d=g:GetFirst()
	local atk=0
	if d:IsFaceup() then atk=d:GetAttack() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk/2)
end
function c100000150.ddop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local atk=0
		if tc:IsFaceup() then atk=tc:GetAttack() end
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		Duel.Damage(1-tp,atk/2,REASON_EFFECT)
	end
end
