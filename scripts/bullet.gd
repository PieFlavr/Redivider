extends RigidBody2D

var speed = 200
var direction = Vector2(1,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1

func _physics_process(delta: float) -> void:
	move_and_collide(direction * speed * delta)
	

func _on_body_entered(body: Node) -> void:
	linear_velocity = Vector2.ZERO
	speed = 0
