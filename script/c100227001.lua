--ゴッドオーガス
--Orgoth the Relentless
function c100227001.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100227001,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100227001.target)
	e1:SetOperation(c100227001.operation)
	c:RegisterEffect(e1)
end
function c100227001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end
function c100227001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res,atk={0,0,0,0,0,0,false,false,false,false},0
	for _,i in ipairs({Duel.TossDice(tp,3)}) do
		atk=atk+(i*100)
		res[i]=res[i]+1
		if res[i]>=2 then
			res[(i+1)//2+6]=true
		end
		res[10]=res[i]==3
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	if res[1+6] or res[10] then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
	if res[2+6] or res[10] then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if res[3+6] or res[10] then
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DIRECT_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
