using Godot;
using System;
using static Godot.GD;
using Newtonsoft.Json;
using System.Collections.Generic;

public class KeyPrompt : Node2D
{
	enum Controllers
	{
		ps4,
		xboxOne,
	}

	private bool usingKeyboard = true;
	private Controllers connectedController;

	[Export]
	public string action = "";

	[Export]
	public string keyboardFramesJsonPath = "res://Key Prompts System CSharp/ButtonPromptTextures/keyboardFrames.json";

	[Export]
	public string ps4FramesJsonPath = "res://Key Prompts System CSharp/ButtonPromptTextures/ps4Frames.json";

	[Export]
	public string xboxOneFramesJsonPath = "res://Key Prompts System CSharp/ButtonPromptTextures/xboxOneFrames.json";

	[Export]
	public bool lightThemedKeybrdKeys = false;

	private string controllerName = "none";

	Dictionary<string, int> keyboard = new Dictionary<string, int>();
	Dictionary<string, int> buttons = new Dictionary<string, int>();

	//Sprites
	private Sprite blankKey;
	private Sprite keybrdDark;
	private Sprite keybrdLight;
	private Sprite ps4;
	private Sprite xboxOne;

	//JSON Files
	private File keyboardFramesJson;
	private File ps4FramesJson;
	private File xboxOneFramesJson;

	//JSON Files but text
	private string keyboardJsonToText;
	private string ps4JsonToText;
	private string xboxOneJsonToText;

	public override void _Ready()
	{
		//Load the json files
		LoadJsonFiles();

		//Convert the json to text 
		//(cause from what I know, newtonsoft json only converts jsons when its a string)
		ConvertAllJsonToText();    
		
		//Get all the sprites
		blankKey = GetNode<Sprite>("Blank");
		keybrdDark = GetNode<Sprite>("Keyboard_Dark");
		keybrdLight = GetNode<Sprite>("Keyboard_Light");
		ps4 = GetNode<Sprite>("PS4");
		xboxOne = GetNode<Sprite>("Xbox_One");

		//Get the frames of the keys
		keyboard = JsonConvert.DeserializeObject<Dictionary<string, int>>(keyboardJsonToText);    
	}

	public override void _Input(InputEvent inputEvent)
	{
		//if the input is from a keyboard
		if(inputEvent is InputEventKey)
		{
			usingKeyboard = true;
			controllerName = "none";
		}
		//if the input is from a controller
		else if(inputEvent is InputEventJoypadButton || inputEvent is InputEventJoypadMotion)
		{
			usingKeyboard = false;
			controllerName = Input.GetJoyName(Input.GetConnectedJoypads().IndexOf(inputEvent.Device));

			//Gets the type of controller (Playstation, Xbox, Nintendo, etc)
			getControllerType(controllerName);
		}

		processInputs(controllerName);
	}

	private void processInputs(string _controllerName)
	{
		//The inputs from the action in the input map
		Godot.Collections.Array inputs; 

		try
		{
			inputs = InputMap.GetActionList(action);
		}
		catch(Exception err)
		{
			PushError($"The action variable is not assigned: {err}");
			GetTree().Quit();
			return;
		}

		//If the action supports controller or if it reacts to controller input
		bool hasControllerInput = false;

		string keyName = "";
		InputEventJoypadButton buttonProperties = null;
		InputEventJoypadMotion joystickProperties = null;
		InputEventMouseButton mouseProperties = null;
		//InputEventMouseMotion mouseMovementProperties = null;


		//Check the inputs in the action
		foreach(InputEvent input in inputs)
		{
			if(input is InputEventKey)
			{
				keyName = input.AsText().ToLower();
			}
			else if(input is InputEventJoypadButton)
			{
				buttonProperties = (InputEventJoypadButton)input;
				hasControllerInput = true;
			}
			else if(input is InputEventJoypadMotion)
			{
				joystickProperties = (InputEventJoypadMotion)input;
				hasControllerInput = true;
			}
			else if(input is InputEventMouseButton)
			{
				mouseProperties = (InputEventMouseButton)input;
			}
		}

		hideAllPrompts();

		if(usingKeyboard)
		{
			if(lightThemedKeybrdKeys)
			{
				keybrdLight.Visible = true;

				if(mouseProperties != null)
				{
					keybrdLight.Frame = keyboard[mouseButtonIndexToButtonName(mouseProperties.ButtonIndex).ToLower()];
					return;
				}

				keybrdLight.Frame = keyboard[keyName];
			}
			else
			{
				keybrdDark.Visible = true;

				if(mouseProperties != null)
				{
					keybrdDark.Frame = keyboard[mouseButtonIndexToButtonName(mouseProperties.ButtonIndex).ToLower()];
					return;
				}

				keybrdDark.Frame = keyboard[keyName];
			}
		}
		//If using a controller and the action supports controller
		else if(!usingKeyboard && hasControllerInput)
		{
			if(connectedController == Controllers.ps4)
			{
				ps4.Visible = true;

				if(joystickProperties != null)
				{
					if(joystickProperties.Axis == 0 || joystickProperties.Axis == 1)
					{
						ps4.Frame = buttons["left-stick"];
					}
					else if(joystickProperties.Axis == 2 || joystickProperties.Axis == 3)
					{
						ps4.Frame = buttons["right-stick"];
					}

					return;
				}

				ps4.Frame = buttons[buttonProperties.ButtonIndex.ToString()];
			}
			else if(connectedController == Controllers.xboxOne)
			{
				xboxOne.Visible = true;

				if(joystickProperties != null)
				{
					if(joystickProperties.Axis == 0 || joystickProperties.Axis == 1)
					{
						xboxOne.Frame = buttons["left-stick"];
					}
					else if(joystickProperties.Axis == 2 || joystickProperties.Axis == 3)
					{
						xboxOne.Frame = buttons["right-stick"];
					}

					return;
				}

				xboxOne.Frame = buttons[buttonProperties.ButtonIndex.ToString()];
			}
			else
			{
				blankKey.Visible = true;
			}
		}
	}

	private void getControllerType(string _controllerName)
	{
		switch(_controllerName.ToLower())
		{
			case "ps4 controller":
				buttons = JsonConvert.DeserializeObject<Dictionary<string, int>>(ps4JsonToText);
				connectedController = Controllers.ps4;
				break;

			case "xbox one controller":
				buttons = JsonConvert.DeserializeObject<Dictionary<string, int>>(xboxOneJsonToText);
				connectedController = Controllers.xboxOne;
				break;

			case "xinput gamepad":
				buttons = JsonConvert.DeserializeObject<Dictionary<string, int>>(xboxOneJsonToText);
				connectedController = Controllers.xboxOne;
				break;

			default:
				buttons = JsonConvert.DeserializeObject<Dictionary<string, int>>(xboxOneJsonToText);
				connectedController = Controllers.xboxOne;
				break;
		}
	}

	private void hideAllPrompts()
	{
		blankKey.Visible = false;
		keybrdDark.Visible = false;
		keybrdLight.Visible = false;
		ps4.Visible = false;
		xboxOne.Visible = false;
	}

	private void LoadJsonFiles()
	{
		keyboardFramesJson = new File();
		ps4FramesJson = new File();
		xboxOneFramesJson = new File();

		keyboardFramesJson.Open(keyboardFramesJsonPath, File.ModeFlags.Read);
		ps4FramesJson.Open(ps4FramesJsonPath, File.ModeFlags.Read);
		xboxOneFramesJson.Open(xboxOneFramesJsonPath, File.ModeFlags.Read);

		if(!keyboardFramesJson.FileExists(keyboardFramesJsonPath) ||
		   !ps4FramesJson.FileExists(ps4FramesJsonPath) ||
		   !xboxOneFramesJson.FileExists(xboxOneFramesJsonPath))
		{
			PushError("One of the json file paths are not assigned or is invalid.");
			GetTree().Quit();
		}
	}

	private void ConvertAllJsonToText()
	{
		keyboardJsonToText = keyboardFramesJson.GetAsText();
		ps4JsonToText = ps4FramesJson.GetAsText();
		xboxOneJsonToText = xboxOneFramesJson.GetAsText();
	}

	private string mouseButtonIndexToButtonName(int buttonIndex)
	{
		switch(buttonIndex)
		{
			case 1:
				return "BUTTON_LEFT";
			case 2:
				return "BUTTON_RIGHT";
			case 3:
				return "BUTTON_MIDDLE";
			case 4:
				return "BUTTON_WHEEL_UP";
			case 5:
				return "BUTTON_WHEEL_DOWN";
			case 6:
				return "BUTTON_WHEEL_LEFT";
			case 7:
				return "BUTTON_WHEEL_RIGHT";
			default:
				return "invalid";
		}
	}
}
