--ビーストアイズ・ペンデュラム・ドラゴン
function c72378329.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,c72378329.ffilter,aux.FilterBoolFunctionEx(Card.IsRace,RACE_BEAST))
	aux.AddContactFusion(c,c72378329.contactfil,c72378329.contactop,c72378329.splimit)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c72378329.damcon)
	e3:SetTarget(c72378329.damtg)
	e3:SetOperation(c72378329.damop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c72378329.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c72378329.ffilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_DRAGON,fc,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp)
end
function c72378329.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c72378329.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function c72378329.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function c72378329.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function c72378329.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c72378329.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c72378329.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsRace,nil,RACE_BEAST,c,SUMMON_TYPE_FUSION)
	local atk=0
	if g:GetCount()>0 then
		atk=g:GetFirst():GetTextAttack()
		if atk<0 then atk=0 end
	end
	e:GetLabelObject():SetLabel(atk)
end