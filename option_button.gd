extends MenuButton

@onready var difficulty = "easy"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	var popup = get_popup()
	popup.add_item ("Easy", 0)
	popup.add_item ("Medium", 1)
	popup.add_item ("Hard", 2)
	popup.id_pressed.connect(_select_settings)

func _select_settings (id: int) -> void:
	match id:
		0:
			# set duration easy
			difficulty = "easy"
		1:
			# medium
			difficulty = "medium"
		2:
			# hard
			difficulty = "hard"
