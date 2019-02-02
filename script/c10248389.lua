--サイバー・ブレイダー
function c10248389.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,97023549,11460577)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c10248389.con)
	e1:SetLabel(1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetLabel(2)
	e2:SetCondition(c10248389.con)
	e2:SetValue(c10248389.atkval)
	c:RegisterEffect(e2)
	--disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(3)
	e4:SetCondition(c10248389.con)
	e4:SetOperation(c10248389.disop)
	c:RegisterEffect(e4)
	--Double Snare
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabel(3)
	e5:SetCondition(c10248389.con)
	e5:SetCode(3682106)
	c:RegisterEffect(e5)
end
c10248389.material_setcode=0x93
function c10248389.con(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)==e:GetLabel()
end
function c10248389.atkval(e,c)
	return c:GetAttack()*2
end
function c10248389.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then
		Duel.NegateEffect(ev)
	end
end
