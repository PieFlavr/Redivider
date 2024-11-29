extends RigidBody2D

# By default, projectile do NOT interact!!! Must enable in code (good rule of thumb for entity discrimination)
# By default, no gravity either!
var doPhysics : bool = true # For manipulating the _physics_process() from outside

var velocity : Vector2 = Globals.proj_speed * Globals.proj_direction

const dead_zone : Vector2 = Globals.dead_zone # Area to check for "stuckness"
var old_position : Vector2 # For "stuckness" checking

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(0,0) # Default in case of errors/bad nulls
	visible = false # Default hidden, must be unhidden
	contact_monitor = true # Enables collision detection
	max_contacts_reported = 3 # Max number of contacts/collisions reported

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(doPhysics):
		old_position = position # Store old position for is_stuck() checking
		linear_velocity = velocity # Object actual iteration!
		rotation = velocity.angle()
		# move_and_collide(velocity * delta) # old iteration ofr testing

func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.
	
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
