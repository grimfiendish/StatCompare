# StatCompare v1.8 for Vanilla World of Warcraft v 1.12.1
StatCompare adds a stats panel next to your Character and Inspection Panes, making it easy to screenshot your stats for gear checks or compare your gear to your target.

This version has been updated to make gear checks easier by showing the list of equipped item names and their enchants, as well as all active buffs.

<b>As of January 2025 the enchants and buff info is considered beta</b>

## Screenshot

View  your own stats (e.g. for Gear Checks)

![Use StatCompare to view your own stats](https://raw.githubusercontent.com/grimfiendish/StatCompare/391ff026dbcefe209e248533717122044644b0fe/media/stats_on_self.jpg)

View detailed stats on your inspection target

![Use StatCompare to compare with others](https://raw.githubusercontent.com/grimfiendish/StatCompare/391ff026dbcefe209e248533717122044644b0fe/media/compare_stats.jpg)

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
