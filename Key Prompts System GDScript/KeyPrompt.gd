extends Node2D

enum Controllers{
	ps4,
	xboxOne,
}

var using_keyboard: bool;
var connected_controller;

@export var ACTION: String = "";

@export var KEYBOARD_FRAMES_JSON_PATH: String = "res://Key Prompts System GDScript/ButtonPromptTextures/keyboardFrames.json";
@export var PS4_FRAMES_JSON_PATH: String = "res://Key Prompts System GDScript/ButtonPromptTextures/ps4Frames.json";
@export var XBOX_ONE_FRAMES_JSON_PATH: String = "res://Key Prompts System GDScript/ButtonPromptTextures/xboxOneFrames.json";

@export var LIGHT_THEMED_KEYBRD_KEYS: bool;

var controller_name: String;

var keyboard: Dictionary;
var buttons: Dictionary;

# Sprites
@onready var blank_key = $Blank;
@onready var keybrd_dark = $Keyboard_Dark;
@onready var keybrd_light = $Keyboard_Light;
@onready var ps4 = $PSFour;
@onready var xbox_one = $Xbox_One;

# JSON Files
var keyboard_frames_json: FileAccess;
var ps4_frames_json: FileAccess;
var xbox_one_frames_json: FileAccess;

# JSON Files but text
var keyboard_json_to_text: String;
var ps4_json_to_text: String;
var xbox_one_json_to_text: String;


func _ready():
	load_json_files();
	convert_all_json_to_text();
	
	var test_json_conv = JSON.new()
	test_json_conv.parse(keyboard_json_to_text);
	keyboard = test_json_conv.get_data()
	
	#Show keyboard prompt as default
	using_keyboard = true;
	process_inputs("none");

func _input(event):
	if event is InputEventKey:
		using_keyboard = true;
		controller_name = "none";
	elif event is InputEventJoypadButton || event is InputEventJoypadMotion:
		using_keyboard = false;
		controller_name = Input.get_joy_name(Input.get_connected_joypads().find(event.device))

		get_controller_type(controller_name);
	
	process_inputs(controller_name);

func process_inputs(_controller_name):
	var inputs;

	assert(ACTION != "") ; # Checks if the ACTION variable is assigned

	inputs = InputMap.action_get_events(ACTION);

	var has_controller_input: bool;

	var key_name: String = "";
	var button_properties: InputEventJoypadButton = null;
	var joystick_properties: InputEventJoypadMotion = null;
	var mouse_properties: InputEventMouseButton = null;
	
	for input in inputs:
		if input is InputEventKey:
			key_name = input.as_text().to_lower();
		elif input is InputEventJoypadButton:
			button_properties = input;
			has_controller_input = true;
		elif input is InputEventJoypadMotion:
			joystick_properties = input;
			has_controller_input = true;
		elif input is InputEventMouseButton:
			mouse_properties = input;
	
	hide_all_prompts();

	if using_keyboard:
		if LIGHT_THEMED_KEYBRD_KEYS:
			keybrd_light.visible = true;

			if mouse_properties != null:
				keybrd_light.frame = keyboard[mouse_button_index_to_name(mouse_properties.button_index).to_lower()];
				return;

			keybrd_light.frame = keyboard[key_name];
		else:
			keybrd_dark.visible = true;

			if mouse_properties != null:
				keybrd_dark.frame = keyboard[mouse_button_index_to_name(mouse_properties.button_index).to_lower()];
				return;

			keybrd_dark.frame = keyboard[key_name];
	elif !using_keyboard && has_controller_input:
		if connected_controller == Controllers.ps4:
			ps4.visible = true;

			if joystick_properties != null:
				if joystick_properties.axis == 0 || joystick_properties.axis == 1:
					ps4.frame = buttons["left-stick"];
				elif joystick_properties.axis == 2 || joystick_properties.axis == 3:
					ps4.frame = buttons["right-stick"];
				elif joystick_properties.axis == 4:
					ps4.frame = buttons["left-trigger"];
				elif joystick_properties.axis == 5:
					ps4.frame = buttons["right-trigger"];
				return;
		
			ps4.frame = buttons[str(button_properties.button_index)];
		elif connected_controller == Controllers.xboxOne:
			xbox_one.visible = true;

			if joystick_properties != null:
				if joystick_properties.axis == 0 || joystick_properties.axis == 1:
					xbox_one.frame = buttons["left-stick"];
				elif joystick_properties.axis == 2 || joystick_properties.axis == 3:
					xbox_one.frame = buttons["right-stick"];
				elif joystick_properties.axis == 4:
					ps4.frame = buttons["left-trigger"];
				elif joystick_properties.axis == 5:
					ps4.frame = buttons["right-trigger"];
				return;
		
			xbox_one.frame = buttons[str(button_properties.button_index)];	

func get_controller_type(_controller_name: String):
	match(_controller_name.to_lower()):
		"ps4 controller":
			var test_json_conv = JSON.new()
			test_json_conv.parse(ps4_json_to_text);
			buttons = test_json_conv.get_data()
			connected_controller = Controllers.ps4;
		"xbox one controller":
			var test_json_conv = JSON.new()
			test_json_conv.parse(xbox_one_json_to_text);
			buttons = test_json_conv.get_data()
			connected_controller = Controllers.xboxOne;
		"xinput gamepad":
			var test_json_conv = JSON.new()
			test_json_conv.parse(xbox_one_json_to_text);
			buttons = test_json_conv.get_data()
			connected_controller = Controllers.xboxOne;
		_:
			var test_json_conv = JSON.new()
			test_json_conv.parse(xbox_one_json_to_text);
			buttons = test_json_conv.get_data()
			connected_controller = Controllers.xboxOne;

func hide_all_prompts():
	blank_key.visible = false;
	keybrd_dark.visible = false;
	keybrd_light.visible = false;
	ps4.visible = false;
	xbox_one.visible = false;

func load_json_files():
	
	#Checking if the JSON files are okay before reading them
	assert(FileAccess.file_exists(KEYBOARD_FRAMES_JSON_PATH)) ;
	assert(FileAccess.file_exists(PS4_FRAMES_JSON_PATH)) ;
	assert(FileAccess.file_exists(XBOX_ONE_FRAMES_JSON_PATH)) ;
	
	keyboard_frames_json = FileAccess.open(KEYBOARD_FRAMES_JSON_PATH, FileAccess.READ);
	ps4_frames_json = FileAccess.open(PS4_FRAMES_JSON_PATH, FileAccess.READ);
	xbox_one_frames_json = FileAccess.open(XBOX_ONE_FRAMES_JSON_PATH, FileAccess.READ);
	
func convert_all_json_to_text():
	keyboard_json_to_text = keyboard_frames_json.get_as_text();
	ps4_json_to_text = ps4_frames_json.get_as_text();
	xbox_one_json_to_text = xbox_one_frames_json.get_as_text();

func mouse_button_index_to_name(button_index: int):
	match(button_index):
		1:
			return "MOUSE_BUTTON_LEFT";
		2:
			return "MOUSE_BUTTON_RIGHT";
		3:
			return "MOUSE_BUTTON_MIDDLE";
		4:
			return "MOUSE_BUTTON_WHEEL_UP";
		5:
			return "MOUSE_BUTTON_WHEEL_DOWN";
		6:
			return "MOUSE_BUTTON_WHEEL_LEFT";
		7:
			return "MOUSE_BUTTON_WHEEL_RIGHT";
		_:
			return "invalid";
