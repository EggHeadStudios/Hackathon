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
	
	call_deferred("start_waves")


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
	# waves don't do anything yet
	# easy 2, medium 3, hard 4 - minutes to survive
	start_timer()
	if wave == 1:
		await spawn_enemies("goblin", 10, 10, 5.0, 25.0, 150.0, 0.75)
		await spawn_enemies("ghost", 3, 10.0, 10.0, 50.0, 100.0, 1.0)
		await spawn_enemies("knight", 2, 5.0, 20.0, 100.0, 75.0, 1.3)
		await spawn_enemies("goblin", 20, 10, 5.0, 25.0, 150.0, 0.75)
		await spawn_enemies("ghost", 20, 20, 5.0, 25.0, 150.0, 1)
		await spawn_enemies("knight", 5, 10, 5.0, 25.0, 150.0, 0.75)
		await spawn_enemies("goblin", 40, 10, 5.0, 25.0, 150.0, 2)
		await spawn_enemies("ghost", 20, 20, 5.0, 25.0, 150.0, 0.75)
		await spawn_enemies("knight", 10, 10, 5.0, 25.0, 150.0, 0.75)
	
	wave += 1


func start_timer() -> void:
	if Globals.difficulty == "easy":
		print("easy - 2 minutes")
		await get_tree().create_timer(2 * 60.0).timeout
	elif Globals.difficulty == "medium":
		print("medium - 3 minutes")
		await get_tree().create_timer(3 * 60.0).timeout
	elif Globals.difficulty == "hard":
		print("hard - 4 minutes")
		await get_tree().create_timer(4 * 60.0).timeout
	$"../CharacterBody2D".set_victory()


## spawn <num> of enemies in <time> with set <damage>, <health>, <speed>, and <size>
func spawn_enemies(anim_name: String, num: int, time: float, damage: float, health: float, speed: float, size_scale: float) -> void:
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
