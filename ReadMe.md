
### MOBSONME'S THREAT WARNER
Last major revision June 2019. 

Last minor 11/2020
(This add-on is in BETA. More features may come and some bugs may exist. Currently only works with the WARRIOR class.)

This add-on was created for Vanilla WoW 1.12. 




It is designed with tanks in mind to handle rare situations where threat production failure is critical in the first few seconds of a fight. 

If an autoattack or special is missed, dodged, or parried very early in combat, this can spell disaster for the raid in situations where both speed OR caution is the goal. 

When an attack failure occurs, an announcement is made into the /say/party/raid (RW for bosses toggle as well) to notify the raid, along with the tank's current threat value pulled from KTM 17.x. 

This announcement is based off a customizable timer that starts when the player enters combat. When the timer ends, the warnings stop until the next time a player enters combat. 



#### Use
Type /mtw in game to see the menu.

![Alt text](images/mtw.jpg?raw=true "Slash command /mtw")

- Enable the addon by typing `/mtw on` or /`mtw off` to disable
- Change the timer by typing `/mtw timer 3`
- Enable solo announcement mode by typing `/mtw solo on` or `/mtw solo off` (announces in /say) - useful for possible situation out in the world when trying to help tank something.
- Enable Raid Warning mode (bosses only) by typing `/mtw bossrw on` or `/mtw bossrw off`

(2nd or 3rd off tanks and DPS warriors may want to turn the add-on OFF when not main tanking.)

![In action](images/mtwinaction.png?raw=true "My attack failed!")


#### Installation
- Download the add-on here, then save and extract the .zip file contents into `WoW/Interface/AddOns/`.
- Rename `MTW-master` to `MTW`

#### History of the add-on / about author
I originally played Classic from 2004-2007 on Uther and Blackrock US. I mained protection warrior through TBC.  In 2018, I found Kronos 3 and decided to revisit WoW. I have played with a handful of guilds as an OT/MT since K3 release. I found that it would be helpful to notify other players in the raid of critical threat failures and started work on this project. In Classic, I am on Atiesh PvE as Mobsonme, Telligentsia and Charlajr. 

![Alt text](images/mobs.png?raw=true "Mobsonme K3")


#### Version history
0.37 6/21/2019
- Attempt to stop messages on player targets (duel, PVP etc)

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
- Added current timer report to /mtw
- Removed dev message spam prevention timer for console messages.

0.1 
INITIAL PRIVATE RELEASE 6/11/2019
- Warns party/group/raid when initial attacks fail at the start of combat



