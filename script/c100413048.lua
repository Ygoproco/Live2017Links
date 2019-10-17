--スマイル・アクション
--Smile Action
--Scripted by AlphaKretin
--Fixed by TOP
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function s.rmfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,5,nil)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg2=g2:Select(1-tp,1,5,nil)
		sg:Merge(sg2)
	end
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		local rg=sg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		rg:KeepAlive()
		e:GetLabelObject():SetLabelObject(rg)
		local rc=rg:GetFirst()
		while rc do
			rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			rc=rg:GetNext()
		end
	end
end
function s.thfilter(c,p)
	return c:GetFlagEffect(id)>0 and c:IsControler(p) and c:IsAbleToHand()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local at=Duel.GetAttacker()	
	local p=1-at:GetControler()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,p,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,p,LOCATION_HAND)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()	
	local p=1-at:GetControler()
	local g=e:GetLabelObject():Filter(s.thfilter,nil,p)
	if g:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
		local flag=false
		local sg=g:RandomSelect(rp,1)
		local sc=sg:GetFirst()
		if Duel.SendtoHand(sc,nil,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_HAND) and sc:IsControler(p)
			and sc:IsDiscardable() and Duel.SelectYesNo(1-rp,aux.Stringid(id,3)) then
			flag=true
			Duel.BreakEffect()
			Duel.SendtoGrave(sc,REASON_EFFECT+REASON_DISCARD)
			Duel.NegateAttack()
		end
		if flag==false then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(s.damval)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,p)
		end
	end
end
function s.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam*2
	else return dam end
end
