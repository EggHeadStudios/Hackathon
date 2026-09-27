extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	hide()
	get_tree().change_scene_to_packed(preload("res://Enemies/enemy_level.tscn"))
