--強欲で謙虚な壺
function c98645731.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98645731+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c98645731.cost)
	e1:SetTarget(c98645731.target)
	e1:SetOperation(c98645731.activate)
	c:RegisterEffect(e1)
	if not c98645731.global_check then
		c98645731.global_check=true
		c98645731[0]=true
		c98645731[1]=true
		c98645731[2]={}
		c98645731[3]={}
		c98645731[4]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c98645731.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(c98645731.checkop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetOperation(c98645731.checkop3)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCountLimit(1)
		ge4:SetOperation(c98645731.clear)
		Duel.RegisterEffect(ge4,0)
	end
end
function c98645731.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and not c98645731[tp] end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c98645731.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return false end
		local g=Duel.GetDecktopGroup(tp,3)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c98645731.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
	end
end
function c98645731.checkop1(e,tp,eg,ep,ev,re,r,rp)
	if not c98645731[0] then
		local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
		if ex then
			if cg and cg:GetCount()>0 then
				if rp==0 or cp==PLAYER_ALL then
					c98645731[2][ev]=true
				end
			else
				local ex2,cg2,ct2,cp2,cv2=Duel.GetOperationInfo(ev,CATEGORY_TOKEN)
				if ex2 then
					if cp==0 or cp==PLAYER_ALL then
						c98645731[2][ev]=true
					end
				else
					if rp==0 or cp==0 or cp==PLAYER_ALL then
						c98645731[2][ev]=true
					end
				end
			end
			if ev>c98645731[4] then
				c98645731[4]=ev
			end
		end
	end
	if not c98645731[1] then
		local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
		if ex then
			if cg and cg:GetCount()>0 then
				if rp==1 or cp==PLAYER_ALL then
					c98645731[3][ev]=true
				end
			else
				local ex2,cg2,ct2,cp2,cv2=Duel.GetOperationInfo(ev,CATEGORY_TOKEN)
				if ex2 then
					if cp==1 or cp==PLAYER_ALL then
						c98645731[2][ev]=true
					end
				else
					if rp==1 or cp==1 or cp==PLAYER_ALL then
						c98645731[3][ev]=true
					end
				end
			end
			if ev>c98645731[4] then
				c98645731[4]=ev
			end
		end
	end
end
function c98645731.checkop2(e,tp,eg,ep,ev,re,r,rp)
	if c98645731[2][ev] then c98645731[2][ev]=false end
	if c98645731[3][ev] then c98645731[3][ev]=false end
end
function c98645731.checkop3(e,tp,eg,ep,ev,re,r,rp)
	if ev~=1 or c98645731[4]<=0 then return end
	for i=1,c98645731[4] do
		if c98645731[2][i] then c98645731[0]=true end
		if c98645731[3][i] then c98645731[1]=true end
	end
	c98645731[4]=0
end
function c98645731.clear(e,tp,eg,ep,ev,re,r,rp)
	c98645731[0]=false
	c98645731[1]=false
	c98645731[4]=0
end
