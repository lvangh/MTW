	
	--Mobsonme's Threat Warner--
	--May 2019 
	--Discord efnetdoom2#1795
	--Kronos Wow / Atiesh Classic 
	--Initial private beta 
	-- NOT FOR PUBLIC RELEASE
	--Announces when attacks are failed at the start of combat to say/raid.
	
	--ToDo: 
	--Add custom string variable option (11/2020)
	--Add druid support
	--Add party/raid/solo options
	--Add GUI
	--Consider turning off special warning if hit capped - meh - wouldn't get message if capped anyway
	
	--Possible ToDO:
	--Option to turn off warning after first warning occurs
	
	--InProgress:
	--Add adjustment of timers in seconds with CLI
	--add save var timer support
	--add saved varsolo announce timer + CLI
	--stop announcements on player targets
		
	--Done
	--Stop loading on world change
	--Add dodge/parry to missing auto attack checks
	--Move welcome message to "VARIABLES_LOADED"
	
	--Some globals
	local MTWversion = 0.37
	local ecTimer = 0
	local MTWtargetlevel = UnitLevel('target')
	local MTWplayername,_ = UnitName('player')
	local MTWtot,MTWrot=UnitName("targettarget")
	local MTWshowState = nil
	local MTWshowbossrwState = nil
	--MTWtimer, MTWbossOnly, MTWisEnabled, MTWsoloEnabled, MTWbossrwEN are stored in SavedVariables
	

--Basic print function
function MTWPrint(msg)
	if (not DEFAULT_CHAT_FRAME) then
		return
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cffA88059MTW:".."|cffffffff "..(msg))
	
end

--KTM hook
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

--
function MTWBossCheck()
local mtib = UnitLevel('target')

	if mtib == -1 and MTWbossrwEN == 1 then
		return true
	else
		return false
	end
end

function MTW_OnLoad()
	if UnitClass("player") == "Warrior" then
		this:RegisterEvent("PLAYER_ENTERING_WORLD")
		this:RegisterEvent("PLAYER_REGEN_DISABLED")
		this:RegisterEvent("VARIABLES_LOADED")
		this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
		this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
		this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
		this:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	end	
	
  SlashCmdList["MTWSLASH"] = MTW_SlashCommand;
  SLASH_MTWSLASH1 = "/mtw";

end

function MTW_SlashCommand(msg)

	if UnitClass("player") == "Warrior" then

	--local MTWstatusHeader = "Mobsonme's Threat Warner. MTW is ["..MTWshowState.."|cffffffff]. Current timer is ["..MTWtimer.."s]. Solo announcement is --["..MTWshowsoloState.."|cffffffff]. Type '/mtw' for help."
	

	 local _, _, command, MTWoption = string.find(msg, "([%w%p]+)%s*(.*)$")
	 --local timeroption = nil
	
	
	--[[ experiment
	local MTWCmdList = {
	"on",
	"off",
	"short",
	"medium",
	"long",
	"solo",
	}]]
	
	--Converts passed timer option to new number var  
	if command == "timer" and command ~= nil and MTWoption ~= nil and tonumber(MTWoption) ~= nil then
		
		MTWtimer = tonumber(MTWoption)
				
   	else
	if command ~= nil and command == "timer"
	and command ~= "short" 
	and command ~= "medium" 
	and command ~= "long" 
	and command ~= "on" 
	and command ~= "off" then
		MTWPrint("Timer option must be followed with a number. Recommended timer is 3.")
	end
	
	end

--if (command) then
   -- command = string.lower(command);
--  end

		
		if command == "timer" and MTWoption ~= "" and tonumber(MTWoption) ~= nil then 
			if MTWtimer > 5 then
				MTWPrint("Warning: A long duration is not recommended. Recommended timer is 3. \nCustom time entered.  Changing announce timer to: "..MTWtimer)
			else
				MTWPrint("Custom time entered. Changing announce timer to: "..MTWtimer.."s")
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
		elseif command == "on" then 
			MTWPrint("MTW: Enabled / On")
			MTWisEnabled = 1
			MTWshowState = "|cff008000On"
		elseif command == "off" then
			MTWisEnabled = 0
			MTWPrint("MTW: Disabled / Off")
			MTWshowState = "|cffFF0000Off"
		elseif command == "solo" and MTWoption == "on" then
			MTWPrint("Solo announcement mode enabled. Warnings will appear in /say.")
			MTWsoloEnabled = 1
			MTWshowsoloState = "|cff008000On"
		elseif command == "solo" and MTWoption == "off" then
			MTWPrint("Solo announcement mode disabled.")
			MTWsoloEnabled = 0
			MTWshowsoloState = "|cffFF0000Off"
		elseif command == "bossrw" and MTWoption == "on" then
			MTWPrint("MTW: Boss RW Announcement enabled")
			MTWbossrwEN = 1
			MTWshowbossrwState = "|cff008000On"
		elseif command == "bossrw" and MTWoption == "off" then
			MTWbossrwEN = 0
			MTWPrint("MTW: Boss RW Announcement disabled")
			MTWshowbossrwState = "|cffFF0000Off"
		else
		MTWPrint("Mobsonme's Threat Warner.")
		MTWPrint("MTW is ["..MTWshowState.."|cffffffff] Current timer is ["..MTWtimer.."s]. Solo announcement is ["..MTWshowsoloState.."|cffffffff]. Boss raid warning is ["..MTWshowbossrwState.."|cffffffff]")
		MTWPrint("/mtw on / off  - Enable / disable MTW.")
		MTWPrint("/mtw timer #  - (# in seconds) Change the initial combat timer duration.")
		--MTWPrint("Or enter: [/mtw short] (2s), [/mtw medium] (3s), or [/mtw long] (5s)")
		MTWPrint("/mtw solo on / off  - Enable or disable announcements when not in a group.")
		MTWPrint("/mtw bossrw on / off  - Enable 'Raid Warning' on bosses.")
		end
	end
end



function MTWAutos()
end
function MTWSpecials()
end

function MTW_OnEvent(event)

		--Beta Onyxia reset combat timer for Phase 3
	if event == "CHAT_MSG_MONSTER_YELL"  then
		if (string.find(arg1, "It seems you'll need another lesson")) then
		ecTimer = GetTime()
		echo("ony phase 3 test")
		end
		if (string.find(arg1, "Well done, my minions")) then
		ecTimer = GetTime() + 9
		echo("ony phase 3 test")
		end
	end

	
	
	
	--Global enter combat timer
    if event == "PLAYER_REGEN_DISABLED" and UnitClass("player") == "Warrior" then
        ecTimer = GetTime()
	end
	
	if event == "VARIABLES_LOADED" then
	
	if MTWisEnabled == 1 then
		MTWshowState = "|cff008000On"
		else
		MTWshowState = "|cffFF0000Off"
	end
	
	if MTWsoloEnabled == 1 then
		MTWshowsoloState = "|cff008000On"
		else
		MTWshowsoloState = "|cffFF0000Off"
	end
	
	if MTWbossrwEN == 1 then
		MTWshowbossrwState = "|cff008000On"
		else
		MTWshowbossrwState = "|cffFF0000Off"
	end
	
		if UnitClass("player") == "Warrior" and MTWtimer ~= nil then
			MTWPrint("Mobsonme's Threat Warner "..MTWversion.." beta LOADED. MTW is ["..MTWshowState.."|cffffffff] Current timer is ["..MTWtimer.."s]. Solo announcement is ["..MTWshowsoloState.."|cffffffff]. Boss raid warning is ["..MTWshowbossrwState.."|cffffffff]. Type '/mtw' for help.")
		else
			MTWPrint("Mobsonme's Threat Warner "..MTWversion.."Disabled functions: class is not Warrior")
		end	
		
			--init timer and raidboss var for first installation
		if UnitClass("player") == "Warrior" then
			if MTWtimer == nil then
				MTWtimer = 3
			else
				tonumber(MTWtimer)
			end
			if MTWbossOnly == nil then
				MTWbossOnly = 0
			else
				tonumber(MTWbossOnly)
			end
			if MTWisEnabled == nil then
				MTWisEnabled = 1
			else
				tonumber(MTWisEnabled)
			end
			if MTWsoloEnabled == nil then
				MTWsoloEnabled = 0
			else
				tonumber(MTWsoloEnabled)
			end
			if MTWbossrwEn == nil then
				MTWbossrwEn = 0
			else
				tonumber(MTWbossreEN)
			end
		
			if not IsAddOnLoaded("KLHThreatMeter") then 
				MTWPrint("|cffFF0000Warning: |cffffffffKTM does not appear to be installed/enabled. Recommended for MTW to work properly.")
			end
		
		end	
			
	end
	
	
	--Unused
	--if event == "PLAYER_ENTERING_WORLD" then
	--end
	

		--Begin start of combat threat failure announcements (AUTO ATTACK "miss" ONLY - below is spells). 
		if event == "CHAT_MSG_COMBAT_SELF_MISSES" and UnitClass("player") == "Warrior" and MTWisEnabled == 1 and (not UnitPlayerControlled("target")) then
			
	
			if (strfind( arg1, "You miss")) then
			
				local cStarta = GetTime();
					if (cStarta - ecTimer <= MTWtimer) then
						if (GetNumRaidMembers() > 0) then	
						SendChatMessage("Opening auto missed! My threat is: "..MTWmyKTMThreat(), "RAID")
						SendChatMessage("Opening auto missed! My threat is: "..MTWmyKTMThreat())
						if MTWBossCheck() == true then
							SendChatMessage("Opening auto missed! My threat is: "..MTWmyKTMThreat(),"RAID_WARNING")
						end
						elseif (GetNumPartyMembers() > 0) then			
						SendChatMessage("Opening auto missed! My threat is: "..MTWmyKTMThreat(), "PARTY")
						elseif MTWsoloEnabled == 1 then
						SendChatMessage("Opening auto missed! My threat is: "..MTWmyKTMThreat())
						end
						--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE NEW AUTO MISS")				
					end
					
			end
		end
		--Begin start of (AUTO ATTACK "PARRY" and "DODGE" ONLY)
		if event == "CHAT_MSG_COMBAT_SELF_MISSES" and UnitClass("player") == "Warrior" and MTWisEnabled == 1 and (not UnitPlayerControlled("target")) then
		
			if (strfind( arg1, "You attack")) then
			
				local _, _, parrymsg = string.find(arg1, "(.*) parries")
				local _, _, dodgemsg = string.find(arg1, "(.*) dodges")
				local autoparry = parrymsg
				local autododge = dodgemsg
				
				if autoparry then
					local cStarta = GetTime();
					if (cStarta - ecTimer <= MTWtimer) then
						if (GetNumRaidMembers() > 0) then	
						SendChatMessage("Opening auto parried! My threat is: "..MTWmyKTMThreat(), "RAID")
						SendChatMessage("Opening auto parried! My threat is: "..MTWmyKTMThreat())
						if MTWBossCheck() == true then
							SendChatMessage("Opening auto parried! My threat is: "..MTWmyKTMThreat(),"RAID_WARNING")
						end
						elseif (GetNumPartyMembers() > 0) then			
						SendChatMessage("Opening auto parried! My threat is: "..MTWmyKTMThreat(), "PARTY")
						elseif MTWsoloEnabled == 1 then
						SendChatMessage("Opening auto parried! My threat is: "..MTWmyKTMThreat())
						end
						--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE NEW AUTO PARRY")				
					end
					
				elseif autododge then
				
					local cStartd = GetTime();
					if (cStartd - ecTimer <= MTWtimer) then
						if (GetNumRaidMembers() > 0) then
						SendChatMessage("Opening auto dodged! My threat is: "..MTWmyKTMThreat(), "RAID")
						SendChatMessage("Opening auto dodged! My threat is: "..MTWmyKTMThreat())
						if MTWBossCheck() == true then
							SendChatMessage("Opening auto dodged! My threat is: "..MTWmyKTMThreat(),"RAID_WARNING")
						end
						elseif (GetNumPartyMembers() > 0) then	
						SendChatMessage("Opening auto dodged! My threat is: "..MTWmyKTMThreat(), "PARTY")
						elseif MTWsoloEnabled == 1 then
						SendChatMessage("Opening auto dodged! My threat is: "..MTWmyKTMThreat())
						end
						--MPDebug("CHAT_MSG_COMBAT_SELF_MISSES AUTO DODGE")
						
					end
				end
			end
		end
			
		
		--Begin start of combat threat failure announcements (SPECIAL attacks: miss/dodge/parry only)
		
		if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and UnitClass("player") == "Warrior" and MTWisEnabled == 1 and (not UnitPlayerControlled("target")) then
				 
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
						SendChatMessage("Opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat(), "RAID")
						SendChatMessage("Opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat())
						if MTWBossCheck() == true then
							SendChatMessage("Opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat(),"RAID_WARNING")
						end
						elseif (GetNumPartyMembers() > 0) then	
						SendChatMessage("Opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat(), "PARTY")
						elseif MTWsoloEnabled == 1 then
						SendChatMessage("Opening "..snmiss.." missed! My threat is: "..MTWmyKTMThreat())
						end
						--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL MISS")
						
					end
				
				elseif sndodge then
				local cStartd = GetTime();
					if (cStartd - ecTimer <= MTWtimer) --[[and UnitInRaid("player") or pip > 0]] then
						if (GetNumRaidMembers() > 0) then
						SendChatMessage("Opening  "..sndodge.." dodged! My threat is: "..MTWmyKTMThreat(), "RAID")
						SendChatMessage("Opening "..sndodge.." dodged! My threat is: "..MTWmyKTMThreat())
						if MTWBossCheck() == true then
							SendChatMessage("Opening "..sndodge.." dodged! My threat is: "..MTWmyKTMThreat(),"RAID_WARNING")
						end
						elseif (GetNumPartyMembers() > 0) then	
						SendChatMessage("Opening "..sndodge.." dodged! My threat is: "..MTWmyKTMThreat(), "PARTY")
						elseif MTWsoloEnabled == 1 then
						SendChatMessage("Opening "..sndodge.." dodged! My threat is: "..MTWmyKTMThreat())
						end
						--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL DODGE")
						
					end
					
				elseif snparry then
				local cStartp = GetTime() 
					if (cStartp - ecTimer <= MTWtimer) --[[and UnitInRaid("player") or pip > 0]] then
						if (GetNumRaidMembers() > 0) then
						SendChatMessage("Opening "..snparry.." parried! My threat is: "..MTWmyKTMThreat(), "RAID")
						SendChatMessage("Opening "..snparry.." parried! My threat is: "..MTWmyKTMThreat())
						if MTWBossCheck() == true then
							SendChatMessage("Opening "..snparry.." parried! My threat is: "..MTWmyKTMThreat(),"RAID_WARNING")
						end
						elseif (GetNumPartyMembers() > 0) then	
						SendChatMessage("Opening "..snparry.." parried! My threat is: "..MTWmyKTMThreat(), "PARTY")
						elseif MTWsoloEnabled == 1 then
						SendChatMessage("Opening "..snparry.." parried! My threat is: "..MTWmyKTMThreat())
						end
						--MPDebug("USING CHAT_MSG_SPELL_SELF_DAMAGE SPECIAL PARRY")
						
					end
					
				end
			end
	
		end
	
end
	
