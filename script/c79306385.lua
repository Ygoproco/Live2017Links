--宣告者の神託
function c79306385.initial_effect(c)
	local e1=aux.AddRitualProcGreaterCode(c,48546368)
	e1:SetTarget(c79306385.target(e1))
end
function c79306385.target(eff)
	local tg = eff:GetTarget()
	return function(e,...)
		local ret = tg(e,...)
		if ret then return ret end
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			Duel.SetChainLimit(c79306385.chlimit)
		end
	end
end
function c79306385.chlimit(e,ep,tp)
	return tp==ep
end