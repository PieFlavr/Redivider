extends Node

# For collision masking & layers, follow the following convention...
# 1 = Environment
# 2 = Player
# 3 = Everything Else

# For faction masking use groups instead to "tag" scenes

const dead_zone : Vector2 = Vector2(1,1)
const proj_direction : Vector2 = Vector2(1,0)
const proj_speed : float = 200.0

const max_rewind_time : float = 120.0
