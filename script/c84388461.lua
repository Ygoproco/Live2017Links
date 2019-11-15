--剣聖の影霊衣－セフィラセイバー
--Zefrasaber, Swordmaster of the Nekroz
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Ritual Summon
	local e1=aux.CreateRitualProc(c,RITPROC_EQUAL,aux.FilterBoolFunction(Card.IsSetCard,0xb4),nil,aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rcon)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xb4) or c:IsSetCard(0xc4) then return false end
	return sumtype&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM
end
