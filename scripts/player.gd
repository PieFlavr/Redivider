extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction : int = 0

var input_activity : bool
var mouse_moved : bool
var last_mouse_pos : Vector2
var last_input_time : float
const idle_timeout : float = 0.05
const idle_zone_factor : Vector2 = Vector2(4.0, 4.0)

var redHotFactor : float = 0.95

# Imma just gonna call the "rewind" chontros
var chrontos : bool = false
var chrontos_length : float = 10.0
var record_values = {
	"position": [],
	"rotation": [],
	"velocity": [],
	"direction" : [],
}

@onready var collision_box: CollisionShape2D = $CollisionBox
@onready var dudebro: AnimatedSprite2D = $dudebro

func _process(delta : float) -> void:
	if Input.is_action_pressed("its_rewind_time"):
		reverse()
	else:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		direction = Input.get_axis("move_left", "move_right")
		
	if Input.is_action_just_released("its_rewind_time"):
		reverse(true)
	
func _physics_process(delta: float) -> void:
	input_activity = Input.is_action_pressed("move_left")
	input_activity = input_activity or Input.is_action_pressed("move_right")
	input_activity = input_activity or Input.is_action_pressed("jump")

	mouse_moved = get_viewport().get_mouse_position() != last_mouse_pos
	
	if input_activity or mouse_moved:
		last_input_time = Time.get_ticks_msec() / 1000.0
	
	if (Time.get_ticks_msec() / 1000.0 - last_input_time > idle_timeout):
		Engine.time_scale = max(0.05,Engine.time_scale*redHotFactor)
	else:
		Engine.time_scale = min(1.0,Engine.time_scale*(1/redHotFactor))
		
	if (!Input.is_action_pressed("its_rewind_time") or !chrontos):
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		move_and_slide()
	
	if (is_on_floor() or chrontos):
		if direction == 0:
			dudebro.play("default")	
		else: 
			dudebro.play("run")		
			
	if direction > 0:
		dudebro.flip_h = false
	elif direction < 0:
		dudebro.flip_h = true

	chrontos_process(delta)
	last_mouse_pos =  get_viewport().get_mouse_position()
		
# Chrontos Package
func chrontos_process(delta : float) -> void:
	if (!chrontos):
		if (chrontos_length * Engine.physics_ticks_per_second == record_values["position"].size()):
			for value in record_values.keys():
				record_values[value].pop_front()
		
		record_values["position"].append(global_position)
		record_values["rotation"].append(rotation)
		record_values["velocity"].append(velocity)
		record_values["direction"].append(direction)
	else:
		compute_rewind(delta)
			
func reverse(invert : bool = false) -> void:
	chrontos = true if !invert else false
	collision_box.set_deferred("disabled",true if !invert else false)
	
func compute_rewind(delta : float) -> void:
	var pos = record_values["position"].pop_back()
	var rot = record_values["rotation"].pop_back()
	var vel = record_values["velocity"].pop_back()
	var dir = record_values["direction"].pop_back()
		
	rotation = rot if rot != null else rotation
	global_position = pos if pos != null else global_position
	velocity = vel if vel != null else velocity
	direction = dir if dir != null else direction
	
