--古生代化石竜 スカルギオス
function c100000029.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	c100000029.min_material_count=2
	c100000029.max_material_count=2
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c100000029.fcon)
	e0:SetOperation(c100000029.fop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100000029.splimit)
	c:RegisterEffect(e1)
	--atk/def swap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000029,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100000029.attg)
	e2:SetOperation(c100000029.atop)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
end
function c100000029.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(100000025)
end
function c100000029.filter1(c,tp)
	return (c:IsRace(RACE_ROCK) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)) or c:IsHasEffect(511002961)
end
function c100000029.filter2(c,tp)
	return (c:IsLevelAbove(8) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(1-tp)) or c:IsHasEffect(511002961)
end
function c100000029.ffilter(c,fc,tp)
	if not c:IsCanBeFusionMaterial(fc) then return false end
	return c100000029.filter1(c,tp) or c100000029.filter2(c,tp)
end
function c100000029.FCheckGoal(tp,sg,fc)
	local g=Group.CreateGroup()
	return sg:IsExists(c100000029.FCheck,1,nil,tp,sg,g,c100000029.filter1,c100000029.filter2) and Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0
		and (not aux.FCheckAdditional or aux.FCheckAdditional(tp,sg,fc))
end
function c100000029.FCheck(c,tp,mg,sg,fun1,fun2)
	if fun2 then
		sg:AddCard(c)
		mg:RemoveCard(c)
		local res=fun1(c,tp) and mg:IsExists(c100000029.FCheck,1,sg,tp,mg,sg,fun2)
		sg:RemoveCard(c)
		mg:AddCard(c)
		return res
	else
		return fun1(c,tp)
	end
end
function c100000029.filterchk(c,tp,mg,sg,fc)
	sg:AddCard(c)
	mg:RemoveCard(c)
	local res
	local rg=Group.CreateGroup()
	if c:IsHasEffect(73941492+TYPE_FUSION) then
		local eff={c:GetCardEffect(73941492+TYPE_FUSION)}
		for i=1,#eff do
			local f=eff[i]:GetValue()
			if sg:IsExists(aux.TuneMagFilter,1,c,eff[i],f) then
				mg:Merge(rg)
				return false
			end
			local sg2=sg:Filter(function(c) return not aux.TuneMagFilterFus(c,eff[i],f) end,nil)
			rg:Merge(sg2)
			mg:Sub(sg2)
		end
	end
	if sg:GetCount()<2 then
		res=mg:IsExists(c100000029.filterchk,1,tp,mg,sg,fc)
	else
		res=c100000029.FCheckGoal(tp,sg,fc)
	end
	sg:RemoveCard(c)
	mg:AddCard(c)
	mg:Merge(rg)
	return res
end
function c100000029.fcon(e,g,gc,chkfnf)
	if g==nil then return true end
	local tp=e:GetHandlerPlayer()
	local mg=g:Filter(c100000029.ffilter,c,c,tp)
	if gc then
		if not mg:IsContains(gc) then return false end
		return c100000029.filterchk(gc,tp,mg,Group.CreateGroup(),fc)
	end
	local sg=Group.CreateGroup()
	return mg:IsExists(c100000029.filterchk,1,nil,tp,mg,sg,c)
end
function c100000029.fop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local tp=e:GetHandlerPlayer()
	local mg=eg:Filter(c100000029.ffilter,c,c,tp)
	local p=tp
	local sfhchk=false
	if Duel.IsPlayerAffectedByEffect(tp,511004008) and Duel.SelectYesNo(1-tp,65) then
		p=1-tp Duel.ConfirmCards(1-tp,mg)
		if mg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then sfhchk=true end
	end
	local sg=Group.CreateGroup()
	if gc then
		sg:AddCard(gc)
		if gc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={gc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				mg=mg:Filter(Auxiliary.TuneMagFilterFus,gc,eff[i],f)
			end
		end
		local tc
		while not tc or tc==gc do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
			tc=Group.SelectUnselect(mg:Filter(c100000029.filterchk,sg,tp,mg,sg,c),sg,p)
		end
		sg:AddCard(tc)
	else
		local g1=mg:Filter(c100000029.filter1,nil,tp)
		local g2=mg:Filter(c100000029.filter2,nil,tp)
		::start::
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		sg=g1:FilterSelect(p,c100000029.filterchk,1,1,nil,tp,g2,sg,c)
		local sc=sg:GetFirst()
		if sc:IsHasEffect(73941492+TYPE_FUSION) then
			local eff={sc:GetCardEffect(73941492+TYPE_FUSION)}
			for i=1,#eff do
				local f=eff[i]:GetValue()
				g2=g2:Filter(Auxiliary.TuneMagFilterFus,sc,eff[i],f)
			end
		end
		::sec::
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_FMATERIAL)
		local sc2=Group.SelectUnselect(g2:Filter(c100000029.filterchk,sg,tp,mg,sg,c),sg,p,true,true)
		if not sc2 then goto start end
		if sg:IsContains(sc2) then goto sec end
		sg:AddCard(sc2)
	end
	if sfhchk then Duel.ShuffleHand(tp) end
	if gc then sg:RemoveCard(gc) end
	Duel.SetFusionMaterial(sg)
end
function c100000029.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttackTarget()
	if chkc then return tg and chkc==tg end
	if chk==0 then return tg and tg:IsFaceup() and tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c100000029.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e2)
	end
end
