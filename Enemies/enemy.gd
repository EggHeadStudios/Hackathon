class_name Enemy extends CharacterBody2D

enum State {
	CHASING,
	ATTACKING,
	REPOSITIONING,
	KNOCKBACK,
	STAGGERED
}

@export var speed := 100.0
@export var reposition_speed := 80.0
@export var target: Node2D

@export var repath_distance := 16.0

@export var attack_duration := 0.3
@export var reposition_duration := 1.0
@export var reposition_distance := 70.0

@export var attack_damage := 5.0
@export var health := 100.0

@export var knockback_duration := 0.15
@export var stagger_duration := 0.2

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var animated_sprite: AnimatedSprite2D

var state := State.CHASING

var in_range := false
var attack_count := 0

var reposition_time := 0.0
var reposition_target := Vector2.ZERO

var animation_name: String

var knockback_velocity := Vector2.ZERO
var knockback_time := 0.0
var stagger_time := 0.0


func _ready() -> void:
	await get_tree().physics_frame

	navigation_agent.target_position = target.global_position


func _physics_process(delta: float) -> void:
	match state:
		State.CHASING:
			chase()

		State.ATTACKING:
			stop_moving()

		State.REPOSITIONING:
			reposition(delta)
		
		State.KNOCKBACK:
			process_knockback(delta)
		
		State.STAGGERED:
			process_stagger(delta)


func chase() -> void:
	if in_range:
		start_attack()
		return

	if navigation_agent.target_position.distance_to(target.global_position) >= repath_distance:
		navigation_agent.target_position = target.global_position

	move_along_navigation(speed)


func start_attack() -> void:
	if state != State.CHASING:
		return

	state = State.ATTACKING
	stop_moving()

	attack()


func attack() -> void:
	attack_count += 1

	print("%s attacked player for %d damage %d times" % [name, attack_damage, attack_count])
	
	if target is Player:
		var player = target as Player
		player._decrement_health(attack_damage)

	await get_tree().create_timer(attack_duration).timeout

	if not is_inside_tree():
		return

	start_reposition()


func start_reposition() -> void:
	state = State.REPOSITIONING
	reposition_time = reposition_duration

	var away_direction := target.global_position.direction_to(global_position)

	if randf() < 0.65:
		var side := 1.0

		if randf() < 0.5:
			side = -1.0

		var sideways_direction := away_direction.rotated(PI / 2.0 * side)

		var direction := (sideways_direction * 0.8 + away_direction * 0.2).normalized()

		reposition_target = global_position + direction * reposition_distance
	else:
		reposition_target = global_position + away_direction * reposition_distance

	navigation_agent.target_position = reposition_target


func reposition(delta: float) -> void:
	reposition_time -= delta

	if reposition_time <= 0.0:
		state = State.CHASING
		return

	if navigation_agent.is_navigation_finished():
		stop_moving()
		return

	move_along_navigation(reposition_speed)


func move_along_navigation(move_speed: float) -> void:
	if navigation_agent.is_navigation_finished():
		stop_moving()
		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	navigation_agent.velocity = direction * move_speed


func stop_moving() -> void:
	navigation_agent.velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	animated_sprite.pause()
	animated_sprite.frame = 0


func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		in_range = true


func _on_area_2d_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		in_range = false


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if state == State.ATTACKING:
		velocity = Vector2.ZERO
		animated_sprite.pause()
		animated_sprite.frame = 0
		return
	
	if state == State.KNOCKBACK:
		return
	
	if state == State.STAGGERED:
		velocity = Vector2.ZERO
		return
	
	animated_sprite.speed_scale = speed / 100
	animated_sprite.play(animation_name)
	velocity = safe_velocity
	move_and_slide()


func take_damage(num: float) -> void:
	health -= num
	if health <= 0:
		print("player killed %s" % name)
		queue_free()
	else:
		print("player attacked %s for %d damage (remaining %d)" % [name, num, health])


func apply_knockback(from_position: Vector2, force: float) -> void:
	var direction := from_position.direction_to(global_position)

	knockback_velocity = direction * force
	knockback_time = knockback_duration
	state = State.KNOCKBACK

	navigation_agent.velocity = Vector2.ZERO


func process_knockback(delta: float) -> void:
	knockback_time -= delta

	if knockback_time <= 0.0:
		knockback_velocity = Vector2.ZERO
		velocity = Vector2.ZERO

		stagger_time = stagger_duration
		state = State.STAGGERED
		return

	velocity = knockback_velocity
	move_and_slide()


func process_stagger(delta: float) -> void:
	stagger_time -= delta

	velocity = Vector2.ZERO
	navigation_agent.velocity = Vector2.ZERO

	if stagger_time <= 0.0:
		state = State.CHASING
