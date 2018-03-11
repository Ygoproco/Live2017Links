--デス・デンドル
function c12965761.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsCode,46571052),true)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12965761,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c12965761.tkcon)
	e1:SetTarget(c12965761.tktg)
	e1:SetOperation(c12965761.tkop)
	c:RegisterEffect(e1)
end
function c12965761.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsUnionState(e) and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function c12965761.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c12965761.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12965762,0,0x4011,800,800,1,RACE_PLANT,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,12965762)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
