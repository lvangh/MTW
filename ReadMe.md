
### MOBSONME'S THREAT WARNER


This add-on was created for Vanilla WoW 1.12.

It is designed with tanks in mind to handle rare situaitons where threat is critical in the first few moments of a fight. 

If an autoattack or special is missed, dodged, or parried in the start of a fight, this can spell disaster for the raid in situations where both speed OR caution is the goal. 

When an attack failure occurs, an announcement is made into the /say/party/raid (RW for bosses toggle as well) to notify the raid, along with the tank's current threat value pulled from KTM 17.x. 

This announcement is based off a customizable timer that starts when the player enters combat. When the timer ends, the warnings stop until the next time a player enters combat. 

#### Use
Type /mtw in game to see the menu.

![Alt text](images/mtw.jpg?raw=true "Slash command /mtw")

- Enable the addon by typing `/mtw on` or /`mtw off` to disable
- Change the timer by typing `/mtw timer 3`
- Enable solo announcement mode by typing `/mtw solo on` or `/mtw solo off` (announces in /say) - useful for possible situation out in the world when trying to help tank something.
- Enable Raid Warning mode (bosses only) by typing `/mtw bossrw on` or `/mtw bossrw off`

![In action](images/mtwinaction.png?raw=true "My attack failed!")


#### Installation
- Download the add-on here, then save and extract the .zip file contents into `WoW/Interface/AddOns/`.
- Rename `MTW-master` to `MTW`

#### History of the add-on / about author
I originally played Classic from 2004-2007 on Blackrock US.  In 2018, I found Kronos 3 and decided to revisit WoW. I have played with a handful of guilds as an OT/MT since K3 release. I found that it would be helpful to notify other players in the raid of critical threat failures. 

![Alt text](images/mobs.png?raw=true "Mobsonme K3")


#### Version history
0.35 6/19/2019
- New SavedVariables (per account)
- New persistent settings for enabling/disabling addon, enabling RW mode, and enabling solo announcement mode.
- Status of new options is reflected in command line '/mtw'
- Removed 'short/medium/long as these are subjective. Recommended timer is 3.
- Alpha test for resetting timer on Ony phase 3 (not working yet)

0.33 6/12/2019
- Now has persistant timer setting with account SavedVariable file.
- Added command line options for timer and some various defaults (short, medium, long).
- Added KTM checker.
- Added auto attack parry/dodge events.
- Added current timer report to /ktm
- Removed message spam prevention timer for console messages.

0.1 
INITIAL PRIVATE RELEASE 6/11/2019
- Warns party/group/raid when initial attacks fail at the start of combat



