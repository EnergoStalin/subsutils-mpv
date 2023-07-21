# SubtitleTranslateMPV
[![wakatime](https://wakatime.com/badge/user/e95ece5f-54ed-4ef2-9ff3-b88a5a8bfc5c/project/ff0b8a46-c4f1-4805-a7a2-096874f3ed18.svg)](https://wakatime.com/badge/user/e95ece5f-54ed-4ef2-9ff3-b88a5a8bfc5c/project/ff0b8a46-c4f1-4805-a7a2-096874f3ed18)

![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)

> 📝
> `~~` reffering to [mpv config folder](https://mpv.io/manual/stable/#script-location)

> ⚠️ Some languages may not work out of the box because of current provider read [dependencies](#⚠️-optional-but-for-now-required-dependencies) below

Modular script for auto translating subtitles on the fly into multiple languages.
You can extend it with you favorite translator by contributing one.
## 🌿 Features
- Auto enable when `toLang` not match any subtitle stream.
- Auto correct subtitle offset for comfort watching without delays.
- Register 4 script messages what you can bind via `~~/input.conf`.
    - Toggle messages
        - sub-translated-only
        - sub-primary-original
    - enable-sub-translator
    - disable-sub-translator

## ⬇️ Install
- Clone repository into `~~/scripts` folder
- Setup default settings for mpv and script itself described below
- Install dependencies described below and make sure them accessible from path

## ⚙️ Options
Avalible options `~~/script-opts/subtitle-translate-mpv.conf` with default values
```conf
# Initial subtitle delay for translator
defaultDelay=-0.5
# Which script to use as translator(see translators folder in repository)
translator=crow
# Show only primary text
translatedOnly=yes
# Use original text as primary
primaryOriginal=no
# Used in translator
fromLang=en
toLang=ru
# Font for showed text
osdFont=Arial
# When any subitle stream language don't match toLang
# (match performed by lua string.find())
# Or there any external subtitle with unknown language
autoEnableTranslator=yes
```
## 🧾 Recommended input.conf
```conf
CTRL+t script-message enable-sub-translator
CTRL+T script-message disable-sub-translator
ALT+t script-message sub-translated-only
ALT+o script-message sub-primary-original
```
## ⚠️ Optional but for now required dependencies
CrowTranslate for translation text see [crow.lua](https://github.com/EnergoStalin/subutils-mpv/blob/master/modules/translators/crow.lua)
> ⚠️⚠️⚠️ Crow may decide to encode your language not into utf-8 then **script will not work**(fixed for russian by tricking [encoding](https://github.com/EnergoStalin/subtitle-translate-mpv/blob/master/modules/translators/encodings/auto.lua)) should work for major languages tho

Avalible via winget
```powershell
winget install --id CrowTranslate.CrowTranslate
```
