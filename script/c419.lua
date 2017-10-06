--Generate Effect
function c419.initial_effect(c)
	if not c419.global_check then
		c419.global_check=true
		--register for atk change
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ADJUST)
		e5:SetOperation(c419.op5)
		Duel.RegisterEffect(e5,0)
		local atkeff=Effect.CreateEffect(c)
		atkeff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		atkeff:SetCode(EVENT_CHAIN_SOLVED)
		atkeff:SetOperation(c419.atkraiseeff)
		Duel.RegisterEffect(atkeff,0)
		local atkadj=Effect.CreateEffect(c)
		atkadj:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		atkadj:SetCode(EVENT_ADJUST)
		atkadj:SetOperation(c419.atkraiseadj)
		Duel.RegisterEffect(atkadj,0)
		--Armor Monsters
		local arm1=Effect.CreateEffect(c)
		arm1:SetType(EFFECT_TYPE_FIELD)
		arm1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		arm1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		arm1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		arm1:SetCondition(c419.armatkcon)
		arm1:SetTarget(c419.armatktg)
		Duel.RegisterEffect(arm1,0)
		local arm2=Effect.CreateEffect(c)
		arm2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		arm2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		arm2:SetCode(EVENT_ATTACK_ANNOUNCE)
		arm2:SetOperation(c419.armcheckop)
		arm2:SetLabelObject(arm1)
		Duel.RegisterEffect(arm2,0)
		local arm3=Effect.CreateEffect(c)
		arm3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		arm3:SetCode(EVENT_BE_BATTLE_TARGET)
		arm3:SetCondition(c419.armatcon)
		arm3:SetOperation(c419.armatop)
		Duel.RegisterEffect(arm3,0)
		local arm4=arm3:Clone()
		Duel.RegisterEffect(arm4,1)
		--Anime card constants
		TYPE_ARMOR		=	0x10000000
		TYPE_PLUS		=	0x20000000
		TYPE_MINUS		=	0x40000000
		
		RACE_YOKAI		=	0x80000000
		RACE_CHARISMA	=	0x100000000
		
		ATTRIBUTE_LAUGH	=	0x80
	end
end

function c419.op5(e,tp,eg,ep,ev,re,r,rp)
	--ATK = 285, prev ATK = 284
	--LVL = 585, prev LVL = 584
	--DEF = 385, prev DEF = 384
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0xff,0xff,nil)
	if not g then return end
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(285)==0 and tc:GetFlagEffect(585)==0 then
			local atk=tc:GetAttack()
			local def=tc:GetDefense()
			if atk<=0 then
				tc:RegisterFlagEffect(285,nil,0,1,0)
				tc:RegisterFlagEffect(284,nil,0,1,0)
			else
				tc:RegisterFlagEffect(285,nil,0,1,atk)
				tc:RegisterFlagEffect(284,nil,0,1,atk)
			end
			if def<=0 then
				tc:RegisterFlagEffect(385,nil,0,1,0)
				tc:RegisterFlagEffect(384,nil,0,1,0)
			else
				tc:RegisterFlagEffect(385,nil,0,1,atk)
				tc:RegisterFlagEffect(384,nil,0,1,atk)
			end
			local lv=tc:GetLevel()
			tc:RegisterFlagEffect(585,nil,0,1,lv)
			tc:RegisterFlagEffect(584,nil,0,1,lv)
		end	
		tc=g:GetNext()
	end
end
function c419.atkcfilter(c)
	if c:GetFlagEffect(285)==0 then return false end
	return c:GetAttack()~=c:GetFlagEffectLabel(285)
end
function c419.defcfilter(c)
	if c:GetFlagEffect(385)==0 then return false end
	return c:GetDefense()~=c:GetFlagEffectLabel(385)
end
function c419.lvcfilter(c)
	if c:GetFlagEffect(585)==0 then return false end
	return c:GetLevel()~=c:GetFlagEffectLabel(585)
end
function c419.atkraiseeff(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c419.atkcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=Group.CreateGroup() --change atk
	local g2=Group.CreateGroup() --gain atk
	local g3=Group.CreateGroup() --lose atk
	local g4=Group.CreateGroup() --gain atk from original
	
	local dg=Duel.GetMatchingGroup(c419.defcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g5=Group.CreateGroup() --change def
	--local g6=Group.CreateGroup() --gain def
	--local g7=Group.CreateGroup() --lose def
	--local g8=Group.CreateGroup() --gain def from original
	local tc=g:GetFirst()
	while tc do
		local prevatk=0
		if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
		g1:AddCard(tc)
		if prevatk>tc:GetAttack() then
			g3:AddCard(tc)
		else
			g2:AddCard(tc)
			if prevatk<=tc:GetBaseAttack() and tc:GetAttack()>tc:GetBaseAttack() then
				g4:AddCard(tc)
			end
		end
		tc:ResetFlagEffect(284)
		tc:ResetFlagEffect(285)
		if prevatk>0 then
			tc:RegisterFlagEffect(284,nil,0,1,prevatk)
		else
			tc:RegisterFlagEffect(284,nil,0,1,0)
		end
		if tc:GetAttack()>0 then
			tc:RegisterFlagEffect(285,nil,0,1,tc:GetAttack())
		else
			tc:RegisterFlagEffect(285,nil,0,1,0)
		end
		tc=g:GetNext()
	end
	
	local dc=dg:GetFirst()
	while dc do
		local prevdef=0
		if dc:GetFlagEffect(385)>0 then prevdef=dc:GetFlagEffectLabel(385) end
		g5:AddCard(dc)
		if prevdef>dc:GetDefense() then
			--g7:AddCard(dc)
		else
			--g6:AddCard(dc)
			if prevdef<=dc:GetBaseDefense() and dc:GetDefense()>dc:GetBaseDefense() then
				--g8:AddCard(dc)
			end
		end
		dc:ResetFlagEffect(384)
		dc:ResetFlagEffect(385)
		if prevdef>0 then
			dc:RegisterFlagEffect(384,nil,0,1,prevdef)
		else
			dc:RegisterFlagEffect(384,nil,0,1,0)
		end
		if dc:GetDefense()>0 then
			dc:RegisterFlagEffect(385,nil,0,1,dc:GetDefense())
		else
			dc:RegisterFlagEffect(385,nil,0,1,0)
		end
		dc=dg:GetNext()
	end
	
	Duel.RaiseEvent(g1,511001265,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g1,511001441,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511000377,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511001762,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511000883,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511009110,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g4,511002546,re,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g5,511009053,re,REASON_EFFECT,rp,ep,0)
	--Duel.RaiseEvent(g5,???,re,REASON_EFFECT,rp,ep,0)
	
	local lvg=Duel.GetMatchingGroup(c419.lvcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lvc=lvg:GetFirst()
	while lvc do
		local prevlv=lvc:GetFlagEffectLabel(585)
		lvc:ResetFlagEffect(584)
		lvc:ResetFlagEffect(585)
		lvc:RegisterFlagEffect(584,nil,0,1,prevlv)
		lvc:RegisterFlagEffect(585,nil,0,1,lvc:GetLevel())
		lvc=lvg:GetNext()
	end
	Duel.RaiseEvent(lvg,511002524,re,REASON_EFFECT,rp,ep,0)
	
	Duel.RegisterFlagEffect(tp,285,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(1-tp,285,RESET_CHAIN,0,1)
end
function c419.atkraiseadj(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,285)~=0 or Duel.GetFlagEffect(1-tp,285)~=0 then return end
	local g=Duel.GetMatchingGroup(c419.atkcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=Group.CreateGroup() --change atk
	local g2=Group.CreateGroup() --gain atk
	local g3=Group.CreateGroup() --lose atk
	local g4=Group.CreateGroup() --gain atk from original
	
	local dg=Duel.GetMatchingGroup(c419.defcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g5=Group.CreateGroup() --change def
	--local g6=Group.CreateGroup() --gain def
	--local g7=Group.CreateGroup() --lose def
	--local g8=Group.CreateGroup() --gain def from original
	local tc=g:GetFirst()
	while tc do
		local prevatk=0
		if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
		g1:AddCard(tc)
		if prevatk>tc:GetAttack() then
			g3:AddCard(tc)
		else
			g2:AddCard(tc)
			if prevatk<=tc:GetBaseAttack() and tc:GetAttack()>tc:GetBaseAttack() then
				g4:AddCard(tc)
			end
		end
		tc:ResetFlagEffect(284)
		tc:ResetFlagEffect(285)
		if prevatk>0 then
			tc:RegisterFlagEffect(284,nil,0,1,prevatk)
		else
			tc:RegisterFlagEffect(284,nil,0,1,0)
		end
		if tc:GetAttack()>0 then
			tc:RegisterFlagEffect(285,nil,0,1,tc:GetAttack())
		else
			tc:RegisterFlagEffect(285,nil,0,1,0)
		end
		tc=g:GetNext()
	end
	
	local dc=dg:GetFirst()
	while dc do
		local prevdef=0
		if dc:GetFlagEffect(385)>0 then prevdef=dc:GetFlagEffectLabel(385) end
		g5:AddCard(dc)
		if prevdef>dc:GetDefense() then
			--g7:AddCard(dc)
		else
			--g6:AddCard(dc)
			if prevdef<=dc:GetBaseDefense() and dc:GetDefense()>dc:GetBaseDefense() then
				--g8:AddCard(dc)
			end
		end
		dc:ResetFlagEffect(284)
		dc:ResetFlagEffect(285)
		if prevdef>0 then
			dc:RegisterFlagEffect(284,nil,0,1,prevdef)
		else
			dc:RegisterFlagEffect(284,nil,0,1,0)
		end
		if dc:GetAttack()>0 then
			dc:RegisterFlagEffect(285,nil,0,1,dc:GetAttack())
		else
			dc:RegisterFlagEffect(285,nil,0,1,0)
		end
		dc=dg:GetNext()
	end
	
	Duel.RaiseEvent(g1,511001265,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g2,511001762,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g3,511009110,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g4,511002546,e,REASON_EFFECT,rp,ep,0)
	Duel.RaiseEvent(g5,511009053,e,REASON_EFFECT,rp,ep,0)
	
	local lvg=Duel.GetMatchingGroup(c419.lvcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local lvc=lvg:GetFirst()
	while lvc do
		local prevlv=lvc:GetFlagEffectLabel(585)
		lvc:ResetFlagEffect(584)
		lvc:ResetFlagEffect(585)
		lvc:RegisterFlagEffect(584,nil,0,1,prevlv)
		lvc:RegisterFlagEffect(585,nil,0,1,lvc:GetLevel())
		lvc=lvg:GetNext()
	end
	Duel.RaiseEvent(lvg,511002524,e,REASON_EFFECT,rp,ep,0)
end

function c419.cardianchk(c,tp,eg,ep,ev,re,r,rp)
	if c:IsSetCard(0xe6) and c:IsType(TYPE_MONSTER) then
		local eff={c:GetCardEffect(511001692)}
		for _,te2 in ipairs(eff) do
			local te=te2:GetLabelObject()
			local con=te:GetCondition()
			local cost=te:GetCost()
			local tg=te:GetTarget()
			if te:GetType()==EFFECT_TYPE_FIELD then
				if not con or con(te,c) then
					return true
				end
			else
				if (not con or con(te,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0) 
					and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0))) then
					return true
				end
			end
		end
	end
	return false
end

function c419.armatkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),110000103)~=0 and Duel.GetFlagEffect(1-e:GetHandlerPlayer(),110000103)~=0
end
function c419.armatktg(e,c)
	return c:GetFieldID()~=e:GetLabel() and c:IsType(TYPE_ARMOR)
end
function c419.armcheckop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if not a:IsType(TYPE_ARMOR) then return end
	if Duel.GetFlagEffect(tp,110000103)~=0 and Duel.GetFlagEffect(1-tp,110000103)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(tp,110000103,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,110000103,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c419.armatcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsControler(tp) and at:IsType(TYPE_ARMOR)
end
function c419.armfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_ARMOR)
end
function c419.armatop(e,tp,eg,ep,ev,re,r,rp)
	local atg=Duel.GetAttacker():GetAttackableTarget()
	local d=Duel.GetAttackTarget()
	if atg:IsExists(c419.armfilter,1,d) and Duel.SelectYesNo(tp,aux.Stringid(21558682,0)) then
		local g=atg:FilterSelect(tp,c419.armfilter,1,1,d)
		Duel.HintSelection(g)
		Duel.ChangeAttackTarget(g:GetFirst())
	end
end
