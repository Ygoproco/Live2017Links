--F.A. Dead Heat
function c5641251.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK)
	e1:SetTarget(c5641251.acttg)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5641251,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,5641251)
	e2:SetCondition(c5641251.spcon)
	e2:SetCost(c5641251.spcost)
	e2:SetTarget(c5641251.sptg)
	e2:SetOperation(c5641251.spop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5641251,1))
	e3:SetCategory(CATEGORY_LVCHANGE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c5641251.lvlcost)
	e3:SetCondition(c5641251.lvlcon)
	e3:SetOperation(c5641251.lvlop)
	c:RegisterEffect(e3)
end
function c5641251.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) then
		if c5641251.spcon(e,tp,eg,ep,ev,re,r,rp)
			and c5641251.spcost(e,tp,eg,ep,ev,re,r,rp,0)
			and c5641251.sptg(e,tp,eg,ep,ev,re,r,rp,0)
			and Duel.SelectYesNo(tp,94) then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			e:SetOperation(c5641251.spop)
			c5641251.spcost(e,tp,eg,ep,ev,re,r,rp,1)
			c5641251.sptg(e,tp,eg,ep,ev,re,r,rp,1)
			e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
			return
		end
	end
	if Duel.CheckEvent(EVENT_PRE_DAMAGE_CALCULATE) then
		if c5641251.lvlcon(e,tp,eg,ep,ev,re,r,rp)
			and c5641251.lvlcost(e,tp,eg,ep,ev,re,r,rp,0)
			and Duel.SelectYesNo(tp,94) then
			e:SetCategory(CATEGORY_LVCHANGE+CATEGORY_DESTROY)
			e:SetProperty(0)
			e:SetOperation(c5641251.lvlop)
			c5641251.lvlcost(e,tp,eg,ep,ev,re,r,rp,1)
			e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
			return
		end
	end
	e:SetCategory(0)
	e:SetProperty(0)
	e:SetOperation(nil)
end
function c5641251.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c5641251.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,5641251)==0 end
	Duel.RegisterFlagEffect(tp,5641251,RESET_PHASE+PHASE_END,0,1)
end
function c5641251.spfilter(c,e,tp)
	return c:IsSetCard(0x107) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c5641251.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c5641251.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c5641251.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c5641251.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



function c5641251.lvlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(5641251)==0 end
	c:RegisterFlagEffect(5641251,RESET_CHAIN,0,1)
end
function c5641251.lvlcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	return bc:IsFaceup() and tc:IsFaceup() and tc:IsSetCard(0x107)
end
function c5641251.lvlop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then bc,tc=tc,bc end
	local d1=0
	local d2=0
	while d1==d2 do
		d1,d2=Duel.TossDice(tp,1,1)
	end
	if d1>d2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(4)
		tc:RegisterEffect(e1)
	else
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

