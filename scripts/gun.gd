extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
	follow_cursor()

func shoot(): 
	print("Shooting!")
	for bullet in get_tree().get_nodes_in_group("player_bullet"):
		bullet.speed = 2000
		bullet.direction = (get_global_mouse_position() - bullet.global_position).normalized()
		print(str(bullet.direction) + " " + str(bullet.speed))
		
func follow_cursor():
	var mouse_position = get_global_mouse_position()
	var angle_delta = (mouse_position - global_position).angle()
	rotation = angle_delta
