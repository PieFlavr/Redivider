extends CanvasModulate


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("its_rewind_time"):
		color = Color(0.0, 0.5, 0.5, 1.0)
	else:
		color = Color(1.0, 0.5, 0.0)
