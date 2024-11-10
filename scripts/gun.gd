extends Node2D

var base_direction : Vector2 = Vector2(1,0)
var end_position : Vector2
var length = 32
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position = get_node("../player").position
	position = player_position
	end_position = position + length*base_direction.rotated(rotation)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	follow_cursor()
	# print(str(end_position))
	

func shoot(): 
	# print("Shooting!")
	var bullet = preload("res://scenes/bullet.tscn").instantiate()
	get_tree().get_root().add_child(bullet)
	bullet.global_position = end_position
	bullet.direction = base_direction.rotated(rotation)
	bullet.speed = 2000
	#print(str(bullet.direction))
	
	# might use later for "unshooting bullets"
	#for bullet in get_tree().get_nodes_in_group("player_bullet"):
	#	bullet.speed = 2000
	#	bullet.direction = (get_global_mouse_position() - bullet.global_position).normalized()
	#	print(str(bullet.direction) + " " + str(bullet.speed))
		
func follow_cursor():
	var mouse_position = get_global_mouse_position()
	var angle_delta = (mouse_position - global_position).angle()
	rotation = angle_delta
