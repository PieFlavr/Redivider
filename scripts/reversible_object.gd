extends Node2D

var rewinding : bool = false # Default false obviously
var max_rewind_time : float = Globals.max_rewind_time # In seconds of max rewindability
var rewind_record = {
	"position": [],
	"rotation": []
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("its_rewind_time"):
		rewind()

func rewind() -> void:
	rewinding = true

func rewind_process(delta : float) -> void:
	if (!rewinding):
		if (max_rewind_time * Engine.physics_ticks_per_second == rewind_record["position"].size()):
			for key in rewind_record.keys():
				rewind_record[key].pop_front()
		for key in rewind_record.keys():
			if(self.get(key) != null):
				rewind_record[key].append(self.get(key))
			elif(get_parent() != null and get_parent().get(key) != null):
				rewind_record[key].append(get_parent().get(key))
			

func compute_rewind() -> void:
	for key in rewind_record.keys():
		var value = rewind_record[key].pop_back()

		if value != null:
			match key:
				"default":
					if(self.get(key) != null):
						self.set(key,value)
					elif(get_parent() != null and get_parent().get(key) != null):
						get_parent().set(key,value)

func add_rewind_key(key_name : String):
	rewind_record[key_name] = []
