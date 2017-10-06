--アルカナフォースＸＶ－ＴＨＥ　ＤＥＶＩＬ
function c100000116.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000116,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100000116.cointg)
	e1:SetOperation(c100000116.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c100000116.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c100000116.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c100000116.arcanareg(c,res)
end
function c100000116.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c100000116.destg)
	e1:SetOperation(c100000116.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c100000116.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local heads=e:GetHandler():GetFlagEffectLabel(36690018)==1
	if heads then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(0)
	end
	if chkc then return heads and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	if heads then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,g:GetFirst():GetControler(),500)
	else
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	end
	Duel.SetTargetParam(e:GetHandler():GetFlagEffectLabel(36690018))
end
function c100000116.desop(e,tp,eg,ep,ev,re,r,rp)
	local heads=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)==1
	if heads then
		local tc=Duel.GetFirstTarget()
		if tc then
			if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
				Duel.Damage(tc:GetPreviousControler(),500,REASON_EFFECT)
			elseif e:GetHandler():IsRelateToEffect(e) then
				Duel.Destroy(e:GetHandler(),REASON_EFFECT)
			end
		end
	else
		local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
