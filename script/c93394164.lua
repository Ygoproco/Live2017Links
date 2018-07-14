--パラレル・パンツァー
--Parallel Panzer
--scripted by andré
function c93394164.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_LINK))
	--move to a zone it point
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93394164,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c93394164.mtarget)
	e1:SetOperation(c93394164.moperation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93394164,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,93394164)
	e2:SetCost(c93394164.dcost)
	e2:SetTarget(c93394164.dtarget)
	e2:SetOperation(c93394164.doperation)
	c:RegisterEffect(e2)
end
function c93394164.mtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then
		if not ec then return false end
		local p=ec:GetControler()
		local zone=ec:GetLinkedZone()&0x1f
		return Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0
	end
end
function c93394164.moperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then return end
	local p=ec:GetControler()
	local zone=ec:GetLinkedZone()&0x1f
	if Duel.GetLocationCount(p,LOCATION_MZONE,p,LOCATION_REASON_CONTROL,zone)>0 then
		local i=0
		if not ec:IsControler(tp) then i=16 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local nseq=math.log(Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~(zone<<i)),2) - i
		Duel.MoveSequence(ec,nseq)
	end
end
function c93394164.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then return ec and c:IsAbleToGraveAsCost() end
	Duel.SetTargetCard(ec)
	Duel.SendtoGrave(c,REASON_COST)
end
function c93394164.filter(c,g,tc)
	return c==tc or g:IsContains(c)
end
function c93394164.dtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then return end
	local g=Duel.GetMatchingGroup(c93394164.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,ec:GetColumnGroup(),ec)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c93394164.doperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c93394164.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tc:GetColumnGroup(),tc)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end

