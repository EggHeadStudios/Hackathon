@tool
extends Node2D

@export var enemy_scene : PackedScene
@export var spawn_cooldown := 2.0
@export var show_spawn_radius := true:
	set(value):
		show_spawn_radius = value
		if is_inside_tree():
			queue_redraw()
@export_range(0.0, 1000.0, 1.0)
var spawn_radius: float = 200.0:
	set(value):
		spawn_radius = value
		if is_inside_tree():
			queue_redraw()
@export var target := Node2D
@export var spawn_max := 1

var num_spawned := 0


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var timer = Timer.new()
	timer.wait_time = spawn_cooldown
	timer.autostart = true
	timer.timeout.connect(spawn_enemy)
	add_child(timer)


func spawn_enemy() -> void:
	if num_spawned < spawn_max:
		var instance = enemy_scene.instantiate() as Enemy
		var angle := randf_range(0.0, TAU)
		var distance := sqrt(randf()) * spawn_radius
		var offset := Vector2.from_angle(angle) * distance
		instance.global_position = global_position + offset
		instance.target = target
		instance.follow_distance = 50.0
		instance.resume_distance = 60.0
		instance.repath_distance = 50.0
		get_tree().current_scene.add_child(instance)
		num_spawned += 1



func _draw() -> void:
	if not show_spawn_radius:
		return
	draw_circle(
		Vector2.ZERO,
		spawn_radius,
		Color(1, 0, 0, 0.5),
		false,
		2.0
	)
