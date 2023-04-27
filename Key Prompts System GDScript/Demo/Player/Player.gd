extends CharacterBody2D

@export var GRAVITY: float = 2500;
@export var MAX_GRAVITY: float = 5000;
@export var MOVE_SPEED: float = 5000;
@export var JUMP_FORCE: float = 20000;

var grounded: bool;
var motion: Vector2 = Vector2.ZERO;

var input_vector: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.

func _process(_delta):
	grounded = is_on_floor();

	motion.y = clamp(motion.y, -JUMP_FORCE, MAX_GRAVITY);
	motion.x = clamp(motion.x, -MOVE_SPEED, MOVE_SPEED);

	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left");
	input_vector.y = Input.get_action_strength("jump");

	if input_vector.x != 0:
		motion.x += input_vector.x * MOVE_SPEED;
	else:
		motion.x = lerp(motion.x, 0.0, 0.2);
	
	if Input.is_action_just_pressed("jump") && grounded:
		motion.y = input_vector.y * -JUMP_FORCE;
	
	if !grounded:
		motion.y += GRAVITY;
		
	set_velocity(motion);
	set_up_direction(Vector2.UP);
	move_and_slide();
