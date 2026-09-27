extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$"../../CenterContainer3/Settings".show()
	$"../../CenterContainer4/OptionButton".show()
	$"../../CenterContainer5/Back".show()
	hide()
	
