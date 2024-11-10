extends RigidBody2D

var speed = 200
var kill_speed = 200
var direction = Vector2(1,0)
var old_position = Vector2()
var friendly_faction

const dead_zone = Vector2(1,1)

@onready var collision_shape_2d: CollisionShape2D = $KillZone/CollisionShape2D
@onready var kill_zone: Area2D = $KillZone

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 3

func _physics_process(delta: float) -> void:
	old_position = position
	move_and_collide(direction * speed * delta)
	animated_sprite_2d.rotation = direction.angle()
	
	if(speed < kill_speed):
		disable_killing()
	else:
		disable_killing(true)
	
	if(is_stuck()):
		stop()

func _on_body_entered(body: Node) -> void:
	if(body is TileMapLayer):
		stop()
		disable_killing()
	else:
		collision_mask = 0b00000000_00000000_00000000_00000000
	
func stop():
	linear_velocity = Vector2.ZERO
	freeze = true
	speed = 0

func disable_killing(invert: bool = false):
	collision_shape_2d.set_deferred("disabled",true if !invert else false)
	kill_zone.killing = false if !invert else true
	collision_mask = 0b00000000_00000000_00000000_00000000 if !invert else 0b00000000_00000000_00000000_00000001
	
func is_stuck() -> bool:
	return ((position < (old_position+dead_zone) and (position > (old_position-dead_zone))))
		
	
