--究極竜騎士
function c62873545.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,5405694,23995346)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c62873545.atkval)
	c:RegisterEffect(e2)
end
c62873545.listed_names={23995346}
c62873545.material_setcode={0x10cf,0xcf,0xdd}
function c62873545.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c62873545.atkval(e,c)
	return Duel.GetMatchingGroupCount(c62873545.filter,c:GetControler(),LOCATION_MZONE,0,c)*500
end
