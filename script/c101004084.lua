--Revendread Evolution
--Scripted by Eerie Code
function c101004084.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101004084+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101004084.target)
	e1:SetOperation(c101004084.activate)
	c:RegisterEffect(e1)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
end
function c101004084.filter(c,e,tp,m)
	if not c:IsSetCard(0x106) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	local sg=Group.CreateGroup()
	return mg:IsExists(c101004084.checkRecursive,1,nil,c,tp,sg,mg)
end
function c101004084.checkRecursive(c,rc,tp,sg,mg)
	sg:AddCard(c)
	local res=sg:GetSum(Card.GetRitualLevel,rc)<=rc:GetLevel() 
		and (c101004084.checkGoal(tp,sg,rc) or mg:IsExists(c101004084.checkRecursive,1,sg,rc,tp,sg,mg))
	sg:RemoveCard(c)
	return res
end
function c101004084.checkGoal(tp,sg,rc)
	return sg:GetSum(Card.GetRitualLevel,rc)==rc:GetLevel() --sg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),1,rc:GetLevel(),rc)
		and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and aux.ReleaseCheckMMZ(sg,tp)
end
function c101004084.exfilter0(c)
	return c:IsSetCard(0x106) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c101004084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(c101004084.exfilter0,tp,LOCATION_DECK,0,nil)
		mg:Merge(sg)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c101004084.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101004084.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local sg=Duel.GetMatchingGroup(c101004084.exfilter0,tp,LOCATION_DECK,0,nil)
	mg:Merge(sg)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101004084.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,ft)
	local rc=tg:GetFirst()
	if rc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,rc,rc)
		if rc.mat_filter then
			mg=mg:Filter(rc.mat_filter,nil)
		end
		local mat=Group.CreateGroup()
		while true do
			local cg=mg:Filter(c101004084.checkRecursive,mat,rc,tp,mat,mg)
			if #cg==0 then break end
			local tc=Group.SelectUnselect(cg,mat,tp,c101004084.checkGoal(tp,mat,rc),false,1,1)
			if not tc then break end
			if not mat:IsContains(tc) then
				mat=mat+tc
			else
				mat=mat-tc
			end
		end
		rc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		rc:CompleteProcedure()
		rc:RegisterFlagEffect(101004084,RESET_EVENT+0x1fe0000,0,1,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(rc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCondition(c101004084.descon)
		e1:SetOperation(c101004084.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101004084.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel() and e:GetLabelObject():GetFlagEffect(101004084)~=0
end
function c101004084.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
