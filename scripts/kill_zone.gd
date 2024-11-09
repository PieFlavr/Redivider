extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	print("Get Destroyed Idiot!")
	Engine.time_scale = 0.5
	body.get_node("hitbox").queue_free()
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	# do reverse time stuff and then reload here!
	get_tree().reload_current_scene()
