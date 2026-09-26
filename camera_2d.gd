extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2 (0,0)
	make_current()
