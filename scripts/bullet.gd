extends RigidBody2D 

@onready var collision_box: CollisionShape2D = $CollisionBox


var speed : float = 200 # Speed at which the bullet moves
const kill_speed : float = 200 # Speed threshold at which the bullet will stop killing (to allow "slow" bullets)

var direction : Vector2 = Vector2(1, 0) # Direction the bullet is facing/moving (right by default)
var old_position : Vector2 = Vector2() # Stores the position of the bullet in the previous frame for collision checks

# Imma just gonna call the "rewind" chontros
var chrontos : bool = false
var chrontos_length : float = 10.0
var record_values = {
	"position": [],
	"rotation": [],
	"velocity": [],
}

const dead_zone = Vector2(1, 1) # Defines a small dead zone around the old position for detecting if the bullet is stuck


@onready var collision_shape_2d: CollisionShape2D = $KillZone/CollisionShape2D
@onready var kill_zone: Area2D = $KillZone

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D # Animated sprite

# Called when the node is added to the scene for the first time
func _ready() -> void:
	position = Vector2(0,0)
	visible = false
	contact_monitor = true  # Enable contact monitoring to detect collisions
	max_contacts_reported = 3  # Maximum number of contacts the bullet can report

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("its_rewind_time"):
		reverse()

# Called every physics frame
func _physics_process(delta : float) -> void:
	if (!chrontos):
		# Store the bullet's position from the previous frame
		old_position = position
		
		# Move the bullet based on its direction and speed
		move_and_collide(direction * speed * delta)
		
		# Update the sprite's rotation to match the bullet's direction
		animated_sprite_2d.rotation = direction.angle()

		# If speed is less than kill speed, disable the bullet's ability to kill
		if(speed < kill_speed):
			disable_killing()
		else:
			# Otherwise, enable killing again
			disable_killing(true)
		
		# Its rewind time
		chrontos_process(delta)
		
		# If the bullet is stuck (i.e., it hasn't moved significantly), stop it
		if(is_stuck()):
			stop()
	# Its rewind time
	chrontos_process(delta)
	
# Called when another body enters the bullet's collision area
func _on_body_entered(body: Node) -> void:
	# If the bullet collides with a TileMapLayer (like a wall or obstacle), stop the bullet
	if(body is TileMapLayer):
		stop()
		disable_killing()  # Disable killing so it doesn't destroy anything in the future
	else:
		# Disable collisions by setting the collision mask to 0 (no collisions)
		collision_mask = 0b00000000_00000000_00000000_00000000

# Stops the bullet's movement and freezes it in place
func stop():
	linear_velocity = Vector2.ZERO  # Stop any movement
	freeze = true  # Freeze the bullet so it doesn't move
	speed = 0  # Set speed to 0 to stop further movement

# Toggles the ability of the bullet to kill (based on the 'invert' argument)
func disable_killing(invert: bool = false):
	# Disable or enable the collision shape's ability to interact with other objects
	collision_shape_2d.set_deferred("disabled", true if !invert else false)
	
	# Set the 'killing' property of the kill zone (to either kill or not)
	kill_zone.killing = false if !invert else true
	
	# Set the collision mask depending on whether killing is enabled or not
	# If killing is disabled, set the collision mask to 0 (no collisions)
	collision_mask = 0b00000000_00000000_00000000_00000000 if !invert else 0b00000000_00000000_00000000_00000001

# Check if the bullet is stuck by comparing its current position to its previous position
# If the position hasn't changed significantly (within a defined 'dead_zone'), consider it stuck
func is_stuck() -> bool:
	# Returns true if the bullet's position is too close to its previous position (within 'dead_zone')
	return (position < (old_position + dead_zone) and (position > (old_position - dead_zone)))



# Chrontos Package
func chrontos_process(delta : float) -> void:
	if not chrontos:
		if (chrontos_length * Engine.physics_ticks_per_second == record_values["position"].size()):
			for value in record_values.keys():
				record_values[value].pop_front()
		
		record_values["position"].append(global_position)
		record_values["rotation"].append(rotation)
		record_values["velocity"].append(linear_velocity)
	else:
		compute_rewind(delta)
			
func reverse() -> void:
	chrontos = true
	collision_box.set_deferred("disabled",true)
	
func compute_rewind(delta : float) -> void:
	var pos = record_values["position"].pop_back()
	var rot = record_values["rotation"].pop_back()
	
	if record_values["position"].is_empty():
		collision_box.set_deferred("disabled",false)
		chrontos = false
		if(pos != null):
			global_position = pos
		if(rot != null):
			rotation = rot
		if(linear_velocity != null):
			linear_velocity = record_values["velocity"][0]
		return
		
	rotation = rot
	global_position = pos
	
