--ゾーン・イーター
function c86100785.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86100785,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c86100785.condition)
	e1:SetOperation(c86100785.operation)
	c:RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(1082946)
	e2:SetLabelObject(e1)
	e2:SetCondition(c86100785.resetcon)
	e2:SetOperation(c86100785.resetop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(function(e)return #e:GetLabelObject():GetLabelObject():GetLabelObject()>0 end)
	e3:SetOperation(c86100785.endop)
	e3:SetCountLimit(1)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,0)
end
function c86100785.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and bc and bc:IsRelateToBattle() and bc:IsFaceup()
end
function c86100785.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(86100785)
		e1:SetLabelObject(e)
		e1:SetLabel(0)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		e:GetLabelObject():AddCard(bc)
	end
end
function c86100785.rfilter(c,e)
	if not c:IsLocation(LOCATION_MZONE) then return true end
	local eff={c:GetCardEffect(86100785)}
	for _,te in ipairs(eff) do
		if te:GetLabelObject()==e then return false end
	end
	return true
end
function c86100785.resetcon(e)
	local g=e:GetLabelObject():GetLabelObject()
	local rg=g:Filter(c86100785.rfilter,nil,e:GetLabelObject())
	g:Sub(rg)
	return g:GetCount()>0
end
function c86100785.resetop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():GetLabelObject()
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	c86100785.desop(sg:GetFirst(),e:GetLabelObject(),e:GetHandler())
end
function c86100785.endop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():GetLabelObject():GetLabelObject()
	local tc=g:GetFirst()
	while tc do
		c86100785.desop(tc,e:GetLabelObject():GetLabelObject(),e:GetHandler())
		tc=g:GetNext()
	end
end
function c86100785.desop(tc,e,c)
	local eff={tc:GetCardEffect(86100785)}
	for _,te in ipairs(eff) do
		if te:GetLabelObject()==e then
			local ct=te:GetLabel()+1
			te:SetLabel(ct)
			c:SetTurnCounter(ct)
			if ct==5 and Duel.Destroy(tc,REASON_EFFECT)>0 then
				--to be added if andre's PRs are merged
				--tc:SetReasonPlayer(te:GetOwnerPlayer())
				--tc:SetReasonEffect(te)
			end
		end
	end
end
