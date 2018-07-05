--転生炎獣エメラルド•イーグル
--Salamangreat Emerald Eagle
--Scripted by AlphaKretin
function c101006033.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006033,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101006033.descon)
	e1:SetTarget(c101006033.destg)
	e1:SetOperation(c101006033.desop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006033,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101006033.atcost)
	e2:SetOperation(c101006033.atop)
	c:RegisterEffect(e2)
end
function c101006033.cfilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x220) 
end
function c101006033.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,c101006033.cfilter,1,false,nil,nil)
	and e:GetHandler():GetFlagEffect(101006033)==0  end
	local g=Duel.SelectReleaseGroupCost(tp,c101006033.cfilter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function c101006033.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:GetFlagEffect(101006033)==0 then
			c:RegisterFlagEffect(101006033,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_BATTLE_START)
			e1:SetOwnerPlayer(tp)
			e1:SetCondition(c101006033.descon2)
			e1:SetOperation(c101006033.desop2)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1,true)
	end
end
function c101006033.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tp==e:GetOwnerPlayer() and tc and tc:IsControler(1-tp)
end
function c101006033.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
end
function c101006033.mfilter(c)
	return c:IsCode(101006033) and c:IsPreviousLocation(LOCATION_MZONE)	 
end
function c101006033.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and #mg>0 and mg:IsExists(c101006033.mfilter,1,nil)
end
function c101006033.desfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c101006033.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101006033.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c101006033.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c101006033.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101006033.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
