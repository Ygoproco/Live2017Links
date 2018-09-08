Auxiliary={}
aux=Auxiliary
POS_FACEUP_DEFENCE=POS_FACEUP_DEFENSE
POS_FACEDOWN_DEFENCE=POS_FACEDOWN_DEFENSE
RACE_CYBERS=RACE_CYBERSE
TYPE_EXTRA=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
ATTRIBUTE_DIVINE=ATTRIBUTE_DEVINE
RACE_WINGEDBEAST=RACE_WINDBEAST
RACE_PSYCHIC=RACE_PSYCHO
RACE_DIVINE=RACE_DEVINE
SUMMON_TYPE_TRIBUTE=SUMMON_TYPE_ADVANCE
SUMMON_TYPE_GEMINI=SUMMON_TYPE_DUAL

Group.__band = function (o1,o2)
	if userdatatype(o1)~="Group" then o1,o2=o2,o1 end
	o1=o1:Clone()
	o1=o1-(o1-o2)
	return o1
end

Group.__add = function (o1,o2)
	if userdatatype(o1)~="Group" then o1,o2=o2,o1 end
	o1=o1:Clone()
	if userdatatype(o2)=="Card" then
		o1:AddCard(o2)
	else
		o1:Merge(o2)
	end
	return o1
end

Group.__sub = function (o1,o2)
	o1=o1:Clone()
	if userdatatype(o2)=="Card" then
		o1:RemoveCard(o2)
	else
		o1:Sub(o2)
	end
	return o1
end

Group.__len = function (g)
	return g:GetCount()
end

Group.__eq = function (g1,g2)
	return #g1==#g2
end

Group.__lt = function (g1,g2)
	return #g1<#g2
end

Group.__le = function (g1,g2)
	return #g1<=#g2
end
--Returns 2 groups, the 1st group is the one with cards that match the function, the second is the one with cards that don't
Group.Split = function (g,fun,ex,...)
	local ng=g:Filter(fun,ex,...)
	return ng,g-ng
end

function userdatatype(o)
	if type(o)~="userdata" then return "not userdata"
	elseif o.GetOriginalCode then return "Card"
	elseif o.KeepAlive then return "Group"
	elseif o.SetLabelObject then return "Effect"
	end
end
function Card.CheckAdjacent(c)
	local p=c:GetControler()
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(p,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(p,LOCATION_MZONE,seq+1))
end
function Card.MoveAdjacent(c)
	local tp=c:GetControler()
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(0x1<<seq-1) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(0x1<<seq+1) end
	if flag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(c,math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,~flag),2))
end
function Auxiliary.GetExtraMaterials(tp,mustg,sc,summon_type)
	local tg=Group.CreateGroup()
	mustg = mustg or Group.CreateGroup()
	local eff={Duel.GetPlayerEffect(tp,EFFECT_EXTRA_MATERIAL)}
	local t={}
	for _,te in ipairs(eff) do
		if te:GetCode()==EFFECT_EXTRA_MATERIAL then
			local eg=te:GetValue()(0,summon_type,te,tp,sc)-mustg
			eg:KeepAlive()
			tg=tg+eg
			local efun=te:GetOperation() and te:GetOperation() or aux.TRUE
			table.insert(t,{eg,efun,te})
		end
	end
	return t,tg
end
function Auxiliary.CheckValidExtra(c,tp,sg,mg,lc,emt,filt)
	local res=false
	filt=filt or {}
	for _,ex in ipairs(emt) do
		if ex[1]:IsContains(c) and ex[2](c,ex[3],tp,sg,mg,lc,ex[1],0) then
			res=true
			table.insert(filt,ex)
		end
	end
	return res
end
function Auxiliary.GetMustBeMaterialGroup(tp,eg,sump,sc,g,r)
	--- eg all default materials, g - valid materials
	local eff={Duel.GetPlayerEffect(tp,EFFECT_MUST_BE_MATERIAL)}
	local sg=Group.CreateGroup()
	for _,te in ipairs(eff) do
		if te:GetCode()==EFFECT_MUST_BE_MATERIAL then
			local val=type(te:GetValue())=='function' and te:GetValue()(te,eg,sump,sc,g) or te:GetValue()
			if val&r>0 then
				sg:AddCard(te:GetHandler())
			end
		end
	end
	return sg
end
function Group.Includes(g1,g2)
	return #(g1-g2)+#g2==#g1
end
function Auxiliary.ExtraLinked(c,emc,eg)
	eg:AddCard(c)
	local res=(c==emc) or (c:GetMutualLinkedGroup():IsExists(Auxiliary.ExtraLinked,1,eg,emc,eg))
	eg:RemoveCard(c)
	return res
end
function Card.IsExtraLinked(c)
	local card5=Duel.GetFieldCard(0,LOCATION_MZONE,5) and Duel.GetFieldCard(0,LOCATION_MZONE,5) or Duel.GetFieldCard(1,LOCATION_MZONE,6)
	local card6=Duel.GetFieldCard(0,LOCATION_MZONE,6) and Duel.GetFieldCard(0,LOCATION_MZONE,6) or Duel.GetFieldCard(1,LOCATION_MZONE,5)
	if card5 and card6 then
		local mg=c:GetMutualLinkedGroup()
		local emg=(Group.FromCards(card5,card6)-c)
		for card in aux.Next(emg) do
			if not mg:IsExists(Auxiliary.ExtraLinked,1,nil,card,Group.FromCards(c)) then return false end
		end
		return true
	end
	return false
end
--for additional registers
local regeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	if c:IsStatus(STATUS_INITIALIZING) and not e then Debug.Message("missing (Effect e) in c"..c:GetOriginalCode()..".lua") return end
	local tmp = function(eff,set)
		local cond=eff:GetCondition()
		eff:SetCondition(function(...)
			return ((not set and not aux.linkset) or (set and aux.linkset)) and (not cond or cond(...))
		end)
	end
	if e:GetCode()==EFFECT_ADD_FUSION_CODE or e:GetCode()==EFFECT_ADD_FUSION_SETCODE then
		tmp(e,false)
	end
	if e:GetCode()==EFFECT_ADD_LINK_CODE or e:GetCode()==EFFECT_ADD_LINK_SETCODE then
		tmp(e,true)
		if e:GetCode()==EFFECT_ADD_LINK_CODE  then e:SetCode(EFFECT_ADD_FUSION_CODE) end
		if e:GetCode()==EFFECT_ADD_LINK_SETCODE  then e:SetCode(EFFECT_ADD_FUSION_SETCODE) end
	end
	tmp = nil
	--1 == 511002571 - access to effects that activate that detach an Xyz Material as cost
	--2 == 511001692 - access to Cardian Summoning conditions/effects
	regeff(c,e,forced)
	local reg={...}
	local resetflag,resetcount=e:GetReset()
	for _,val in ipairs(reg) do
		local prop=EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE
		if e:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then prop=prop|EFFECT_FLAG_UNCOPYABLE end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(prop,EFFECT_FLAG2_MAJESTIC_MUST_COPY)
		if val==1 then
			e2:SetCode(511002571)
		elseif val==2 then
			e2:SetCode(511001692)
		end
		e2:SetLabelObject(e)
		e2:SetLabel(c:GetOriginalCode())
		if resetflag and resetcount then
			e2:SetReset(resetflag,resetcount)
		elseif resetflag then
			e2:SetReset(resetflag)
		end
		c:RegisterEffect(e2)
	end
	--used for steelswarm origin, updates the summon procedures to support its effect
	if e:GetCode()==EFFECT_SPSUMMON_PROC then
		local target=e:GetTarget()
		e:SetTarget(function(e,...)
			local res = true
			if target then
				res = target(e,...)
			end
			if res and e:GetHandler():IsLocation(LOCATION_EXTRA) then
				aux.ExtraSummon=true
				local e1=Effect.GlobalEffect()
				e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1:SetCode(EVENT_ADJUST)
				e1:SetOperation(function(e)aux.ExtraSummon=false e:Reset() end)
				Duel.RegisterEffect(e1,0)
			end
			return res
		end)
	end
end
function Card.IsColumn(c,seq,tp,loc)
	if not c:IsOnField() then return false end
	local cseq=c:GetSequence()
	local seq=seq
	local loc=loc and loc or c:GetLocation()
	local tp=tp and tp or c:GetControler()
	if c:IsLocation(LOCATION_MZONE) then
		if cseq==5 then cseq=1 end
		if cseq==6 then cseq=3 end
	else
		if cseq==6 then cseq=5 end
	end
	if loc==LOCATION_MZONE then
		if seq==5 then seq=1 end
		if seq==6 then seq=3 end
	else
		if cseq==6 then cseq=5 end
	end
	if c:IsControler(tp) then
		return cseq==seq
	else
		return cseq==4-seq
	end
end

function Card.UpdateAttack(c,amt,reset,rc)
	rc=rc and rc or c
	local r=(c==rc) and RESETS_STANDARD_DISABLE or RESETS_STANDARD
	reset=reset and reset or RESET_EVENT+r
    local atk=c:GetAttack()
    if atk>=-amt then --If amt is positive, it would become negative and always be lower than or equal to atk, if amt is negative, it would become postive and if it is too much it would be higher than atk
    	local e1=Effect.CreateEffect(rc)
    	e1:SetType(EFFECT_TYPE_SINGLE)
    	e1:SetCode(EFFECT_UPDATE_ATTACK)
    	if c==rc then
    		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
    	end
    	e1:SetValue(amt)
    	e1:SetReset(reset)
    	c:RegisterEffect(e1)
    	return c:GetAttack()-atk
    end
    return 0
end

function Card.UpdateDefense(c,amt,reset,rc)
	rc=rc and rc or c
	local r=(c==rc) and RESETS_STANDARD_DISABLE or RESETS_STANDARD
	reset=reset and reset or RESET_EVENT+r
    local def=c:GetDefense()
    if def and def>=-amt then --See Card.UpdateAttack
    	local e1=Effect.CreateEffect(rc)
    	e1:SetType(EFFECT_TYPE_SINGLE)
    	e1:SetCode(EFFECT_UPDATE_DEFENSE)
    	if c==rc then
    		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
    	end
    	e1:SetValue(amt)
    	e1:SetReset(reset)
    	c:RegisterEffect(e1)
    	return c:GetDefense()-def
    end
    return 0
end

function Card.UpdateLevel(c,amt,reset,rc)
	rc=rc and rc or c
	local r=(c==rc) and RESETS_STANDARD_DISABLE or RESETS_STANDARD
	reset=reset and reset or RESET_EVENT+r
    local lv=c:GetLevel()
    if c:IsLevelBelow(2147483647) then
    	if lv+amt<=0 then amt=-(lv-1) end --Unlike ATK, if amt is too much should reduce as much as possible
    	local e1=Effect.CreateEffect(rc)
    	e1:SetType(EFFECT_TYPE_SINGLE)
    	e1:SetCode(EFFECT_UPDATE_LEVEL)
    	e1:SetValue(amt)
    	e1:SetReset(reset)
    	c:RegisterEffect(e1)
    	return c:GetLevel()-lv
    end
    return 0
end

function Card.UpdateRank(c,amt,reset,rc)
	rc=rc and rc or c
	local r=(c==rc) and RESETS_STANDARD_DISABLE or RESETS_STANDARD
	reset=reset and reset or RESET_EVENT+r
    local rk=c:GetRank()
    if c:IsRankBelow(2147483647) then
    	if rk+amt<=0 then amt=-(rk-1) end --See Card.UpdateLevel
    	local e1=Effect.CreateEffect(rc)
    	e1:SetType(EFFECT_TYPE_SINGLE)
    	e1:SetCode(EFFECT_UPDATE_RANK)
    	e1:SetValue(amt)
    	e1:SetReset(reset)
    	c:RegisterEffect(e1)
    	return c:GetRank()-rk
    end
    return 0
end

function Card.UpdateLink(c,amt,reset,rc)
	rc=rc and rc or c
	local r=(c==rc) and RESETS_STANDARD_DISABLE or RESETS_STANDARD
	reset=reset and reset or RESET_EVENT+r
    local lk=c:GetLink()
    if c:IsLinkBelow(2147483647) then
    	if lk+amt<=0 then amt=-(lk-1) end --See Card.UpdateLevel
    	local e1=Effect.CreateEffect(rc)
    	e1:SetType(EFFECT_TYPE_SINGLE)
    	e1:SetCode(EFFECT_UPDATE_LINK)
    	e1:SetValue(amt)
    	e1:SetReset(reset)
    	c:RegisterEffect(e1)
    	return c:GetLink()-lk
    end
    return 0
end

function Card.UpdateScale(c,amt,reset,rc)
	rc=rc and rc or c
	local r=(c==rc) and RESETS_STANDARD_DISABLE or RESETS_STANDARD
	reset=reset and reset or RESET_EVENT+r
	local scl=c:GetLeftScale()
	if scl then
		if scl+amt<=0 then amt = -(scl-1) end --See Card.UpdateLevel
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(amt)
		e1:SetReset(reset)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		c:RegisterEffect(e2)
		return c:GetLeftScale()-scl
	end
	return 0
end

function Auxiliary.Stringid(code,id)
	return code*16+id
end
function Auxiliary.Next(g)
	local first=true
	return	function()
				if first then first=false return g:GetFirst()
				else return g:GetNext() end
			end
end
function Auxiliary.NULL()
end
function Auxiliary.TRUE()
	return true
end
function Auxiliary.FALSE()
	return false
end
function Auxiliary.AND(...)
	local funs={...}
	return	function(...)
				for _,f in ipairs(funs) do
					if not f(...) then return false end
				end
				return true
			end
end
function Auxiliary.OR(...)
	local funs={...}
	return	function(...)
				for _,f in ipairs(funs) do
					if f(...) then return true end
				end
				return false
			end
end
function Auxiliary.NOT(f)
	return	function(...)
				return not f(...)
			end
end
function Auxiliary.BeginPuzzle(effect)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TURN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(Auxiliary.PuzzleOp)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_DP)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SKIP_SP)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,0)
end
function Auxiliary.PuzzleOp(e,tp)
	Duel.SetLP(0,0)
end
function Auxiliary.IsDualState(effect)
	local c=effect:GetHandler()
	return not c:IsDisabled() and c:IsDualState()
end
function Auxiliary.IsNotDualState(effect)
	local c=effect:GetHandle()
	return c:IsDisabled() or not c:IsDualState()
end
function Auxiliary.DualNormalCondition(effect)
	local c=effect:GetHandler()
	return c:IsFaceup() and not c:IsDualState()
end
function Auxiliary.EnableDualAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e3)
end
--register effect of return to hand for Spirit monsters
function Auxiliary.EnableSpiritReturn(c,event1,...)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.SpiritReturnReg)
	c:RegisterEffect(e1)
	for i,event in ipairs{...} do
		local e2=e1:Clone()
		e2:SetCode(event)
		c:RegisterEffect(e2)
	end
end
function Auxiliary.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnCondition)
	e1:SetTarget(Auxiliary.SpiritReturnTarget)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function Auxiliary.SpiritReturnCondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function Auxiliary.SpiritReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function Auxiliary.SpiritReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function Auxiliary.TargetEqualFunction(f,value,...)
	local params={...}
	return	function(effect,target)
				return f(target,table.unpack(params))==value
			end
end
function Auxiliary.TargetBoolFunction(f,...)
	local params={...}
	return	function(effect,target)
				return f(target,table.unpack(params))
			end
end
function Auxiliary.FilterEqualFunction(f,value,...)
	local params={...}
	return	function(target)
				return f(target,table.unpack(params))==value
			end
end
--used for Material Types Filter Bool (works for IsRace, IsAttribute, IsType)
function Auxiliary.FilterBoolFunctionEx(f,value)
	return	function(target,scard,sumtype,tp)
				return f(target,value,scard,sumtype,tp)
			end
end
function Auxiliary.FilterBoolFunction(f,...)
	local params={...}
	return	function(target)
				return f(target,table.unpack(params))
			end
end
Auxiliary.ProcCancellable=false
function Auxiliary.IsMaterialListCode(c,...)
	if not c.material then return false end
	local codes={...}
	for _,code in ipairs(codes) do
		for _,mcode in ipairs(c.material) do
			if code==mcode then return true end
		end
	end
	return false
end
function Auxiliary.IsMaterialListSetCard(c,...)
	if not c.material_setcode then return false end
	local setcodes={...}
	for _,setcode in ipairs(setcodes) do
		if type(c.material_setcode)=='table' then
			for _,v in ipairs(c.material_setcode) do
				if v==setcode then return true end
			end
		else
			if c.material_setcode==setcode then return true end
		end
	end
	return false
end
function Auxiliary.IsCodeListed(c,...)
	if not c.listed_names then return false end
	local codes={...}
	for _,code in ipairs(codes) do
		for _,ccode in ipairs(c.listed_names) do
			if code==ccode then return true end
		end
	end
	return false
end
--card effect disable filter(target)
function Auxiliary.disfilter1(c)
	return c:IsFaceup() and not c:IsDisabled() and (not c:IsType(TYPE_NORMAL) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
--condition of EVENT_BATTLE_DESTROYING
function Auxiliary.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster
function Auxiliary.bdocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end
--condition of EVENT_BATTLE_DESTROYING + to_grave
function Auxiliary.bdgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_BATTLE_DESTROYING + opponent monster + to_grave
function Auxiliary.bdogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
--condition of EVENT_TO_GRAVE + destroyed_by_opponent_from_field
function Auxiliary.dogcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY) and rp~=tp
end
--condition of "except the turn this card was sent to the Graveyard"
function Auxiliary.exccon(e)
	return Duel.GetTurnCount()~=e:GetHandler():GetTurnID() or e:GetHandler():IsReason(REASON_RETURN)
end
--flag effect for spell counter
function Auxiliary.chainreg(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(1)==0 then
		e:GetHandler():RegisterFlagEffect(1,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end
--default filter for EFFECT_CANNOT_BE_BATTLE_TARGET
function Auxiliary.imval1(e,c)
	return not c:IsImmuneToEffect(e)
end
--default filter for EFFECT_CANNOT_BE_BATTLE_TARGET + opponent
function Auxiliary.imval2(e,c)
	return Auxiliary.imval1(e,c) and c:GetControler()~=e:GetHandlerPlayer()
end
--filter for EFFECT_CANNOT_BE_EFFECT_TARGET + opponent 
function Auxiliary.tgoval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
--filter for non-zero ATK 
function Auxiliary.nzatk(c)
	return c:IsFaceup() and c:GetAttack()>0
end
--filter for non-zero DEF
function Auxiliary.nzdef(c)
	return c:IsFaceup() and c:GetDefense()>0
end
--flag effect for summon/sp_summon turn
function Auxiliary.sumreg(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	for tc in aux.Next(eg) do
		if tc:GetOriginalCode()==code then 
			tc:RegisterFlagEffect(code,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1) 
		end
	end
end
--sp_summon condition for fusion monster
function Auxiliary.fuslimit(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
--sp_summon condition for ritual monster
function Auxiliary.ritlimit(e,se,sp,st)
	return st&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL
end
--sp_summon condition for synchro monster
function Auxiliary.synlimit(e,se,sp,st)
	return st&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO
end
--sp_summon condition for xyz monster
function Auxiliary.xyzlimit(e,se,sp,st)
	return st&SUMMON_TYPE_XYZ==SUMMON_TYPE_XYZ
end
--sp_summon condition for pendulum monster
function Auxiliary.penlimit(e,se,sp,st)
	return st&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM
end
--sp_summon condition for link monster
function Auxiliary.lnklimit(e,se,sp,st)
	return st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK
end
--effects inflicting damage to tp
function Auxiliary.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) then 
		return true 
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE)
end
--filter for the immune effect of qli monsters
function Auxiliary.qlifilter(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetHandler()
		if ec:IsType(TYPE_LINK) then
			return false
		elseif ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	else
		return false
	end
end
--filter for necro_valley test
function Auxiliary.nvfilter(c)
	return not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function Auxiliary.NecroValleyFilter(f)
	return	function(target,...)
				return f(target,...) and not (target:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0))
			end
end

--Cost for effect "You can banish this card from your Graveyard"
function Auxiliary.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741) or not c:IsType(TYPE_MONSTER)
		or not c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

--sp_summon condition for gladiator beast monsters
function Auxiliary.gbspcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+100) and st<(SUMMON_TYPE_SPECIAL+150)
end

--sp_summon condition for evolsaur monsters
function Auxiliary.evospcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+150) and st<(SUMMON_TYPE_SPECIAL+180)
end

--check for Spirit Elimination
function Auxiliary.SpElimFilter(c,mustbefaceup,includemzone)
	--includemzone - contains MZONE in original requirement
	--NOTE: Should only check LOCATION_MZONE+LOCATION_GRAVE
	if c:IsType(TYPE_MONSTER) then
		if mustbefaceup and c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return false end
		if includemzone then return c:IsLocation(LOCATION_MZONE) or not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) end
		if Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) then
			return c:IsLocation(LOCATION_MZONE)
		else
			return c:IsLocation(LOCATION_GRAVE)
		end
	else
		return includemzone or c:IsLocation(LOCATION_GRAVE)
	end
end

--check for Eyes Restrict equip limit
function Auxiliary.AddEREquipLimit(c,con,equipval,equipop,linkedeff,prop,resetflag,resetcount)
	local finalprop=EFFECT_FLAG_CANNOT_DISABLE
	if prop~=nil then
		finalprop=finalprop|prop
	end
	local e1=Effect.CreateEffect(c)
	if con then
		e1:SetCondition(con)
	end
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(finalprop,EFFECT_FLAG2_MAJESTIC_MUST_COPY)
	e1:SetCode(89785779)
	e1:SetLabelObject(linkedeff)
	if resetflag and resetcount then
		e1:SetReset(resetflag,resetcount)
	elseif resetflag then
		e1:SetReset(resetflag)
	end
	e1:SetValue(function(ec,c,tp) return equipval(ec,c,tp) end)
	e1:SetOperation(function(c,e,tp,tc) equipop(c,e,tp,tc) end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(finalprop&~EFFECT_FLAG_CANNOT_DISABLE,EFFECT_FLAG2_MAJESTIC_MUST_COPY)
	e2:SetCode(89785779+EFFECT_EQUIP_LIMIT)
	if resetflag and resetcount then
		e2:SetReset(resetflag,resetcount)
	elseif resetflag then
		e2:SetReset(resetflag)
	end
	c:RegisterEffect(e2)
	linkedeff:SetLabelObject(e2)
end

function Auxiliary.EquipByEffectLimit(e,c)
	if e:GetOwner()~=c then return false end
	local eff={c:GetCardEffect(89785779+EFFECT_EQUIP_LIMIT)}
	for _,te in ipairs(eff) do
		if te==e:GetLabelObject() then return true end
	end
	return false
end
--register for "Equip to this card by its effect"
function Auxiliary.EquipByEffectAndLimitRegister(c,e,tp,tc,code,mustbefaceup)
	local up=false or mustbefaceup
	if not Duel.Equip(tp,tc,c,up) then return false end
	--Add Equip limit
	if code then
		tc:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,0)
	end
	local te=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(Auxiliary.EquipByEffectLimit)
	e1:SetLabelObject(te)
	tc:RegisterEffect(e1)
	return true
end

--add a anounce digit by digit
function Auxiliary.ComposeNumberDigitByDigit(tp,min,max)
	if min>max then min,max=max,min end
	local mindc=#tostring(min)
	local maxdc=#tostring(max)
	local dbdmin={}
	local dbdmax={}
	local mi=maxdc-1
	local aux=min
	for i=1,maxdc do
		dbdmin[i]=math.floor(aux/(10^mi))
		aux=aux%(10^mi)
		mi=mi-1
	end
	aux=max
	mi=maxdc-1
	for i=1,maxdc do
		dbdmax[i]=math.floor(aux/(10^mi))
		aux=aux%(10^mi)
		mi=mi-1
	end
	local chku=true
	local chkl=true
	local dbd={}
	mi=maxdc-1
	for i=1,maxdc do
		local maxval=9
		local minval=0
		if chku and i>1 and dbd[i-1]<dbdmax[i-1] then
			chku=false
		end
		if chkl and i>1 and dbd[i-1]>dbdmin[i-1] then
			chkl=false
		end
		if chku then
			maxval=dbdmax[i]
		end
		if chkl then
			minval=dbdmin[i]
		end
		local r={}
		local j=1
		for k=minval,maxval do
			r[j]=k
			j=j+1
		end
		dbd[i]=Duel.AnnounceNumber(tp,table.unpack(r))
		mi=mi-1
	end
	local number=0
	mi=maxdc-1
	for i=1,maxdc do
		number=number+dbd[i]*10^mi
		mi=mi-1
	end
	return number
end
function Card.GetToBeLinkedZone(tc,c,tp,clink,emz)
	local zone=0
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_MZONE) and tc:IsControler(tp) then
		if c:IsLinkMarker(LINK_MARKER_LEFT) and seq < 4 and (not clink or tc:IsLinkMarker(LINK_MARKER_RIGHT)) then zone=zone|(1<<seq+1) end
		if c:IsLinkMarker(LINK_MARKER_RIGHT) and seq > 0 and seq <= 4 and (not clink or tc:IsLinkMarker(LINK_MARKER_LEFT)) then zone=zone|(1<<seq-1) end
		if c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) and (seq == 5 or seq == 6) and (not clink or tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT)) then zone=zone|(1<<2*(seq-5)) end
		if c:IsLinkMarker(LINK_MARKER_TOP) and (seq == 5 or seq == 6) and (not clink or tc:IsLinkMarker(LINK_MARKER_BOTTOM)) then zone=zone|(1<<2*(seq-5)+1) end
		if c:IsLinkMarker(LINK_MARKER_TOP_LEFT) and (seq == 5 or seq == 6) and (not clink or tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT)) then zone=zone|(1<<2*(seq-5)+2) end
		if emz and c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) and (seq == 0 or seq == 2) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT)) then zone=zone|(1<<5+seq/2) end
		if emz and c:IsLinkMarker(LINK_MARKER_BOTTOM) and (seq == 1 or seq == 3) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP)) then zone=zone|(1<<5+(seq-1)/2) end
		if emz and c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) and (seq == 2 or seq == 4) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_LEFT)) then zone=zone|(1<<5+(seq-2)/2) end
	elseif tc:IsLocation(LOCATION_MZONE) then
		if c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) and (seq == 5 or seq == 6 or (emz and (seq == 0 or seq == 2))) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT)) then
			if seq == 5 or seq == 6 then
				zone=zone|(1<<-2*(seq-5)+2)
			else
				zone=zone|(1<<-seq/2+6)
			end
		end
		if c:IsLinkMarker(LINK_MARKER_TOP) and (seq == 5 or seq == 6 or (emz and (seq == 1 or seq == 3))) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP)) then
			if seq == 5 or seq == 6 then
				zone=zone|(1<<-2*(seq-5)+3)
			else
				zone=zone|(1<<-(seq-1)/2+6)
			end
		end
		if c:IsLinkMarker(LINK_MARKER_TOP_LEFT) and (seq == 2 or seq == 4 or (emz and (seq == 2 or seq == 4))) and (not clink or tc:IsLinkMarker(LINK_MARKER_TOP_LEFT)) then
			if seq == 5 or seq == 6 then
				zone=zone|(1<<-2*(seq-5)+4)
			else
				zone=zone|(1<<-(seq-2)/2+6)
			end
		end
	end
	return zone
end
function Group.GetToBeLinkedZone(g,c,tp,clink,emz)
	local zone=0
	for tc in aux.Next(g) do
		zone=zone|tc:GetToBeLinkedZone(c,tp,clink,emz)
	end
	return zone
end
function Auxiliary.ResetEffects(g,eff)
	for c in aux.Next(g) do
		local effs={c:GetCardEffect(eff)}
		for _,v in ipairs(effs) do
			v:Reset()
		end
	end
end
Auxiliary.CalledTokens={}
function Auxiliary.CallToken(code)
	if not Auxiliary.CalledTokens[code] then
		Auxiliary.CalledTokens[code]=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_ADJUST)
		ge:SetCountLimit(1)
		ge:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge:SetOperation(function()
			Duel.CreateToken(0,code)
			Duel.CreateToken(1,code)
		end)
		Duel.RegisterEffect(ge,0)
	end
end
--utility entry for SelectUnselect loops
--returns bool if chk==0, returns Group if chk==1
function Auxiliary.SelectUnselectLoop(c,sg,mg,e,tp,minc,maxc,rescon)
	local res
	if sg:GetCount()>=maxc then return false end
	sg:AddCard(c)
	if sg:GetCount()<minc then
		res=mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	elseif sg:GetCount()<maxc then
		res=(not rescon or rescon(sg,e,tp,mg)) or mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	else
		res=(not rescon or rescon(sg,e,tp,mg))
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SelectUnselectGroup(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,cancelcon,breakcon)
	local minc=minc and minc or 1
	local maxc=maxc and maxc or 99
	if chk==0 then return g:IsExists(Auxiliary.SelectUnselectLoop,1,nil,Group.CreateGroup(),g,e,tp,minc,maxc,rescon) end
	local hintmsg=hintmsg and hintmsg or 0
	local sg=Group.CreateGroup()
	while true do
		local cancel=sg:GetCount()>=minc and (not cancelcon or cancelcon(sg,e,tp,g))
		local mg=g:Filter(Auxiliary.SelectUnselectLoop,sg,sg,g,e,tp,minc,maxc,rescon)
		if (breakcon and breakcon(sg,e,tp,mg)) or mg:GetCount()<=0 or sg:GetCount()>=maxc then break end
		Duel.Hint(HINT_SELECTMSG,seltp,hintmsg)
		local tc=mg:SelectUnselect(sg,seltp,cancel,cancel)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
	end
	return sg
end
--check for free Zone for monsters to be Special Summoned except from Extra Deck
function Auxiliary.MZFilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(tp)
end
--check for Free Monster Zones
function Auxiliary.ChkfMMZ(sumcount)
	return	function(sg,e,tp,mg)
				return sg:FilterCount(Auxiliary.MZFilter,nil,tp)+Duel.GetLocationCount(tp,LOCATION_MZONE)>=sumcount
			end
end
--check for cards that can stay on the field, but not always
function Auxiliary.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(Auxiliary.RemainFieldDisabled)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function Auxiliary.RemainFieldDisabled(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	e:GetOwner():CancelToGrave(false)
end
--autocheck for Summoning a Group containing Extra Deck/non-Extra Deck monsters to avoid zone issues
function Auxiliary.MainAndExtraSpSummonLoop(func,sumtype,sump,targetp,nocheck,nolimit,pos,mmz,emz)
	return	function(e,tp,eg,ep,ev,re,r,rp,sg)
				local pos=pos or POS_FACEUP
				local summonp=math.abs(sump-tp)
				local targettp=math.abs(targetp-tp)
				if Duel.GetMasterRule()>=4 then
					local cardtable={}
					local cc=sg:GetFirst()
					while cc do
						table.insert(cardtable,cc)
						cc=sg:GetNext()
					end
					local cardtableclone={table.unpack(cardtable)}
					local mmz=mmz
					if not mmz then
						mmz=0
						for i=0,4 do
							if Duel.GetLocationCount(targettp,LOCATION_MZONE,targettp,LOCATION_REASON_TOFIELD,0x1<<i)>0 then
								mmz=mmz|(0x1<<i)
							end
						end
					end
					if mmz<=0 then return false end
					local emz=emz
					if not emz then
						emz=Duel.GetLinkedZone(tp)
						if Duel.CheckLocation(targettp,LOCATION_MZONE,5) then
							emz=emz|0x20
						end
						if Duel.CheckLocation(targettp,LOCATION_MZONE,6) then
							emz=emz|0x40
						end
					end
					for _,tc in ipairs(cardtableclone) do
						table.remove(cardtable,1)
						local zone=Auxiliary.MainAndExtraGetSummonZones(tc,mmz,emz,e,sumtype,summonp,targettp,nocheck,nolimit,pos,table.unpack(cardtable))
						if zone==0 then return false end
						if not Duel.SpecialSummonStep(tc,sumtype,summonp,targettp,nocheck,nolimit,pos,zone) then return false end
						emz=emz&~(0x1<<tc:GetSequence())
						mmz=mmz&~(0x1<<tc:GetSequence())
						if func then
							func(e,tp,eg,ep,ev,re,r,rp,tc)
						end
					end
					Duel.SpecialSummonComplete()
					return true,sg
				else
					local mmz=mmz
					if not mmz then
						mmz=0x1f
					end
					local emz=emz
					if not emz then
						emz=0x1f
					end
					local tc=sg:GetFirst()
					while tc do
						local zone=tc:IsLocation(LOCATION_EXTRA) and emz or mmz
						if not Duel.SpecialSummonStep(tc,sumtype,summonp,targettp,nocheck,nolimit,pos,zone) then return false end
						if func then
							func(e,tp,eg,ep,ev,re,r,rp,tc)
						end
						tc=sg:GetNext()
					end
					Duel.SpecialSummonComplete()
					return true,sg
				end
			end
end
function Auxiliary.MainAndExtraGetSummonZones(c,mmz,emz,e,sumtype,sump,targetp,nocheck,nolimit,pos,nc,...)
	local zones=0
	if c:IsLocation(LOCATION_EXTRA) then
		for i=0,6 do
			local zone=0x1<<i
			if emz&zone==zone and c:IsCanBeSpecialSummoned(e,sumtype,sump,nocheck,nolimit,pos,targetp,zone) 
				and Auxiliary.MainAndExtraZoneCheckBool(nc,mmz&~zone,emz&~zone,e,sumtype,sump,targetp,nocheck,nolimit,pos,...) then
				zones=zones|zone
			end
		end
	else
		for i=0,4 do
			local zone=0x1<<i
			if mmz&zone==zone and c:IsCanBeSpecialSummoned(e,sumtype,sump,nocheck,nolimit,pos,targetp,zone) 
				and Auxiliary.MainAndExtraZoneCheckBool(nc,mmz&~zone,emz&~zone,e,sumtype,sump,targetp,nocheck,nolimit,pos,...) then
				zones=zones|zone
			end
		end
	end
	return zones
end
function Auxiliary.MainAndExtraZoneCheckBool(c,mmz,emz,e,sumtype,sump,targetp,nocheck,nolimit,pos,nc,...)
	if not c then return true end
	if c:IsLocation(LOCATION_EXTRA) then
		for i=0,6 do
			local zone=0x1<<i
			if emz&zone==zone and c:IsCanBeSpecialSummoned(e,sumtype,sump,nocheck,nolimit,pos,targetp,zone) 
				and Auxiliary.MainAndExtraZoneCheckBool(nc,mmz&~zone,emz&~zone,e,sumtype,sump,targetp,nocheck,nolimit,pos,...) then
				return true
			end
		end
	else
		for i=0,4 do
			local zone=0x1<<i
			if mmz&zone==zone and c:IsCanBeSpecialSummoned(e,sumtype,sump,nocheck,nolimit,pos,targetp,zone) 
				and Auxiliary.MainAndExtraZoneCheckBool(nc,mmz&~zone,emz&~zone,e,sumtype,sump,targetp,nocheck,nolimit,pos,...) then
				return true
			end
		end
	end
	return false
end
--condition for effects that make the monster change its current sequence
function Auxiliary.seqmovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():CheckAdjacent()
end
--operation for effects that make the monster change its current sequence
function Auxiliary.seqmovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	c:MoveAdjacent()
end

function loadutility(file)
	local f1 = loadfile("expansions/live2017links/script/"..file)
	local f2 = loadfile("expansions/script/"..file)
	if(f1 == nil and f2== nil) then
		dofile("script/"..file)
	elseif(f1 == nil) then
		f2()
	else
		f1()
	end
end
loadutility("proc_fusion.lua")
loadutility("proc_ritual.lua")
loadutility("proc_synchro.lua")
loadutility("proc_union.lua")
loadutility("proc_xyz.lua")
loadutility("proc_pendulum.lua")
loadutility("proc_link.lua")
loadutility("proc_equip.lua")
loadutility("proc_persistent.lua")
loadutility("proc_workaround.lua")
loadutility("proc_damage_fix.lua")
pcall(dofile,"init.lua")
