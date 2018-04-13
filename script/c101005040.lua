--ショートヴァレル・ドラゴン
--Miniborrel Dragon
function c101005040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x102),2,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101005040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101005040)
	e1:SetCondition(c101005040.condition)
	e1:SetTarget(c101005040.target)
	e1:SetOperation(c101005040.operation)
	c:RegisterEffect(e1)
end
function c101005040.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10f) and c:IsType(TYPE_LINK)
end
function c101005040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101005040.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101005040.rfilter(c)
	return c:IsLinkBelow(3)
end
function c101005040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.CheckReleaseGroupCost(tp,c101005040.rfilter,1,false,aux.ReleaseCheckMMZ,nil) end
	local rg=Duel.SelectReleaseGroupCost(tp,c101005040.rfilter,1,1,false,aux.ReleaseCheckMMZ,nil)
	local r=rg:GetFirst()
	local lk=r:GetLink()
	e:SetLabel(lk)
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101005040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(c101005040.lnklimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabel(e:GetLabel())
		c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function c101005040.lnklimit(e,c)
	if not c then return false end
	return c:IsLink(e:GetLabel())
end
