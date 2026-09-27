extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	var popup = get_popup()
	popup.add_item ("Play", 0)
	popup.add_item ("Settings", 1)
	popup.id_pressed.connect(_select)
	
func _select (id: int) -> void:
	match id:
		0:
			# resume game
			$"../../CenterContainer/Pause Button".show()
			get_tree().paused = !get_tree().paused
			hide()
		1:
			# open settings asp
			$"../../CenterContainer3/Settings".show()
			$"../../CenterContainer4/OptionButton".show()
			$"../../CenterContainer5/Back".show()
			hide()
			
