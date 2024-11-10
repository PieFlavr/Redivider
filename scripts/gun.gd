extends Node2D  # Inheriting from Node2D for 2D node functionality

# Defines the base direction of the shot (right by default)
var base_direction : Vector2 = Vector2(1, 0)

# Variable to store the end position of the shot
var end_position : Vector2

# Length of the shot (distance from the base position)
var length = 32

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	pass  # Placeholder function (does nothing currently)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Get the player's position relative to this node (assuming player is a sibling node)
	var player_position = get_node("../player").position
	position = player_position
	
	# Calculate the end position for the shot, offset by 'length' and rotated based on the node's rotation
	end_position = position + length * base_direction.rotated(rotation)
	
	# Check if the "shoot" input action is just pressed (e.g., the player clicks a button or key)
	if Input.is_action_just_pressed("shoot"):
		shoot()  # Call the shoot function to fire a bullet
	
	# Update the node's rotation to follow the cursor
	follow_cursor()


# Function to handle shooting a bullet
func shoot(): 
	# Preload the bullet scene and instantiate it (create a new bullet object)
	var bullet = preload("res://scenes/player_bullet.tscn").instantiate()
	
	# Add the bullet to the "player_bullet" group or container node in the scene tree
	get_parent().get_node("player_bullet").add_child(bullet)

	# Set the bullet's direction based on the rotation of the shooting node
	bullet.velocity = 2000*base_direction.rotated(rotation)
	
	# Set the bullet's global position to the calculated end position
	bullet.global_position = end_position
	
	bullet.projectile.visible = true
	
	# Optional: This part can be used for the future  like "unshooting" bullets or adjusting their direction

	# Might use later for "unshooting bullets"
	#for bullet in get_tree().get_nodes_in_group("player_bullet"):
	#	bullet.speed = 2000
	#	bullet.direction = (get_global_mouse_position() - bullet.global_position).normalized()
	#	print(str(bullet.direction) + " " + str(bullet.speed))


# Function to make the node follow the cursor's position and rotate towards it
func follow_cursor():
	# Get the global position of the mouse
	var mouse_position = get_global_mouse_position()
	
	# Calculate the angle between the node's current position and the mouse position
	var angle_delta = (mouse_position - global_position).angle()
	
	# Update the node's rotation to match the angle to the mouse position
	rotation = angle_delta
