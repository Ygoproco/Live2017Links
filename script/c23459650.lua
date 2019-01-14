--ネフティスの輪廻
--Rebirth of Nephthys
function c23459650.initial_effect(c)
	aux.AddRitualProcGreater(c,c23459650.ritualfil,nil,nil,nil,nil,c23459650.stage2)
end
c23459650.fit_monster={88176533,24175232}
function c23459650.ritualfil(c)
	return c:IsSetCard(0x11f) and c:IsRitualMonster()
end
function c23459650.stage2(mg,e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if mg:IsExists(c23459650.mfilter,1,nil) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(23459650,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,e:GetHandler())
		Duel.Destroy(sg,REASON_EFFECT)
	end
end