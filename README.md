<p align="center"><img src="/media/keyprompts-logo-transparent.png" alt="transparent-logo" width="500px" height="250px"></p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
[![Supported Platforms](https://img.shields.io/badge/Supported%20Platforms-Windows%2C%20macOS%2C%20X11%20(Linux%2C%20*BSD)%2C%20Android%2C%20iOS%2C%20Web-blue)](https://docs.godotengine.org/en/stable/about/faq.html#which-platforms-are-supported-by-godot)
[![Repo Size](https://img.shields.io/github/repo-size/CliveDev0413/key-prompts-system-godot?color=red&label=Repo%20Size)](https://youtu.be/dQw4w9WgXcQ)
[![Downloads](https://img.shields.io/github/downloads/CliveDev0413/key-prompts-system-godot/latest/total?label=Downloads%40latest&style=plastic)](https://github.com/CliveDev0413/key-prompts-system-godot/releases/latest)
[![Discord](https://img.shields.io/discord/951678426165690428?color=%235865F2&label=Discord)](https://discord.gg/6cspbzBnPs)

# Key prompts system for Godot

<p align="center"><img src="/media/keyprompt-showcase.gif" alt="keyprompt-showcase" width="600px" height="338px"></p>

Implement key/button prompts into Godot easily. This has been upgraded for Godot 4!

This system currently supports key prompts for:

- Keyboard and Mouse
- PS4 Controller
- PS5 Controller **NEW**
- Xbox One Controller
- Xbox Series Controller **NEW**

Xbox One Controller prompts will be used for controllers that are unsupported.

You can also download this from the [Itch.io page.](https://clive-dev.itch.io/key-prompts-system-godot)

Special thanks to [Those Awesome Guys](https://thoseawesomeguys.com/prompts/) for the button prompt textures!

# Tutorial
I will now teach you how to implement the key prompt system

# For the GDScript version
1. To the side of this Github page, you should see the releases. Download the latest release.
2. Unzip the file, open it, and drag and drop the `Key Prompts System GDScript` folder into your game. Make sure it isn't inside any other folders. 
3. Inside the `Key Prompts System GDScript` folder, you will see a file named `KeyPrompt.tscn`. Drag it into your level/scene.
4. Resize it if you want
5. Click on it and set the action variable.

The action variable is supposed to be set to the name of the action you want the prompt to show. For example, the `jump` action which uses the **space bar** or the **x/a button on a controller**

![action-example](media/action-example.png)

6. After setting the action variable, go to the [exporting section](#when-exporting) for instructions on what to do before exporting your game.

# For the C# verison
> ### **NOTICE: The C# version of this asset will not be continued! I will be keeping this guide here for the people that want to use the Godot 3 version!**

---

1. Follow the steps of the GDScript version but instead of using `Key Prompts System GDScript` folder, use the `Key Prompts System CSharp` folder.

Now you have to install the [Newtonsoft Json.Net Nuget Package](https://www.newtonsoft.com/json).
If you're using Visual Studio Community, just use the Nuget Package Manager.
If you're using Visual Studio Code, just use [this Nuget Package extension](https://marketplace.visualstudio.com/items?itemName=jmrog.vscode-nuget-package-manager) or look for another one.

# When exporting
Add `*.json` to the resources tab

![json-example](media/json-example.png)

# Questions you would probably ask

### Q. How do I customize the look of the prompts?
Well.. The easiest way I could think of is if you just draw or add images on top of the button prompt sprite sheet that you want to customize. If you want to make an entirely different sprite sheet, you gotta edit the json files located in the `ButtonPromptTextures` folder which is very tedious. There currently is no fancy system behind this that can make you easily customize the prompt textures.

### Q. Will you add more controller prompts?
Hopefully! Though I only got a PS4 controller so I can't test other controller prompts. If you find any bugs, [contact me](https://clivedev.tk)!

# Licensing
The key/button prompt system is free for commercial and personal projects. You can also remix and edit the code for your personal uses.

# Donations
If you would like to donate, you can donate to [my Kofi](https://ko-fi.com/clivedev).

I have a [Patreon](https://patreon.com/clivedev) also.
