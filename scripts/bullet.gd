extends RigidBody2D

var speed = 200
var kill_speed = 200
var direction = Vector2(1,0)

@onready var collision_shape_2d: CollisionShape2D = $KillZone/CollisionShape2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1

func _physics_process(delta: float) -> void:
	move_and_collide(direction * speed * delta)
	animated_sprite_2d.rotation = direction.angle()
	if(speed < kill_speed):
		collision_shape_2d.set_deferred("disabled",true)
	else:
		collision_shape_2d.set_deferred("disabled",false)

func _on_body_entered(body: Node) -> void:
	linear_velocity = Vector2.ZERO
	speed = 0
	
