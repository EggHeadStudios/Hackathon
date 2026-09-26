extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed () -> void:
	var menuLoc = get_node ("Popup")

func _on_pressed() -> void:
	$"../../CenterContainer2/Popup".show ()
	$".".hide()
