extends Node2D

const kill_speed : float = 200 # Speed threshold which bullet stops killing.

@onready var reversible_object: Node2D = $reversible_object
@onready var projectile: RigidBody2D = $reversible_object/projectile

@onready var collision_shape_2d: CollisionShape2D = $reversible_object/projectile/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $reversible_object/projectile/AnimatedSprite2D

var velocity = null: set = set_velocity, get = get_velocity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reversible_object.add_rewind_key("velocity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("its_rewind_time"):
		projectile.doPhysics = false
	else:
		projectile.doPhysics = true

# Called every physics frame
func _physics_process(delta : float) -> void:
	if(projectile.velocity.length() < kill_speed):
		pass # disable effect zone
	else:
		pass # enable effect zone
	reversible_object.rewind_process(delta) # Handles rewinding & value recording

# Collision handling
func _on_projectile_body_entered(body: Node) -> void:
	pass # Replace with function body.
	if(body is TileMapLayer):
		# stop()
		# disable_killing()  # Disable killing so it doesn't destroy anything in the future
		pass
	else:
		# Disable collisions by setting the collision mask to 0 (no collisions)
		# collision_mask = 0b00000000_00000000_00000000_00000000
		pass

func _on_projectile_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.

#func stop():
	#linear_velocity = Vector2.ZERO  # Stop any movement
	#freeze = true  # Freeze the bullet so it doesn't move
	#speed = 0  # Set speed to 0 to stop further movement
#
## Toggles the ability of the bullet to kill (based on the 'invert' argument)
#func disable_killing(invert: bool = false):
	## Disable or enable the collision shape's ability to interact with other objects
	#collision_shape_2d.set_deferred("disabled", true if !invert else false)
	#
	## Set the 'killing' property of the kill zone (to either kill or not)
	#kill_zone.killing = false if !invert else true
	#
	## Set the collision mask depending on whether killing is enabled or not
	## If killing is disabled, set the collision mask to 0 (no collisions)
	#collision_mask = 0b00000000_00000000_00000000_00000000 if !invert else 0b00000000_00000000_00000000_00000001
	
func set_velocity(new_velocity : Vector2) -> void:
	projectile.velocity = new_velocity
	
func get_velocity() -> Vector2:
	return projectile.velocity
	
