extends CharacterBody2D  # Inheriting from CharacterBody2D to utilize built-in character movement functions

# Constants for movement speed and jump velocity
const SPEED = 300.0  # Character's horizontal movement speed
const JUMP_VELOCITY = -400.0  # Vertical velocity for jumping (negative for upward movement)

# Variable to store the input direction (1 for right, -1 for left, 0 for no movement)
var direction = 0

# Onready variable to reference the AnimatedSprite2D node for character animations
@onready var dudebro: AnimatedSprite2D = $dudebro

# Called every physics frame to handle character movement and physics interactions
func _physics_process(delta: float) -> void:
	# Apply gravity to the character when it's not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta  # Adding gravity to the character's velocity

	# Handle the jump action when the player presses the jump button
	if Input.is_action_just_pressed("jump") and is_on_floor():  # Only allow jump if on the ground
		velocity.y = JUMP_VELOCITY  # Set the vertical velocity to initiate the jump

	# Get the input direction and handle the movement/deceleration.
	# (Typically, you would get the direction from player input, but it's set manually here)
	
	if direction > 0:
		dudebro.flip_h = false  # Flip the sprite to face right
	elif direction < 0:
		dudebro.flip_h = true  # Flip the sprite to face left
	
	# If the character is on the floor, handle animations
	if is_on_floor():
		if direction == 0:
			dudebro.play("default")  # Play the "default" animation when not moving
		else: 
			dudebro.play("run")  # Play the "run" animation when moving

	# Handle movement based on the direction (1 for right, -1 for left)
	if direction:
		velocity.x = direction * SPEED  # Move the character horizontally based on the input direction
	else:
		# Gradually slow down to stop the character when there's no input
		velocity.x = move_toward(velocity.x, 0, SPEED)  # Decelerates the character towards zero speed

	# Move the character according to the current velocity (physics-based movement)
	move_and_slide()
