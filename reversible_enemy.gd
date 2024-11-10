extends Node2D

@onready var reversible_object: Node2D = $reversible_object
@onready var enemy: CharacterBody2D = $reversible_object/enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	reversible_object.rewind_process(delta)
