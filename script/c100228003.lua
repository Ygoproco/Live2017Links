--撃滅龍 ダーク・アームド
--Dark Armed, the Annihilator Dragon
--Scripted by ahtelel
function c100228003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2,c100228003.ovfilter,aux.Stringid(100228003,0),99,c100228003.xyzop)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(100228003,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100228003.cost)
	e1:SetTarget(c100228003.target)
	e1:SetOperation(c100228003.operation)
	c:RegisterEffect(e1,false,1)
end
function c100228003.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(5) and Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_GRAVE,0,nil,ATTRIBUTE_DARK)==5
end
function c100228003.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100228003)==0 end
	Duel.RegisterFlagEffect(tp,100228003,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c100228003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100228003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100228003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local g
			if Duel.IsPlayerAffectedByEffect(tp,69832741) then
				g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)
			else
				g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
			end
			if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
