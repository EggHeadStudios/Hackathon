extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()
	update_score()
	
func update_score () -> void:
	text = "Current High Score: " + str ($"../../..".get_high_score())
