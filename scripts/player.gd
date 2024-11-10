extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var direction : int = 0

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
	
