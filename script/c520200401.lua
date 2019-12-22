--New Master Rule: April 1, 2020 Update
--Scripted by kevinlul
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.op)
end
function s.op()
    aux.MR41=1
end