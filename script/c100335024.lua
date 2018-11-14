--転生炎獣の烈爪
--Salamangreat Claw
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x119))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--pierce
	local e3=e1:Clone()
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--multiattack
	local e4=e1:Clone()
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetCondition(s.macon)
	e4:SetValue(function(e,c) return c:GetLink() end)
	c:RegisterEffect(e4)
	--recarnation check
	if not s.g_chk then
		s.g_chk=true
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MATERIAL_CHECK)
		e1:SetValue(s.val)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge1:SetLabelObject(e1)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetTarget(s.gtg)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.gtg(e,c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x119)
end
function s.val(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,c:GetCode()) and c:IsSummonType(SUMMON_TYPE_LINK) then
		c:RegisterFlagEffect(41463181,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE-RESET_TEMP_REMOVE,0,1)
	end
end
function s.macon(e)
	local c=e:GetHandler():GetEquipTarget()
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK) and c:GetFlagEffect(41463181)~=0
end
