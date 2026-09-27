extends Area2D

@export var attack_range := 80.0
@export var attack_angle := 90.0
@export var attack_damage := 20

@export var attack_sprite_distance := 50.0
@export var attack_sprite_rotation_offset := 90.0

@export var show_debug_cone := false

@export var auto_attack := true
@export var attack_cooldown := 0.75

@export var knockback_force := 250.0

@onready var attack_range_area: Area2D = $"."
@onready var attack_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var attack_flash := false

var attack_cooldown_remaining := 0.0


func _ready() -> void:
	attack_animated_sprite.visible = false
	attack_animated_sprite.animation_finished.connect(_on_attack_animated_sprite_animation_finished)


func _process(delta: float) -> void:
	if show_debug_cone:
		queue_redraw()
	
	if attack_cooldown_remaining > 0.0:
		attack_cooldown_remaining -= delta

	if not auto_attack and Input.is_action_just_pressed("attack"):
		try_attack()

	if auto_attack and attack_cooldown_remaining <= 0.0:
		if has_enemy_in_cone():
			try_attack()


func has_enemy_in_cone() -> bool:
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
			return true

	return false


func try_attack() -> void:
	if attack_cooldown_remaining > 0.0:
		return

	attack_cooldown_remaining = attack_cooldown
	attack()


func attack() -> void:
	var attack_direction := global_position.direction_to(get_global_mouse_position())

	if show_debug_cone:
		flash_attack_clone()
	play_attack_animation(attack_direction)

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
			body.take_damage(attack_damage)
			body.apply_knockback(global_position, knockback_force)


func play_attack_animation(direction: Vector2) -> void:
	attack_animated_sprite.position = direction * attack_sprite_distance
	attack_animated_sprite.rotation = direction.angle() + deg_to_rad(attack_sprite_rotation_offset)

	attack_animated_sprite.visible = true

	attack_animated_sprite.stop()
	attack_animated_sprite.frame = 0
	attack_animated_sprite.play("swing")
	
	await attack_animated_sprite.animation_finished

	attack_animated_sprite.visible = false


func flash_attack_clone() -> void:
	attack_flash = true
	queue_redraw()

	await get_tree().create_timer(0.1).timeout

	attack_flash = false
	queue_redraw()


func _on_attack_animated_sprite_animation_finished() -> void:
	if attack_animated_sprite.animation == "attack":
		attack_animated_sprite.visible = false


func _draw() -> void:
	if not show_debug_cone:
		return
	
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
