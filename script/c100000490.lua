--デステニー・オーバーレイ
function c100000490.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000490.target)
	e1:SetOperation(c100000490.activate)
	c:RegisterEffect(e1)
end
function c100000490.filter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and not c:IsType(TYPE_TOKEN)
end
function c100000490.xyzfilter(c,mg,sc,set)
	local reset={}
	if not set then
		local tc=mg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_XYZ_MATERIAL)
			tc:RegisterEffect(e1)
			table.insert(reset,e1)
			tc=g:GetNext()
		end
	end
	local res=c:IsXyzSummonable(mg,mg:GetCount(),mg:GetCount())
	for _,te in ipairs(reset) do
		te:Reset()
	end
	return res
end
function c100000490.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(c100000490.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg,e:GetHandler())
end
function c100000490.rescon2(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(c100000490.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg,e:GetHandler(),true)
end
function c100000490.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c100000490.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return aux.SelectUnselectGroup(mg,e,tp,nil,nil,c100000490.rescon,0) end
	local reset={}
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_XYZ_MATERIAL)
		tc:RegisterEffect(e1)
		table.insert(reset,e1)
		tc=g:GetNext()
	end
	local tg=aux.SelectUnselectGroup(mg,e,tp,nil,nil,c100000490.rescon2,1,tp,HINTMSG_XMATERIAL,c100000490.rescon2)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	for _,te in ipairs(reset) do
		te:Reset()
	end
end
function c100000490.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_MATERIAL)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local xyzg=Duel.GetMatchingGroup(c100000490.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,e:GetHandler(),true)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
