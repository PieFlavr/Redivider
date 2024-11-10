extends RigidBody2D

# By default, projectile do NOT interact!!! Must enable in code (good rule of thumb for entity discrimination)
# By default, no gravity either!
var doPhysics : bool = true # For manipulating the _physics_process() from outside

var speed : float = Globals.proj_speed # Projectile speed
var direction : Vector2 = Globals.proj_direction # Projectile direction (default right)

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
		move_and_collide(direction * speed * delta) # Object actual iteration!
