extends KinematicBody2D

export(float) var GRAVITY = 20;
export(float) var MAX_GRAVITY = 200;
export(float) var MOVE_SPEED = 100;
export(float) var JUMP_FORCE = 300;

var grounded: bool;
var motion: Vector2;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	grounded = is_on_floor();

	motion.y = clamp(motion.y, -JUMP_FORCE, MAX_GRAVITY);
	motion.x = clamp(motion.x, -MOVE_SPEED, MOVE_SPEED);

	if Input.is_action_pressed("left"):
		motion.x += -MOVE_SPEED;
	elif Input.is_action_pressed("right"):
		motion.x += MOVE_SPEED;
	else:
		motion.x = lerp(motion.x, 0, 0.2);
	
	if Input.is_action_just_pressed("jump"):
		motion.y = -JUMP_FORCE;
	
	motion.y += GRAVITY;

	motion = move_and_slide(motion, Vector2.UP);