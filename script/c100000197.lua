--アトリビュート・ボム
function c100000197.initial_effect(c)
	aux.AddEquipProcedure(c,nil,nil,nil,nil,c100000197.tg)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetOperation(c100000197.desopchk)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c100000197.damcon)
	e2:SetTarget(c100000197.destg)
	e2:SetOperation(c100000197.desop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c100000197.tg(e,tp,eg,ep,ev,re,r,rp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	e:GetHandler():RegisterFlagEffect(10000197,RESET_EVENT+0x1fe0000,0,1,rc)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
end
function c100000197.desopchk(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(10000197)>0 then
		e:GetLabelObject():SetLabel(e:GetHandler():GetFlagEffectLabel(10000197))
	else
		e:GetLabelObject():SetLabel(-2)
	end
end
function c100000197.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local rc=ec:GetReasonCard()
	local q=e:GetLabel()
	return q>-2 and c:IsReason(REASON_LOST_TARGET) and ec:IsReason(REASON_BATTLE) and rc:IsAttribute(q)
end
function c100000197.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c100000197.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
