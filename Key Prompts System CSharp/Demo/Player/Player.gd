extends KinematicBody2D

export(float) var GRAVITY = 2500;
export(float) var MAX_GRAVITY = 5000;
export(float) var MOVE_SPEED = 5000;
export(float) var JUMP_FORCE = 20000;

var grounded: bool;
var motion: Vector2;

var input_vector: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	grounded = is_on_floor();

	motion.y = clamp(motion.y, -JUMP_FORCE * delta, MAX_GRAVITY * delta);
	motion.x = clamp(motion.x, -MOVE_SPEED * delta, MOVE_SPEED * delta);

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
	input_vector.y  = Input.get_action_strength("ui_up");

	if input_vector.x != 0:
		motion.x += input_vector.x * MOVE_SPEED * delta;
	else:
		motion.x = lerp(motion.x, 0, 0.2);
	
	if input_vector.y != 0 && grounded:
		motion.y = -input_vector.y * -JUMP_FORCE * -delta;
	
	if !grounded:
		motion.y += GRAVITY * delta;

	motion = move_and_slide(motion, Vector2.UP);
