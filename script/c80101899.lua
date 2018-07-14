--トラップトリック
--Traptrick
--Scripted by Eerie Code
function c80101899.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,80101899+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c80101899.target)
	e1:SetOperation(c80101899.activate)
	c:RegisterEffect(e1)
end
function c80101899.rmfilter(c,tp)
	return c:GetType()==TYPE_TRAP and not c:IsCode(80101899) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c80101899.setfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c80101899.setfilter(c,cd)
	return c:IsCode(cd) and c:IsSSetable()
end
function c80101899.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80101899.rmfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c80101899.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c80101899.aclimit1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c80101899.aclimit2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(c80101899.econ)
	e3:SetValue(c80101899.elimit)
	Duel.RegisterEffect(e3,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,c80101899.rmfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c80101899.setfilter,tp,LOCATION_DECK,0,1,1,nil,rc:GetCode())
		if #g>0 then
			Duel.SSet(tp,g)
			Duel.ConfirmCards(1-tp,g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
function c80101899.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_TRAP) then return end
	Duel.RegisterFlagEffect(tp,80101899,RESET_PHASE+PHASE_END,0,1)
end
function c80101899.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_TRAP) then return end
	Duel.ResetFlagEffect(tp,80101899)
end
function c80101899.econ(e)
	return Duel.GetFlagEffect(tp,80101899)~=0
end
function c80101899.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_TRAP)
end

