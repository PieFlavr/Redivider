extends Area2D

@onready var timer: Timer = $Timer

var killing

func _ready() -> void:
	killing = true

func _on_body_entered(body: Node2D) -> void:
	if killing:
		if body.name == "player": 
			print("Get Destroyed Idiot!")
			Engine.time_scale = 0.5
			body.get_node("hitbox").queue_free()
			timer.start()
			
		elif body.name == "enemy":
			print("enemy hit!")
			body.queue_free()
		
func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	# do reverse time stuff and then reload here!
	get_tree().reload_current_scene()
