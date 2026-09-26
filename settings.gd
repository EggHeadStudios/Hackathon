extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	var popup = get_popup()
	popup.add_item ("Back", 0)
	popup.id_pressed.connect(_select_settings)

func _select_settings (id: int) -> void:
	match id:
		0:
			# resume game
			$"../../CenterContainer2/Popup".show()
			hide()
			
