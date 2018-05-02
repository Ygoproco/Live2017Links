--Revendread Evolution
--Scripted by Eerie Code
function c7986397.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7986397+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c7986397.target)
	e1:SetOperation(c7986397.activate)
	c:RegisterEffect(e1)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
end
function c7986397.filter(c,e,tp,m1,m2,ft)
	if not c:IsSetCard(0x106) or (c:GetType()&0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local lv=c:GetLevel()
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	local mg2=m2:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
		mg2=mg2:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,1,99999,c) or mg2:IsExists(function(c,spc)Duel.SetSelectedCard(c)return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99999,spc)end,nil,1,c)
	else
		return mg:IsExists(Auxiliary.RPEFilterF,1,nil,tp,mg,c,lv) or mg:Filter(function(c)
																				return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
																				end,nil):IsExists(function(c,spc)
																									return mg2:IsExists(function(c,fc)
																														Duel.SetSelectedCard(Group.FromCards(c,fc))
																														return mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99999,spc)
																														end,1,nil,c)
																									end,1,nil,c)
	end
end
function c7986397.checkvalid(c,rc,tp,sg,mg,mg2,ft)
	local deck = (mg2-sg)<mg2
	if mg2:IsContains(c) and deck then return false end
	local lv=rc:GetLevel()
	local res
	if ft<1 and not sg:IsExists(function(c)
		return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
		end,1,nil) then
		return mg:Filter(function(c)
						return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
						end,nil):IsExists(function(c2)
											Duel.SetSelectedCard(sg+c+c2)
											local res2 = mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99999,rc)
											if not res2 and not deck then
												Duel.SetSelectedCard(sg+c+c2)
												res2=(mg+mg2):CheckWithSumEqual(Card.GetRitualLevel,lv,0,99999,rc)
											end
											return res2
										end,1,nil)
		
	else
		Duel.SetSelectedCard(sg+c)
		res=mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99999,rc)
		if not res and not deck and not mg2:IsContains(c) then
			for tc in aux.Next(mg2) do
				Duel.SetSelectedCard(sg+c+tc)
				res=mg:CheckWithSumEqual(Card.GetRitualLevel,lv,0,99999,rc)
			if res then return res end
			end
		end
	end
	return res
end
function c7986397.exfilter0(c)
	return c:IsSetCard(0x106) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c7986397.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(c7986397.exfilter0,tp,LOCATION_DECK,0,nil)-mg
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c7986397.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,sg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c7986397.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local sg=Duel.GetMatchingGroup(c7986397.exfilter0,tp,LOCATION_DECK,0,nil)-mg
	local full=mg+sg
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c7986397.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,sg,ft)
	local rc=tg:GetFirst()
	if rc then
	local lv=rc:GetLevel()
		full=full:Filter(Card.IsCanBeRitualMaterial,rc,rc)
		if rc.mat_filter then
			full=full:Filter(rc.mat_filter,nil)
		end
		local mat=Group.CreateGroup()
		while true do
			local cg=full:Filter(c7986397.checkvalid,mat,rc,tp,mat,mg,sg,ft)
			if #cg==0 then break end
			local cancelable=(function()Duel.SetSelectedCard(mat)return Group.CreateGroup():CheckWithSumEqual(Card.GetRitualLevel,lv,0,0,rc)end)() and (ft>0 or mat:IsExists(function(c)
																																						return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
																																						end,1,nil))
			local tc=cg:SelectUnselect(mat,tp,cancelable,cancelable,1,1)
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
		rc:RegisterFlagEffect(7986397,RESET_EVENT+0x1fe0000,0,1,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(rc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCondition(c7986397.descon)
		e1:SetOperation(c7986397.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c7986397.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel() and e:GetLabelObject():GetFlagEffect(7986397)~=0
end
function c7986397.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
