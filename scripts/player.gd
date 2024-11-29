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

# Rewind mechanic flags and data
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

# Main process for input and movement
func _process(delta : float) -> void:
	if Input.is_action_pressed("its_rewind_time"):
		reverse()  # Activate rewind
	else:
		# Handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Get movement direction
		direction = Input.get_axis("move_left", "move_right")
		
	if Input.is_action_just_released("its_rewind_time"):
		reverse(true)  # Deactivate rewind
	
# Physics-based movement and time scale adjustments
func _physics_process(delta: float) -> void:
	# Check for any input or mouse movement
	input_activity = Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("jump")
	mouse_moved = get_viewport().get_mouse_position() != last_mouse_pos
	
	# Update last input time if activity detected
	if input_activity or mouse_moved:
		last_input_time = Time.get_ticks_msec() / 1000.0
	
	# Adjust time scale based on idle time
	if (Time.get_ticks_msec() / 1000.0 - last_input_time > idle_timeout):
		Engine.time_scale = max(0.01, Engine.time_scale * redHotFactor)
	else:
		Engine.time_scale = min(1.0, Engine.time_scale * (1 / redHotFactor))
	
	# Apply physics and movement unless in rewind mode
	if (!Input.is_action_pressed("its_rewind_time") or !chrontos):
		if not is_on_floor():
			velocity += get_gravity() * delta  # Apply gravity if not on floor
		if direction:
			velocity.x = direction * SPEED  # Move left/right
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)  # Decelerate to zero if no input
		move_and_slide()  # Apply movement

	# Handle animation states based on movement
	if (is_on_floor() or chrontos):
		if direction == 0:
			dudebro.play("default")  # Idle animation
		else: 
			dudebro.play("run")  # Running animation
	
	# Flip sprite based on movement direction
	if direction > 0:
		dudebro.flip_h = false
	elif direction < 0:
		dudebro.flip_h = true

	# Process rewind actions
	chrontos_process(delta)
	last_mouse_pos = get_viewport().get_mouse_position()

# Rewind mechanics - record and process time states
func chrontos_process(delta : float) -> void:
	if (!chrontos):
		# Trim the record values if max length is reached
		if (chrontos_length * Engine.physics_ticks_per_second == record_values["position"].size()):
			for value in record_values.keys():
				record_values[value].pop_front()
		
		# Record current state
		record_values["position"].append(global_position)
		record_values["rotation"].append(rotation)
		record_values["velocity"].append(velocity)
		record_values["direction"].append(direction)
	else:
		# Perform rewind
		compute_rewind(delta)

# Toggle rewind mode and disable collision box
func reverse(invert : bool = false) -> void:
	chrontos = true if !invert else false
	collision_box.set_deferred("disabled", true if !invert else false)

# Apply the rewinded state to the character
func compute_rewind(delta : float) -> void:
	var pos = record_values["position"].pop_back()
	var rot = record_values["rotation"].pop_back()
	var vel = record_values["velocity"].pop_back()
	var dir = record_values["direction"].pop_back()
		
	# Revert to the last recorded state if available
	rotation = rot if rot != null else rotation
	global_position = pos if pos != null else global_position
	velocity = vel if vel != null else velocity
	direction = dir if dir != null else direction
