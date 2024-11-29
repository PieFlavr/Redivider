extends Node2D

var rewinding : bool = false # Default false obviously
var max_rewind_time : float = Globals.max_rewind_time # In seconds of max rewindability
var rewind_record = {
	"global_position": []
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("its_rewind_time"):
		rewind()
	else:
		rewind(true)

func rewind(invert : bool = false) -> void:
	rewinding = true if !invert else false

func rewind_process(delta : float) -> void:
	if (!rewinding):
		var children = get_children()
		
		if (max_rewind_time * Engine.physics_ticks_per_second == rewind_record["global_position"].size()):
			for key in rewind_record.keys():
				rewind_record[key].pop_front()

		for key in rewind_record.keys():
			if(children != null):
				for child in children:
					if(child.get(key) != null):
						rewind_record[key].append(child.get(key))
						#print(key + "_B: " + str(child.get(key)))
			elif(self.get(key) != null):
				rewind_record[key].append(self.get(key))
				#print(key + "_B: " + str(rewind_record[key][-1]))
	else:
		compute_rewind()

func compute_rewind() -> void:
	var children = get_children()
	
	for key in rewind_record.keys():
		var value = rewind_record[key].pop_back()

		if value != null:
			match key:
				_:
					if(children != null):
						for child in children:
							if(child.get(key) != null):
								child.set(key,value)
								#print(key + "_A " + str(value))
					elif(self.get(key) != null):
						self.set(key,value)
						#print(key + "_A " + str(value))

# Adds a variable to rewind in the rewind_record dictionary
func add_rewind_key(key_name : String):
	rewind_record[key_name] = []
