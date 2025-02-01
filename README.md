# StatCompare v1.8 for Vanilla World of Warcraft v 1.12.1
StatCompare adds a stats panel next to your Character and Inspection Panes, making it easy to screenshot your stats for gear checks or compare your gear to your target.

This version has been updated to make gear checks easier by showing the list of equipped item names and their enchants, as well as all active buffs.

<b>As of February 2025 it's stable, but I'm still tweaking it so keep updating your addon. Ping Provocateur in turtlewow or drop a note on [the project's github page](https://github.com/grimfiendish/StatCompare) if you have any issues.</b>

_This version comes bundled with "StatCompareBuff", "StatCompareChar", "StatCompareSpell", "StatCompareGearCheck", and "StatCompareUI"._

## 1.8 Screenshots

### View  your own stats (e.g. for Gear Checks)

This screenshot shows all stats showing Character's **Spell info** (toggle with <img src="inv/inv_misc_book_08.jpg" alt="Spellbook" height="12px"/>), **Stats** (toggle with <img src="inv/inv_misc_note_01.jpg" alt="Note Icon" height="12px"/>, and **Armor/Enchants** (toggle with <img src="inv/inv_helmet_10.jpg" alt="Armor" height="12px"/>)

![Use StatCompare to view your own stats](https://raw.githubusercontent.com/grimfiendish/StatCompare/129ac15b6b7b0308f0a14a214fcf9b0d3e9a2092/media/Character%20-%20Show%20Armor%20-%20Show%20Spells%20-%20Show%20Stats.jpg)

Examples of toggling off data you're not interested in:
![Only showing Armor/Enchants](https://raw.githubusercontent.com/grimfiendish/StatCompare/129ac15b6b7b0308f0a14a214fcf9b0d3e9a2092/media/Character%20-%20Show%20Armor%20-%20Hide%20Spells%20-%20Hide%20Stats.jpg)
![Only showing Spell info](https://raw.githubusercontent.com/grimfiendish/StatCompare/129ac15b6b7b0308f0a14a214fcf9b0d3e9a2092/media/Character%20-%20Hide%20Armor%20-%20Show%20Spells%20-%20Hide%20Stats.jpg)
![Only showing Character Stats](https://raw.githubusercontent.com/grimfiendish/StatCompare/129ac15b6b7b0308f0a14a214fcf9b0d3e9a2092/media/Character%20-%20Hide%20Armor%20-%20Hide%20Spells%20-%20Show%20Stats.jpg)

### Quickly review your target's stats

![Use StatCompare to view your own stats](https://raw.githubusercontent.com/grimfiendish/StatCompare/129ac15b6b7b0308f0a14a214fcf9b0d3e9a2092/media/Inspect%20-%20Show%20Armor%20-%20Show%20Spells%20-%20Show%20Stats.jpg)


View detailed stats on your inspection target

![Use StatCompare to compare with others](https://raw.githubusercontent.com/grimfiendish/StatCompare/391ff026dbcefe209e248533717122044644b0fe/media/compare_stats.jpg)

## 1.7 Screenshots



https://user-images.githubusercontent.com/24671466/27562912-1a698a34-5acf-11e7-9bac-b029c9160eb4.png

## Too long; Didn't Read

* This addon was written in 2006. 
* The folder name was "StatCompare" but the in-game name was "Character Status Compare", which was awkward and made it hard to find online so I got rid of the "Character Status Compare" name.
* Roughly a half-dozen addons were created for it. [Found a bundled version of the addon](https://gitee.com/shines77/TurtleWoW_AddOns) on a Chinese clone of github called Gitee, but it was to an entire AddOns folder, so I didn't clone it directly. This version had been modified to automatically include a couple of the downstream addons such as StatCompareBuffs.
* This version ,1.8+,  adds the "Gear check" aspect which displays talent tree, active buffs (to know how your stats are affected), equipped item list (especially useful on vanilla servers that allow transmogrificatoin), and corresponding enchants.


## Installation
1. Close any instance of WoW
2. Download **[StatCompare Zip file](https://github.com/grimfiendish/StatCompare/archive/master.zip)**
3. Extract the zip file wherever you want
4. Copy the folder "StatCompare" to Wow_Folder\Interface\AddOns. Your addon folder should look like this :
```
├── WoW_Folder
    ├── Interface
        ├── Addons
            ├── StatCompare
            	├── StatCompare.toc
```

## Configuration

```
/statc on | off       - Turns on/off the addon
/statc debug on | off - Prints debug information. Primarily useful if you discover an enchant is displaying incorrectly, it will show the effect ID in the Stat panel. Send a bug ticket on the github page, [here](https://github.com/grimfiendish/StatCompare/).
```

## Found a bug?

If you find an issue with the enchants, turn on debugging with `/statc debug on` then send me the ID and the correct name of the enchant via a bug ticket on [the project's github page](https://github.com/grimfiendish/StatCompare). If you're on a custom server, note that.

