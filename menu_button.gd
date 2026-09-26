extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	var popup = get_popup()
	popup.add_item ("Play", 0)
	popup.add_item ("Settings", 1)
	popup.id_pressed.connect(_select)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _select (id: int) -> void:
	match id:
		0:
			# resume game
			$"../../CenterContainer/Menu Button".show()
			$".".hide()
		1:
			# open settings asp
			pass
