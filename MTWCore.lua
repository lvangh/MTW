	
	--Mobsonme's threat announcer--
	--Initial private beta 
	-- NOT FOR PUBLIC RELEASE
	--Announces when attacks are failed at the start of combat to say/raid.
	
	
--Some globals
local MTWversion = 0.1
local ecTimer = 0
local MTWtargetlevel = UnitLevel('target')


--Basic print function
function MTWPrint(msg)
	if (not DEFAULT_CHAT_FRAME) then
		return
	end
	
	local cd,t = .10,GetTime() 
		if t-cd >= (TSLM or 0) then 
			TSLM = t DEFAULT_CHAT_FRAME:AddMessage("|cffA88059MP:".."|cffffffff "..(msg))
		end
end



function MTW_OnLoad()
	if UnitClass("player") == "Warrior" then
		this:RegisterEvent("PLAYER_ENTERING_WORLD")
		this:RegisterEvent("PLAYER_REGEN_DISABLED")
		this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
		this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
		this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
	end	
	
  --SlashCmdList["MPTW"] = MPTW_SlashCommand;
  --SLASH_MADPROTTER1 = "/MPTW";
 -- SLASH_MADPROTTER2 = "/MPT";
end

function MTW_SlashCommand()
	
	--[[if UnitClass("player") == "Warrior" then
	MadProtterAddon()
	else
	MPPrint("Disabled functions: class is not Warrior or 31 point talent not learned")
	end]]
end



function MTWmyKTMThreat()
	if IsAddOnLoaded("KLHThreatMeter") then
	local playerThreat = klhtm.table.raiddata[UnitName("player")]
	playerThreat = playerThreat == nil and 0 or playerThreat
	return playerThreat
  else
  MTWPrint("KTM NOT INSTALLED")
  return 0
  end
  
end
	
		
function MTW_OnEvent(event)

	local threatsaytimer = 3 --How many seconds after entering combat to announce failed attacks
	local threatsayEn = 1
	--local solosayEn = 1 --"1" for say while not in a group, 0 for off. 

	
	--Global enter combat timer
    if event == "PLAYER_REGEN_DISABLED" and UnitClass("player") == "Warrior" then
        ecTimer = GetTime()
	end
	
	--Shortens announcement window if in a raid and ragets are not bosses
	if UnitInRaid('player') and MPtargetlevel < 61 and UnitClass("player") == "Warrior" then
		threatsaytimer = 2
	end	
	
	if event == "PLAYER_ENTERING_WORLD" then
		if UnitClass("player") == "Warrior" then
        MTWPrint("Mobsonme's Threat Announcer "..MTWversion.." LOADED" )
		else
		MTWPrint("WARNING: Mobsonme's Threat Announcer "..MTWversion.." DISABLED: CLASS IS NOT WARRIOR" )
		end
end

		
    --Begin start of combat threat failure announcements (AUTO ATTACK "miss" ONLY - below is spells). 
	if event == "CHAT_MSG_COMBAT_SELF_MISSES" and UnitClass("player") == "Warrior" and threatsayEn == 1 then
	
		if (strfind( arg1, "You miss")) then
		
			local cStarta = GetTime();
				if (cStarta - ecTimer <= threatsaytimer) then
					if (GetNumRaidMembers() > 0) then	
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then			
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat(), "PARTY")
					else
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE NEW AUTO MISS")				
				end
				
		end
	end
	
	--Begin start of combat threat failure announcements (special attacks: miss/dodge/parry only)
	
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and UnitClass("player") == "Warrior" and threatsayEn == 1 then
			 
		if (strfind( arg1, "Your")) then
			
			local sspecial, fspecial, specialmsg = string.find(arg1, "Your (.*) missed")
			local sdodge, fdodge, dodgemsg = string.find(arg1, "Your (.*) was dodged")
			local sparrymiss, fparrymiss, parrymsg = string.find(arg1, "Your (.*) is parried")
			local snmiss = specialmsg
			local sndodge = dodgemsg
			local snparry = parrymsg
			
			if snmiss then
			local cStartm = GetTime()
				if (cStartm - ecTimer <= threatsaytimer) --[[and UnitInRaid("player") or pip > 0]] then
					if (GetNumRaidMembers() > 0) then
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then	
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat(), "PARTY")
					else
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL MISS")
					
				end
			
			elseif sndodge then
			local cStartd = GetTime();
				if (cStartd - ecTimer <= threatsaytimer) --[[and UnitInRaid("player") or pip > 0]] then
					if (GetNumRaidMembers() > 0) then
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then	
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat(), "PARTY")
					else
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL DODGE")
					
				end
				
			elseif snparry then
			local cStartp = GetTime() 
				if (cStartp - ecTimer <= threatsaytimer) --[[and UnitInRaid("player") or pip > 0]] then
					if (GetNumRaidMembers() > 0) then
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then	
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat(), "PARTY")
					else
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL PARRY")
					
				end
				
			end
		end
	
	end
end
	
	

