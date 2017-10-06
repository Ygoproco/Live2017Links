--漆黒のズムウォル
function c100000156.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	aux.AddDarkSynchroProcedure(c,aux.NonTuner(nil),nil,4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--deckdes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100000156,0))
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c100000156.tgcon)
	e3:SetTarget(c100000156.tgtg)
	e3:SetOperation(c100000156.tgop)
	c:RegisterEffect(e3)
	--add setcode
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_SETCODE)
	e4:SetValue(0x601)
	c:RegisterEffect(e4)
end
function c100000156.tgcon(e,c)
	return Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():GetAttack()>e:GetHandler():GetBaseAttack()
end
function c100000156.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=math.floor((Duel.GetAttackTarget():GetAttack()-e:GetHandler():GetBaseAttack())/100)	
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,ct)
end
function c100000156.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttackTarget():GetAttack()>e:GetHandler():GetBaseAttack() then
		local ct=math.floor((Duel.GetAttackTarget():GetAttack()-e:GetHandler():GetBaseAttack())/100)	
		Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
	end
end
