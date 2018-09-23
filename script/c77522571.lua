--デストーイ・マイスター
--Frightfur Meister
--Scripted by Eerie Code
function c77522571.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsummon (pendulum)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77522571,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,77522571)
	e1:SetCost(c77522571.cost)
	e1:SetTarget(c77522571.sptg1)
	e1:SetOperation(c77522571.spop1)
	c:RegisterEffect(e1)
	--spsummon (deck)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77522571,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,77522572)
	e2:SetTarget(c77522571.sptg2)
	e2:SetOperation(c77522571.spop2)
	c:RegisterEffect(e2)
	--spsummon (deck)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77522571,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,77522573)
	e3:SetCost(c77522571.cost)
	e3:SetTarget(c77522571.extg)
	e3:SetOperation(c77522571.exop)
	c:RegisterEffect(e3)
end
function c77522571.fright_unit(c)
	return c:IsSetCard(0xa9) or c:IsSetCard(0xc3) or c:IsSetCard(0xad)
end
function c77522571.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c77522571.spcfilter1(c)
	return c:IsFaceup() and c77522571.fright_unit(c) and c:IsLevelBelow(4)
end
function c77522571.spfilter1(c,e,tp)
	return c:IsRace(RACE_FIEND) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77522571.spkfilter1(c,rc)
	return c:IsLevel(rc:GetLevel()) and not c:IsCode(rc:GetCode())
end
function c77522571.spcheck1(sg,tp,exg,mg)
	return aux.ReleaseCheckMMZ(sg,tp) and mg:IsExists(c77522571.spkfilter1,1,nil,sg:GetFirst())
end
function c77522571.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c77522571.spfilter1,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupCost(tp,c77522571.spcfilter1,1,false,c77522571.spcheck1,nil,mg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mg=Duel.SelectReleaseGroupCost(tp,c77522571.spcfilter1,1,1,false,c77522571.spcheck1,nil,mg)
	e:SetLabelObject(mg:GetFirst())
	Duel.Release(mg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77522571.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local rc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(c77522571.spfilter1,tp,LOCATION_DECK,0,nil,e,tp):Filter(c77522571.spkfilter1,nil,rc)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77522571.spfilter2(c,e,tp)
	return c77522571.fright_unit(c) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77522571.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77522571.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77522571.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c77522571.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77522571.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c77522571.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c77522571.excfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c77522571.exfilter(c,e,tp)
	return c:IsSetCard(0xad) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c77522571.exkfilter(c,sg,tp)
	return Duel.GetLocationCountFromEx(tp,tp,sg,c)>0 and c:IsLevel(sg:GetSum(Card.GetOriginalLevel))
end
function c77522571.excheck(sg,tp,exg,mg)
	return mg:IsExists(c77522571.exkfilter,1,nil,sg,tp)
end
function c77522571.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c77522571.exfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupCost(tp,c77522571.excfilter,2,false,c77522571.excheck,nil,mg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupCost(tp,c77522571.excfilter,2,99,false,c77522571.excheck,nil,mg)
	e:SetLabel(g:GetSum(Card.GetOriginalLevel))
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c77522571.exop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	local g=Duel.GetMatchingGroup(c77522571.exfilter,tp,LOCATION_EXTRA,0,nil,e,tp):Filter(Card.IsLevel,nil,e:GetLabel())
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

