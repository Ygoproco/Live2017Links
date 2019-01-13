--超戦士の萌芽
function c45948430.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45948430+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c45948430.target)
	e1:SetOperation(c45948430.activate)
	c:RegisterEffect(e1)
end
function c45948430.filter(c,e,tp)
	if not c:IsSetCard(0x10cf) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	return Duel.IsExistingMatchingCard(c45948430.matfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,tp,c)
end
function c45948430.matfilter1(c,tp,rc)
	local loc=(LOCATION_HAND+LOCATION_DECK)-c:GetLocation()
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToGrave() and c:IsCanBeRitualMaterial(rc)
		and Duel.IsExistingMatchingCard(c45948430.matfilter2,tp,loc,0,1,nil,c,tp,rc)
end
function c45948430.matfilter2(c,gc,tp,rc)
	local mg=Group.FromCards(c,gc)
	Duel.SetSelectedCard(mg)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and ((c:GetAttribute()|gc:GetAttribute())&(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)) == (ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and c:IsAbleToGrave() and c:IsCanBeRitualMaterial(rc) and mg:CheckWithSumEqual(Card.GetRitualLevel,8,0,99999,rc) 
end
function c45948430.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c45948430.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c45948430.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c45948430.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local rc=rg:GetFirst()
	if rc then
		local mg = Duel.GetMatchingGroup(c45948430.matfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,rc,tp,rc)
		mat = Group.CreateGroup()
		while true do
			local cg
			if #mat==0 then
				cg=mg:Filter(c45948430.matfilter1,nil,tp,rc)
			elseif #mat==1 then
				cg=mg:Filter(c45948430.matfilter2,nil,mat:GetFirst(),tp,rc):Filter(aux.NOT(Card.IsLocation),nil,mat:GetFirst():GetLocation())
			else
				break
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc=cg:SelectUnselect(mat,tp,false,false,1,2)
			if not tc then break end
			if not mat:IsContains(tc) then
				mat=mat+tc
			else
				mat=mat-tc
			end
		end
		rc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		rc:CompleteProcedure()
	end
end
