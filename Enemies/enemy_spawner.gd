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

@export var textures: Array[Texture2D] = []


var num_spawned := 0
var wave := 1


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	#var timer = Timer.new()
	#timer.wait_time = spawn_cooldown
	#timer.autostart = true
	#timer.timeout.connect(spawn_enemy_loop)
	#add_child(timer)
	
	call_deferred("start_waves")# start_waves()


func spawn_enemy_loop() -> void:
	if num_spawned < spawn_max:
		var instance = enemy_scene.instantiate() as Enemy
		var angle := randf_range(0.0, TAU)
		var distance := sqrt(randf()) * spawn_radius
		var offset := Vector2.from_angle(angle) * distance
		instance.global_position = global_position + offset
		instance.target = target
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


func start_waves() -> void:
	if wave == 1:
		
		#await get_tree().create_timer(15.0).timeout
		await spawn_enemy("goblin", 10, 10, 5.0, 25.0, 150.0, 0.75)
		await spawn_enemy("ghost", 3, 10.0, 10.0, 50.0, 100.0, 1.0)
		await spawn_enemy("knight", 2, 5.0, 20.0, 100.0, 75.0, 1.3)
	
	wave += 1


func spawn_enemy(anim_name: String, num: int, time: float, damage: float, health: float, speed: float, size_scale: float) -> void:
	var time_per = time / num
	for i in num:
		var instance = enemy_scene.instantiate() as Enemy
		var angle := randf_range(0.0, TAU)
		var distance := sqrt(randf()) * spawn_radius
		var offset := Vector2.from_angle(angle) * distance
		instance.global_position = global_position + offset
		instance.target = target
		instance.attack_damage = damage
		instance.health = health
		instance.name = anim_name + " " + str(i)
		instance.animation_name = anim_name
		instance.speed = speed
		instance.reposition_speed = speed / 1.2
		instance.animated_sprite.scale = Vector2(size_scale, size_scale)
		get_tree().current_scene.add_child(instance)
		await get_tree().create_timer(time_per).timeout
