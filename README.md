# kc-unicorn [![Release](https://img.shields.io/badge/Release-V%201.0-blue)](https://github.com/clementinise/kc-unicorn/releases/latest)

**Bring life & interactions to the Unicorn Club - [kc-unicorn on cfx.re forum](https://forum.cfx.re/t/release-unicorn-club-script-kc-unicorn-v1-0-free/4802992)** 

### This resource use [FiveM-checker](https://github.com/clementinise/fivem-checker), created to easily keep track if a resource need to be updated!

## FEATURES
* Use one of the seven available seats of the Unicorn Club and choose which stripper you want your lapdance with
* Lean at the poledance area to throw some cash at the strippers
* Strip-Club Blip at the Unicorn
* Lap dance and pole dance marker
* Choose between different framework, `standalone` is set by default. [standalone, [esx](https://github.com/esx-framework/es_extended/tree/v1-final), [qb-core](https://forum.cfx.re/t/qbcore-framework/4116674)]
* Multiple ways to display the text at all markers (`Config.Text`)
* Update Checker and changelog if new update found directly in console on resource start, except if [`fivem-checker`](https://github.com/clementinise/fivem-checker) is installed and running on your server
* Run at 0.00ms (0.08%) on idle and 0.03ms when in lap dance (Max reach was 0.07ms)
* Check for players already in a lap dance to avoid conflict or dupe
* Proper locale system with French and English language already included
* If you run into any issue with this resource, just set 'Config.Debug' to true, it will print some debug logs in the client console. You can then send them [here](https://forum.cfx.re/t/release-unicorn-club-script-kc-unicorn-v1-0-free/4802992).

## kc-unicorn is heavily configurable: 
* **Config.Framework**
Choose which framework your server is using so qb-lapdance can work with it [standalone, [esx](https://github.com/esx-framework/es_extended/tree/v1-final), [qb-core](https://forum.cfx.re/t/qbcore-framework/4116674)]
* **Config.Text**
2D, 3D, Better3D, None (Set the one you like to suit your server, the performance difference is mostly non-existant)
* **Config.LapDanceCost**
Set the cost of the lap dance
* **Config.ThrowCost**
Set the cost of how much players will throw at the poledance
* **Config.LegMoney**
Little easter egg for your player, will add an accessory "Leg money" to the stripper if the player has more than 'Config.LegMoney' in cash. Set to a huge value if you don't want this
* **Config.Nudity**
Set to true if you want the stripper to be topless (Only for player above 'Config.NudityAge')
* **Config.NudityAge**
Player age restriction. If underage and 'Config.Nudity' is set to true, the stripper won't be topless. Set to 0 if you don't want age restriction
* **Config.Blip**
Set to false if you don't want the blip on the map
* **Config.BlipStripclub**
This config will let you easily modify the blip to your need. It also include comments to help you in modifying it
* **Config.BlipCoord**
If you want to move the blip on the map, change this.
* **Config.LapMarker**
Set to true if you want the marker for the lapdance to be "drawn"
* **Config.SelectStrippers**
Set to true if you want to let your player choose which stripper they want for their lapdance
* **Config.Strippers**
List of available strippers for the lapdance
* **Config.Language**
Set the language variable that will be used for the locale system. For now, kc-unicorn has translation in French and English (fr or en), but you can easily create your own translation!
* **Config.UpdateChecker**
Set to false if you don't want to check for qb-lapdance update on start
* **Config.ChangeLog**
Set to false if you don't want to display the changelog if new version is found


Some new features will be added soon: ~~Being able to use the 7 seats and not only the first in the Unicorn~~ Done ✅, ~~choose between different stripper~~ Done ✅, different gender for stripper(?), member card for cheaper lap dance(?)

**KNOWN BUG :** 
* None (For now I guess?)

**Preview:** [Coming Soon]()

## Installation

### Requirement
* [PolyZone](https://github.com/mkafrin/PolyZone)

Download the [latest release](https://github.com/clementinise/kc-unicorn/releases/latest).

Drag the folder into your `<server-data>/resources/` folder Add this in your `server.cfg`:

```
start kc-unicorn
```
