extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	pressed.connect(_on_pressed)

func _on_pressed () -> void:
	$"../../CenterContainer/Pause Button".show()
	$"../../CenterContainer4/OptionButton".hide()
	$"../../CenterContainer3/Settings".hide()
	hide()
	pass
