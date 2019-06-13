	
	--Mobsonme's Threat Warner--
	--Initial private beta 
	-- NOT FOR PUBLIC RELEASE
	--Announces when attacks are failed at the start of combat to say/raid.
	
	--ToDo: 
	--Add druid support
	--Add party/raid/solo options
	--Add CLI option for enabling solo announcement 
		
	--InProgress:
	--Add adjustment of timers by second with CLI
	--add save var timer support
	--Add dodge/parry to missing auto attack checks
	
--Some globals
local MTWversion = 0.33
local ecTimer = 0
local MTWtargetlevel = UnitLevel('target')
local threatsayEn = 1

--Basic print function
function MTWPrint(msg)
	if (not DEFAULT_CHAT_FRAME) then
		return
	end
	
	DEFAULT_CHAT_FRAME:AddMessage("|cffA88059MTW:".."|cffffffff "..(msg))
	
end

function MTW_OnLoad()
	if UnitClass("player") == "Warrior" then
		this:RegisterEvent("PLAYER_ENTERING_WORLD")
		this:RegisterEvent("PLAYER_REGEN_DISABLED")
		this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
		this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
		this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
	end	
	
  SlashCmdList["MTWSLASH"] = MTW_SlashCommand;
  SLASH_MTWSLASH1 = "/mtw";

end

function MTW_SlashCommand(msg)
	 local _, _, command, MTWtimeroption = string.find(msg, "([%w%p]+)%s*(.*)$")
	 --local timeroption = nil
	
	if command ~= nil and MTWtimeroption ~= nil and tonumber(MTWtimeroption) ~= nil then
		
		MTWtimer = tonumber(MTWtimeroption)
		
		--echo("timer option entered is: "..MTWtimer)
   	else
	if command ~= nil and command == "timer"
	and command ~= "short" 
	and command ~= "medium" 
	and command ~= "long" 
	and command ~= "on" 
	and command ~= "off" then
		MTWPrint("Timer option must be followed with a number.")
	end
	
	end

--if (command) then
   -- command = string.lower(command);
--  end

	if UnitClass("player") == "Warrior" then

		if command == "timer" and MTWtimeroption ~= "" and tonumber(MTWtimeroption) ~= nil then 
				if MTWtimer > 6 then
					MTWPrint("Warning: a long duration is not recommended. \nCustom time entered. Changing announce timer to: "..MTWtimer)
				else
					MTWPrint("Custom time entered. Changing announce timer to: "..MTWtimer)
				end
		elseif command == "short" then
			MTWtimer = 2
			MTWPrint("Changing announce timer to 'short' : 2 seconds. ")
		elseif command == "medium" then 
			MTWtimer = 3
			MTWPrint("Changing announce timer to 'medium' : 3 seconds. ")
		elseif command == "long" then 
			MTWtimer = 5
			MTWPrint("Changing announce timer to 'long' : 5 seconds. ")
		elseif command == "off" then 
			threatsayEn = 0
			MTWPrint("MTW: Disabled")
		elseif command == "on" then
			MTWPrint("MTW: Enabled")
			threatsayEn = 1
		else
			MTWPrint("Mobsonme's Threat Warner. Current timer is ["..MTWtimer.."s]\n Change the initial combat timer duration with '/mtw timer #' (# in seconds), or enter: \n '/mtw short' (2s), '/mtw medium' (3s), or '/mtw long' (5s). \n '/mtw on' to enable, '/mtw off' to disable.")
		end
	end
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

	local soloannounceEn = 0 --"1" to "say" while not in a group, 0 for off. 
		
	--Global enter combat timer
    if event == "PLAYER_REGEN_DISABLED" and UnitClass("player") == "Warrior" then
        ecTimer = GetTime()
		
	end
	
	if event == "PLAYER_ENTERING_WORLD" then
	
		--init timer var for first installation
		if UnitClass("player") == "Warrior" then
			if MTWtimer == nil then
				MTWtimer = 3
			else
				tonumber(MTWtimer)
			end
		MTWPrint("Mobsonme's Threat Warner "..MTWversion.." beta LOADED. Type '/mtw' for help. Current timer is ["..MTWtimer.."s]. Solo announcement is : "..soloannounceEn)
			if not IsAddOnLoaded("KLHThreatMeter") then 
				MTWPrint("|cffFF0000Warning: |cffffffffKTM does not appear to be installed/enabled. Recommended for this addon to work.")
			end
		else
			MTWPrint("Mobsonme's Threat Warner "..MTWversion.."Disabled functions: class is not Warrior")
		end
		
	end
	
		
    --Begin start of combat threat failure announcements (AUTO ATTACK "miss" ONLY - below is spells). 
	if event == "CHAT_MSG_COMBAT_SELF_MISSES" and UnitClass("player") == "Warrior" and threatsayEn == 1 then
	
		if (strfind( arg1, "You miss")) then
		
			local cStarta = GetTime();
				if (cStarta - ecTimer <= MTWtimer) then
					if (GetNumRaidMembers() > 0) then	
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then			
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat(), "PARTY")
					elseif soloannounceEn == 1 then
					SendChatMessage("My opening auto attack missed! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE NEW AUTO MISS")				
				end
				
		end
	end
	--Begin start of (AUTO ATTACK "PARRY" and "DODGE" ONLY)
	if event == "CHAT_MSG_COMBAT_SELF_MISSES" and UnitClass("player") == "Warrior" and threatsayEn == 1 then
	
		if (strfind( arg1, "You attack")) then
		
			local _, _, parrymsg = string.find(arg1, "(.*) parries")
			local _, _, dodgemsg = string.find(arg1, "(.*) dodges")
			local autoparry = parrymsg
			local autododge = dodgemsg
			
			if autoparry then
				local cStarta = GetTime();
				if (cStarta - ecTimer <= MTWtimer) then
					if (GetNumRaidMembers() > 0) then	
					SendChatMessage("My opening auto attack was parried! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening auto attack was parried! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then			
					SendChatMessage("My opening auto attack was parried! My threat is: "..MTWmyKTMThreat(), "PARTY")
					elseif soloannounceEn == 1 then
					SendChatMessage("My opening auto attack was parried! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE NEW AUTO PARRY")				
				end
				
			elseif autododge then
			
				local cStartd = GetTime();
				if (cStartd - ecTimer <= MTWtimer) then
					if (GetNumRaidMembers() > 0) then
					SendChatMessage("My opening auto attack was dodged! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening auto attack was dodged! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then	
					SendChatMessage("My opening auto attackwas dodged! My threat is: "..MTWmyKTMThreat(), "PARTY")
					elseif soloannounceEn == 1 then
					SendChatMessage("My opening auto attack was dodged! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("CHAT_MSG_COMBAT_SELF_MISSES AUTO DODGE")
					
				end
			end
		end
	end
		
	
	--Begin start of combat threat failure announcements (SPECIAL attacks: miss/dodge/parry only)
	
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
				if (cStartm - ecTimer <= MTWtimer) --[[and UnitInRaid("player") or pip > 0]] then
					if (GetNumRaidMembers() > 0) then
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then	
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat(), "PARTY")
					elseif soloannounceEn == 1 then
					SendChatMessage("My opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL MISS")
					
				end
			
			elseif sndodge then
			local cStartd = GetTime();
				if (cStartd - ecTimer <= MTWtimer) --[[and UnitInRaid("player") or pip > 0]] then
					if (GetNumRaidMembers() > 0) then
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then	
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat(), "PARTY")
					elseif soloannounceEn == 1 then
					SendChatMessage("My opening "..sndodge.." was dodged! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL DODGE")
					
				end
				
			elseif snparry then
			local cStartp = GetTime() 
				if (cStartp - ecTimer <= MTWtimer) --[[and UnitInRaid("player") or pip > 0]] then
					if (GetNumRaidMembers() > 0) then
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat(), "RAID")
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat())
					elseif (GetNumPartyMembers() > 0) then	
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat(), "PARTY")
					elseif soloannounceEn == 1 then
					SendChatMessage("My opening "..snparry.." was parried! My threat is: "..MTWmyKTMThreat())
					end
					--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL PARRY")
					
				end
				
			end
		end
	
	end
end
	
