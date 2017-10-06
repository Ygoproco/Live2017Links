--アトリビュート・マスタリー
function c100000196.initial_effect(c)
	aux.AddEquipProcedure(c,nil,nil,nil,nil,c100000196.tg)
	--race
	local e2=Effect.CreateEffect(c)	
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100000196.destg)
	e2:SetOperation(c100000196.desop)
	c:RegisterEffect(e2)
end
function c100000196.tg(e,tp,eg,ep,ev,re,r,rp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	e:GetHandler():RegisterFlagEffect(10000196,RESET_EVENT+0x1fe0000,0,1,rc)
	e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
end
function c100000196.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():GetFlagEffect(10000196)==0 then return end
	local q=e:GetHandler():GetFlagEffectLabel(10000196)
	local ec=e:GetHandler():GetEquipTarget()
	local bc=ec:GetBattleTarget()
	if chk==0 then return ec and bc and bc:IsFaceup() and bc:IsAttribute(q) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c100000196.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetFlagEffect(10000196)==0 then return end
	local q=c:GetFlagEffectLabel(10000196)
	local ec=c:GetEquipTarget()
	local bc=ec:GetBattleTarget()
	if ec and bc and bc:IsRelateToBattle() and bc:IsAttribute(q) then Duel.Destroy(bc,REASON_EFFECT) end
end
