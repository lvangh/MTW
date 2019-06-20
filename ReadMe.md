
### MOBSONME'S THREAT FAIL WARNER


This add-on was created for Vanilla WoW 1.12.

It is designed with tanks in mind to handle rare situaitons where threat is critical in the first few moments of a fight. 

If an autoattack or special is missed, dodged, or parried in the start of a fight, this can spell disaster for the raid in situations where both speed OR caution is the goal. 

When an attack failure occurs, an announcement is made into the /say/party/raid (RW for bosses toggle as well) to notify the raid, along with the tank's current threat value pulled from KTM 17.x. 

This announcement is based off a customizable timer that starts when the player enters combat. So let's say you start to attack a raidb oss and you get a miss/dodge/parry, the raid will be notified to potentially slow down. 

#### History of the add-on / about author
I originally played Classic from 2004-2007 on Blackrock US.  In 2018, I found Kronos 3 and decided to revisit WoW. I have played with a handful of guilds as an OT/MT since K3 release. I found that it would be helpful to notify other players in the raid of critical threat failures. 



#### Version history
0.35 6/19/2019
-New SavedVariables (per account)
-New persistent settings for enabling/disabling addon, enabling RW mode, and enabling solo announcement mode.
-Status of new options is reflected in command line '/mtw'
-Removed 'short/medium/long as these are subjective. Recommended timer is 3.
-Alpha test for resetting timer on Ony phase 3 (not working yet)

0.33 6/12/2019
Now has persistant timer settings with account SavedVariable file.
Added command line options for timer and some various defaults (short, medium, long).
Added KTM checker.
Added auto attack parry/dodge events.
Added current timer report to /ktm
Removed message spam prevention timer for console messages.

0.1 
INITIAL PRIVATE RELEASE 6/11/2019
Warns party/group/raid when initial attacks fail at the start of combat



