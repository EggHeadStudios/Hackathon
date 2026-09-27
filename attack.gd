extends Area2D

@export var attack_range := 80.0
@export var attack_angle := 90.0
@export var attack_damage := 20

var facing_direction := Vector2.DOWN

@onready var attack_range_area: Area2D = $"."

var attack_flash := false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			attack_flash = true
			queue_redraw()

			await get_tree().create_timer(0.1).timeout

			attack_flash = false
			queue_redraw()

func _process(_delta: float) -> void:
	queue_redraw()
	if Input.is_action_just_pressed("attack"):
		attack()

func attack() -> void:
	var attack_direction := global_position.direction_to(get_global_mouse_position())

	var half_angle := deg_to_rad(attack_angle / 2.0)
	var minimum_dot := cos(half_angle)

	for body in attack_range_area.get_overlapping_bodies():
		if not body is Enemy:
			continue

		var to_enemy := body.global_position - global_position

		if to_enemy.length() > attack_range:
			continue

		var direction_to_enemy := to_enemy.normalized()

		if attack_direction.dot(direction_to_enemy) >= minimum_dot:
			if body is Enemy:
				body.take_damage(attack_damage)

func _physics_process(_delta: float) -> void:
	var input_direction := Input.get_vector("left", "right", "up", "down")

	if input_direction != Vector2.ZERO:
		facing_direction = input_direction.normalized()

func _draw() -> void:
	var mouse_direction := to_local(get_global_mouse_position()).normalized()
	var center_angle := mouse_direction.angle()

	var half_angle := deg_to_rad(attack_angle / 2.0)
	var start_angle := center_angle - half_angle
	var end_angle := center_angle + half_angle

	var points := PackedVector2Array()
	points.append(Vector2.ZERO)

	var segments := 24

	for i in range(segments + 1):
		var t := float(i) / float(segments)
		var angle = lerp(start_angle, end_angle, t) #:

		points.append(Vector2.from_angle(angle) * attack_range)

	var fill_alpha := 0.08

	if attack_flash:
		fill_alpha = 0.4

	draw_colored_polygon(points, Color(1.0, 0.2, 0.2, fill_alpha))

	draw_line(Vector2.ZERO, Vector2.from_angle(start_angle) * attack_range, Color.RED, 2.0)

	draw_line(Vector2.ZERO, Vector2.from_angle(end_angle) * attack_range, Color.RED, 2.0)

	draw_arc(
		Vector2.ZERO,
		attack_range,
		start_angle,
		end_angle,
		segments,
		Color.RED,
		2.0
	)
