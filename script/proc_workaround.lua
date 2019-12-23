--Utilities to be added to the core
function Card.IsInMainMZone(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and (not tp or c:IsControler(tp))
end
function Card.IsInExtraMZone(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()>4 and (not tp or c:IsControler(tp))
end
function GetID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local scard=_G[str]
    local s_id=tonumber(string.sub(str,2))
    return scard,s_id
end
function Card.IsNonEffectMonster(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT)
end

local syncheck = Card.IsSynchroSummonable
Card.IsSynchroSummonable=function(c,tun,mg,min,max)
	Auxiliary.SynchroSummonMinCount = min
	Auxiliary.SynchroSummonMaxCount = max
	local res = syncheck(c,tun,mg)
	Auxiliary.SynchroSummonMinCount = nil
	Auxiliary.SynchroSummonMaxCount = nil
	return res
end
local synsum = Duel.SynchroSummon
Duel.SynchroSummon=function(tp,syn,tun,g,min,max)
	Auxiliary.SynchroSummonMinCount = min
	Auxiliary.SynchroSummonMaxCount = max
	local res = synsum(tp,syn,tun,g)
	Auxiliary.SynchroSummonMinCount = nil
	Auxiliary.SynchroSummonMaxCount = nil
	return res
end

local chkoverlay=Duel.CheckRemoveOverlayCard
Duel.CheckRemoveOverlayCard=function(player, self, opponent, count, reason, group)
	if not group then
		return chkoverlay(player, self, opponent, count, reason)
	end
	local dg=Group.CreateGroup()
	group:ForEach(function(c)dg:Merge(c:GetOverlayGroup())end)
	return #dg>=count
end

local removerlay=Duel.RemoveOverlayCard
Duel.RemoveOverlayCard=function(player, self, opponent, min, max, reason, group)
	if not group then
		return removerlay(player, self, opponent, min, max, reason)
	end
	local dg=Group.CreateGroup()
	group:ForEach(function(c)dg:Merge(c:GetOverlayGroup())end)
	local sg=dg:Select(player, min, max, nil)
	return Duel.SendtoGrave(sg,reason)
end

--workaround for gryphon while update not happen and fix that (credits to cc/l)
local ils = Card.IsLinkState
Card.IsLinkState = function(c)
    return ils(c) or Duel.IsExistingMatchingCard(function(c,tc)return c:IsFaceup() and c:GetLinkedGroup():IsContains(tc) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end

--discard temp fix
function Duel.DiscardHand(player,filter,min,max,reason,excluded,...)
    local desc = reason & REASON_DISCARD and 501 or 504
    Duel.Hint(HINT_SELECTMSG, player, desc)
    local g=Duel.SelectMatchingCard(player,filter,player,LOCATION_HAND,0,min,max,excluded,...)
    if(#g==0) then
        return 0
    end
    return Duel.SendtoGrave(g,reason)
end

--things needed for steelswarm origin
local iscanc=Card.IsCanBeSpecialSummoned
Card.IsCanBeSpecialSummoned=function(...)
	local c=...
	local prev=aux.SummoningCard
	local preve=aux.ExtraSummon
	aux.SummoningCard=c
	if c:IsLocation(LOCATION_EXTRA) then
		aux.ExtraSummon=true
	end
	local res=iscanc(...)
	aux.ExtraSummon=preve
	aux.SummoningCard=prev
	return res
end
local iscan=Duel.IsCanBeSpecialSummoned
Duel.IsCanBeSpecialSummoned=function(c,...)
	local prev=aux.SummoningCard
	local preve=aux.ExtraSummon
	aux.SummoningCard=c
	if c:IsLocation(LOCATION_EXTRA) then
		aux.ExtraSummon=true
	end
	local res=iscan(c,...)
	aux.ExtraSummon=preve
	aux.SummoningCard=prev
	return res
end
local spstep = Duel.SpecialSummonStep
Duel.SpecialSummonStep = function(c,...)
	local prev=aux.SummoningCard
	local preve=aux.ExtraSummon
	aux.SummoningCard=c
	aux.ExtraSummon = c:IsLocation(LOCATION_EXTRA)
	local res = spstep(c,...)
	aux.ExtraSummon = preve
	aux.SummoningCard=prev
	return res
end
local spsum=Duel.SpecialSummon
Duel.SpecialSummon=function(o,...)
	local g1=(Group.CreateGroup()+o):Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	local g2=(Group.CreateGroup()+o)-g1
	if #g1 == 0 then
		return spsum(o,...)
	end
	local count = 0
	for c in aux.Next(g1) do
		if Duel.SpecialSummonStep(c,...) then
			count = count + 1
		end
	end
	for c in aux.Next(g2) do
		if Duel.SpecialSummonStep(c,...) then
			count = count + 1
		end
	end
	Duel.SpecialSummonComplete()
	return count
end
local lcex=Duel.GetLocationCountFromEx
Duel.GetLocationCountFromEx=function(...)
	local tp,rtp,sg,sc=...
	local prev=aux.SummoningCard
	local preve=aux.ExtraSummon
	aux.SummoningCard=sc
	aux.ExtraSummon=true
	local res = lcex(...)
	aux.ExtraSummon=preve
	aux.SummoningCard=prev
	return res
end

local fsets = Card.IsFusionSetCard
local fgets = Card.GetFusionSetCard
local fsetc = Card.IsFusionCode
local fgetc = Card.GetFusionCode
local tmp = function(set,func)
	return function(...)
		local prev = aux.linkset
		aux.linkset=set
		local res = {func(...)}
		aux.linkset = prev
		return table.unpack(res)
	end
end
Card.IsFusionSetCard = tmp(false,fsets)
Card.IsLinkSetCard = tmp(true,fsets)
Card.GetFusionSetCard = tmp(false,fgets)
Card.GetLinkSetCard = tmp(true,fgets)
Card.IsFusionCode = tmp(false,fsetc)
Card.IsLinkCode = tmp(true,fsetc)
Card.GetFusionCode = tmp(false,fgetc)
Card.GetLinkCode = tmp(true,fgetc)
tmp = nil

local geff=Effect.GlobalEffect
function Effect.GlobalEffect()
	if not aux.penreg then
		aux.penreg = true
		registerpendulum()
	end
	return geff()
end
local neweff=Effect.CreateEffect
function Effect.CreateEffect(c)
	if not aux.penreg then
		aux.penreg = true
		registerpendulum()
	end
	return neweff(c)
end
--those effects have to be registered before anyting else, in this way we can be sure they will always be called first when checking the conditions, so the global variables can be set
function registerpendulum()
	local e1=geff()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(function() return aux.SummoningGroup end)
	e1:SetValue(function(e)
		if not aux.SummoningCard then
			aux.SummoningCard=aux.SummoningGroup:GetFirst()
		else
			aux.SummoningCard=aux.SummoningGroup:GetNext()
		end
		return 0
	end)
	Duel.RegisterEffect(e1,0)
	local e2=geff()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FORCE_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(function() return aux.SummoningGroup end)
	e2:SetLabel(0)
	e2:SetValue(function(e)
		if aux.SummoningCard and (e:GetLabel()==0 or (aux.SummoningCard:IsLocation(LOCATION_EXTRA) and e:GetLabel()==1)) then
			aux.ExtraSummon=true
		else
			aux.ExtraSummon=false
		end
		e:SetLabel((e:GetLabel()+1)%3)
		return 0xffffffff
	end)
	Duel.RegisterEffect(e2,0)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)if aux.SummoningGroup then aux.SummoningGroup:DeleteGroup() aux.SummoningGroup=nil end end)
	Duel.RegisterEffect(e1,0)
	local e1=geff()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e1:SetCondition(function()
						return aux.MR41 and
							(aux.ExtraSummon and aux.SummoningCard
							and not (aux.SummoningCard:IsType(TYPE_LINK) or (aux.SummoningCard:IsType(TYPE_PENDULUM) and aux.SummoningCard:IsPosition(POS_FACEUP))))
						end)
	e1:SetValue(0xffffff)
	Duel.RegisterEffect(e1,0)
	local e1=geff()
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(function()
						aux.ExtraSummon=false
						aux.SummoningCard=nil
						return false
					end)
	Duel.RegisterEffect(e1,0)
end

--Lair of Darkness
function Auxiliary.ReleaseCostFilter(c,f,...)
	return c:IsFaceup() and c:IsReleasable() and c:IsHasEffect(59160188) 
		and (not f or f(c,table.unpack({...})))
end
function Auxiliary.ReleaseCheckSingleUse(sg,tp,exg)
    return #sg-#(sg-exg)<=1
end
function Auxiliary.ReleaseCheckMMZ(sg,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or sg:IsExists(aux.FilterBoolFunction(Card.IsInMainMZone,tp),1,nil)
end
function Auxiliary.ReleaseCheckTarget(sg,tp,exg,dg)
	return dg:IsExists(aux.TRUE,1,sg)
end
function Auxiliary.RelCheckRecursive(c,tp,sg,mg,exg,mustg,ct,minc,specialchk,...)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.RelCheckGoal(tp,sg,exg,mustg,ct,minc,specialchk,table.unpack({...})) 
		or (ct<minc and mg:IsExists(Auxiliary.RelCheckRecursive,1,sg,tp,sg,mg,exg,mustg,ct,minc,specialchk,table.unpack({...})))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.RelCheckGoal(tp,sg,exg,mustg,ct,minc,specialchk,...)
	return ct>=minc and (not specialchk or specialchk(sg,tp,exg,table.unpack({...}))) and sg:Includes(mustg)
end
function Duel.CheckReleaseGroupCost(tp,f,ct,use_hand,specialchk,ex,...)
	local params={...}
	if not ex then ex=Group.CreateGroup() end
	if not specialchk then specialchk=Auxiliary.ReleaseCheckSingleUse else specialchk=Auxiliary.AND(specialchk,Auxiliary.ReleaseCheckSingleUse) end
	local g=Duel.GetReleaseGroup(tp,use_hand)
	if f then
		g=g:Filter(f,ex,table.unpack(params))
	else
		g=g-ex
	end
	local exg=Duel.GetMatchingGroup(Auxiliary.ReleaseCostFilter,tp,0,LOCATION_MZONE,g+ex,f,table.unpack(params))
	local mustg=g:Filter(function(c,tp)return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)end,nil,tp)
	local mg=g+exg
	local sg=Group.CreateGroup()
	return mg:Includes(mustg) and mg:IsExists(Auxiliary.RelCheckRecursive,1,nil,tp,sg,mg,exg,mustg,0,ct,specialchk,table.unpack({...}))
end
function Duel.SelectReleaseGroupCost(tp,f,minc,maxc,use_hand,specialchk,ex,...)
	local params={...}
	if not ex then ex=Group.CreateGroup() end
	if not specialchk then specialchk=Auxiliary.ReleaseCheckSingleUse else specialchk=Auxiliary.AND(specialchk,Auxiliary.ReleaseCheckSingleUse) end
	local g=Duel.GetReleaseGroup(tp,use_hand)
	if f then
		g=g:Filter(f,ex,table.unpack(params))
	else
		g=g-ex
	end
	local exg=Duel.GetMatchingGroup(Auxiliary.ReleaseCostFilter,tp,0,LOCATION_MZONE,g+ex,f,table.unpack(params))
	local mg=g+exg
	local mustg=g:Filter(function(c,tp)return c:IsHasEffect(EFFECT_EXTRA_RELEASE) and c:IsControler(1-tp)end,nil,tp)
	local sg=Group.CreateGroup()
	local cancel=false
	sg:Merge(mustg)
	while #sg<maxc do
		local cg=mg:Filter(Auxiliary.RelCheckRecursive,sg,tp,sg,mg,exg,mustg,#sg,minc,specialchk,table.unpack({...}))
		if #cg==0 then break end
		cancel=#sg>=minc and #sg<=maxc and Auxiliary.RelCheckGoal(tp,sg,exg,mustg,#sg,minc,specialchk,table.unpack({...}))
		local tc=Group.SelectUnselect(cg,sg,tp,cancel,cancel,1,1)
		if not tc then break end
		if #mustg==0 or not mustg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg=sg+tc
			else
				sg=sg-tc
			end
		end
	end
	if #sg==0 then return sg end
	if #sg~=#(sg-exg) then
		--LoD is reset for the rest of the turn
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(59160188,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
	return sg
end

--Witch's Strike
local ns=Duel.NegateSummon
Duel.NegateSummon=function(g)
	ns(g)
	local ng = Group.CreateGroup()
	if userdatatype(g) == "Card" then
		if g:IsStatus(STATUS_SUMMON_DISABLED) then ng:AddCard(g) end
	else
		ng = g:Filter(Card.IsStatus,nil,STATUS_SUMMON_DISABLED)
	end
	if #ng>0 then
		local EVENT_SUMMON_NEGATED = EVENT_CUSTOM+36458064
		Duel.RaiseEvent(ng,EVENT_SUMMON_NEGATED,Effect.GlobalEffect(),0,0,0,0)
	end
end

--T.G. Tank Larva
local nt=Card.IsNotTuner
Card.IsNotTuner=function (c,sc,tp)
    local nte = c:GetCardEffect(EFFECT_NONTUNER)
    local val = nte and nte:GetValue() or nil
    if not val or type(val) == 'number' then
        return nt(c,sc,tp)
    else
        return val(c,sc,tp) or not c:IsType(TYPE_TUNER,sc,SUMMON_TYPE_SYNCHRO,tp)
    end
end

function Card.IsRitualMonster(c)
	local tp=TYPE_RITUAL+TYPE_MONSTER
	return c:GetType() & tp == tp
end
function Card.IsRitualSpell(c)
	local tp=TYPE_RITUAL+TYPE_SPELL
	return c:GetType() & tp == tp
end
function Card.IsOriginalCode(c,cd)
	return c:GetOriginalCode()==cd
end
function Card.IsOriginalCodeRule(c,cd)
    local c1,c2=c:GetOriginalCodeRule()
    return c1==cd or c2==cd
end
function Card.IsOriginalType(c,val)
	return c:GetOriginalType() & val == val
end
function Card.IsOriginalAttribute(c,val)
	return c:GetOriginalAttribute() & val == val
end
function Card.IsOriginalRace(c,val)
	return c:GetOriginalRace() & val == val
end
function Card.IsSummonPlayer(c,tp)
	return c:GetSummonPlayer()==tp
end
function Card.IsPreviousControler(c,tp)
	return c:GetPreviousControler()==tp
end
function Card.IsHasLevel(c)
	return c:GetLevel()>0
end
function Card.IsSummonLocation(c,loc)
	return c:GetSummonLocation()&loc~=0
end
function Duel.GetTargetCards(e)
	return Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
end

--Checks whether the card is located at any of the sequences passed as arguments.
function Card.IsSequence(c,...)
	local arg={...}
	local seq=c:GetSequence()
	for _,v in ipairs(arg) do
		if seq==v then return true end
	end
	return false
end

--for zone checking (zone is the zone, tp is referencial player)
function Auxiliary.IsZone(c,zone,tp)
	local rzone = c:IsControler(tp) and (1 <<c:GetSequence()) or (1 << (16+c:GetSequence()))
	if c:IsSequence(5,6) then
		rzone = rzone | (c:IsControler(tp) and (1 << (16 + 11 - c:GetSequence())) or (1 << (11 - c:GetSequence())))
	end
	return (rzone & zone) > 0
end

--Workaround for the Link Summon using opponent's monsters effect of the Hakai monsters
function Auxiliary.HakaiLinkFilter(c,e,tp,f,of)
	if not of(c) then return false end
	return Duel.IsExistingMatchingCard(Auxiliary.HakaiLinkSummonFilter(f),tp,LOCATION_EXTRA,0,1,nil,e:GetHandler(),c,tp)
end
function Auxiliary.HakaiLinkSummonFilter(f)
	return	function(c,mc,tc,tp)
				if not (c:IsType(TYPE_LINK) and c:IsLinkAbove(2)) then return false end
				if Duel.GetLocationCountFromEx(tp,tp,mc,c)<1 then return false end
				if f and not f(c) then return false end
				return mc:IsCanBeLinkMaterial(c,tp) and tc:IsCanBeLinkMaterial(c,tp) and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
			end
end
function Auxiliary.HakaiLinkExtra(chk,summon_type,e,...)
	local c=e:GetHandler()
	if chk==0 then
		local tp,sc=...
		if not summon_type==SUMMON_TYPE_LINK then
			return Group.CreateGroup()
		else
			return Group.FromCards(c)
		end
	end
end
function Auxiliary.HakaiLinkTarget(f,of)
	if not of then of=Card.IsFaceup else of=aux.FilterFaceupFunction(of) end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetTargetRange(LOCATION_MZONE,0)
				e1:SetTarget(function(e,c) return c~=e:GetHandler() end)
				e1:SetValue(1)
				Duel.RegisterEffect(e1,tp)
				local og=Duel.GetMatchingGroup(of,tp,0,LOCATION_MZONE,nil)
				local oeff={}
				for oc in aux.Next(og) do
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetRange(LOCATION_MZONE)
					e2:SetCode(EFFECT_EXTRA_MATERIAL)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetTargetRange(1,0)
					e2:SetValue(Auxiliary.HakaiLinkExtra)
					oc:RegisterEffect(e2,true)
					table.insert(oeff,e2)
				end
				if chkc then
					local b=chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and Auxiliary.HakaiLinkFilter(chkc,e,tp,f,of)
					e1:Reset()
					for _,oe in ipairs(oeff) do
						oe:Reset()
					end
					return b
				end
				if chk==0 then
					local b=Duel.IsExistingTarget(Auxiliary.HakaiLinkFilter,tp,0,LOCATION_MZONE,1,nil,e,tp,f,of)
					e1:Reset()
					for _,oe in ipairs(oeff) do
						oe:Reset()
					end
					return b
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
				Duel.SelectTarget(tp,Auxiliary.HakaiLinkFilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,f,of)
				e1:Reset()
				for _,oe in ipairs(oeff) do
					oe:Reset()
				end
			end
end
function Auxiliary.HakaiLinkOperation(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local tc=Duel.GetFirstTarget()
				if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)) then return end
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetTargetRange(LOCATION_MZONE,0)
				e1:SetTarget(function(e,c) return c~=e:GetHandler() end)
				e1:SetValue(1)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_EXTRA_MATERIAL)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,0)
				e2:SetValue(Auxiliary.HakaiLinkExtra)
				local reg = tc:RegisterEffect(e2,true)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,Auxiliary.HakaiLinkSummonFilter(f),tp,LOCATION_EXTRA,0,1,1,nil,c,tc,tp)
				if #g>0 then
					Duel.SpecialSummonRule(tp,g:GetFirst(),SUMMON_TYPE_LINK)
				end
				e1:Reset()
				if reg then
					e2:Reset()
				end
			end
end
function Effect.AddHakaiLinkEffect(e,f,of)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetTarget(Auxiliary.HakaiLinkTarget(f,of))
	e:SetOperation(Auxiliary.HakaiLinkOperation(f))
end

--Necessary for lighter handling of Dvergs, Generaid of Iron
function Group.GetClass(g,f,...)
    local t={}
    for tc in aux.Next(g) do
        table.insert(t,f(tc,table.unpack({...})))
    end
    return t
end

--Helpers to print hints for attribute-related cards such as Cynet Codec
function Auxiliary.BitSplit(v)
	local res={}
	local i=0
	while math.pow(2,i)<=v do
		local p=math.pow(2,i)
		if v & p~=0 then 
			table.insert(res,p)
		end
		i=i+1
	end
	return pairs(res)
end
function Auxiliary.GetAttributeStrings(v)
	local t = {
		[ATTRIBUTE_EARTH] = 1010,
		[ATTRIBUTE_WATER] = 1011,
		[ATTRIBUTE_FIRE] = 1012,
		[ATTRIBUTE_WIND] = 1013,
		[ATTRIBUTE_LIGHT] = 1014,
		[ATTRIBUTE_DARK] = 1015,
		[ATTRIBUTE_DEVINE] = 1016
	}
	local res={}
	local ct=0
	for _,att in Auxiliary.BitSplit(v) do
		if t[att] then
			table.insert(res,t[att])
			ct=ct+1
		end
	end
	return pairs(res)
end
function Auxiliary.GetRaceStrings(v)
	local t = {
		[RACE_WARRIOR] = 1020,
		[RACE_SPELLCASTER] = 1021,
		[RACE_FAIRY] = 1022,
		[RACE_FIEND] = 1023,
		[RACE_ZOMBIE] = 1024,
		[RACE_MACHINE] = 1025,
		[RACE_AQUA] = 1026,
		[RACE_PYRO] = 1027,
		[RACE_ROCK] = 1028,
		[RACE_WINDBEAST] = 1029,
		[RACE_PLANT] = 1030,
		[RACE_INSECT] = 1031,
		[RACE_THUNDER] = 1032,
		[RACE_DRAGON] = 1033,
		[RACE_BEAST] = 1034,
		[RACE_BEASTWARRIOR] = 1035,
		[RACE_DINOSAUR] = 1036,
		[RACE_FISH] = 1037,
		[RACE_SEASERPENT] = 1038,
		[RACE_REPTILE] = 1039,
		[RACE_PSYCHO] = 1040,
		[RACE_DEVINE] = 1041,
		[RACE_CREATORGOD] = 1042,
		[RACE_WYRM] = 1043,
		[RACE_CYBERSE] = 1044
	}
	local res={}
	local ct=0
	for _,att in Auxiliary.BitSplit(v) do
		if t[att] then
			table.insert(res,t[att])
			ct=ct+1
		end
	end
	return pairs(res)
end
