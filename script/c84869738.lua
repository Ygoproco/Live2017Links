--覇王の逆鱗
function c84869738.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c84869738.condition)
	e1:SetTarget(c84869738.target)
	e1:SetOperation(c84869738.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c84869738.mattg)
	e2:SetOperation(c84869738.matop)
	c:RegisterEffect(e2)
end
function c84869738.cfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c84869738.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c84869738.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c84869738.desfilter(c)
	return not c84869738.cfilter(c)
end
function c84869738.mzfilter(c)
	return c:GetSequence()<5
end
function c84869738.spfilter(c,e,tp)
	return c:IsSetCard(0x20f8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c84869738.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c84869738.desfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>-g:FilterCount(c84869738.mzfilter,nil) then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
		if Duel.GetLocationCountFromEx(tp,tp,g)>0 then loc=loc+LOCATION_EXTRA end
		return g:GetCount()>0 and loc~=0
			and Duel.IsExistingMatchingCard(c84869738.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c84869738.rescon(mft,exft,ft)
	return	function(sg,e,tp,mg)
				local exct=sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
				local mct=sg:FilterCount(aux.NOT(Card.IsLocation),nil,LOCATION_EXTRA)
				return exft>=exct and mft>=mct and ft>=sg:GetCount() and sg:GetClassCount(Card.GetCode)>=sg:GetCount()
			end
end
function c84869738.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c84869738.desfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=math.min(Duel.GetUsableMZoneCount(tp),4)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect then ft2=math.min(ft2,ect) end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c84869738.spfilter),tp,loc,0,nil,e,tp)
	if sg:GetCount()==0 then return end
	local rg=aux.SelectUnselectGroup(sg,e,tp,nil,ft,c84869738.rescon(ft1,ft2,ft),1,tp,HINTMSG_SPSUMMON,c84869738.rescon(ft1,ft2,ft))
	aux.MainAndExtraSpSummonLoop(nil,0,0,0,true,false)(e,tp,eg,ep,ev,re,r,rp,rg)
end
function c84869738.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20f8) and c:IsType(TYPE_XYZ)
end
function c84869738.matfilter(c)
	return c:IsSetCard(0x20f8) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c84869738.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c84869738.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84869738.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c84869738.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c84869738.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c84869738.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c84869738.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
