extends CharacterBody2D

@export var speed := 100.0
@export var target: Node2D
@export var repath_distance := 16.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@export var follow_distance := 30.0
@export var resume_distance := 40.0

var following := true


func _ready():
	await get_tree().physics_frame

	navigation_agent.target_position = target.global_position


func _physics_process(_delta: float):
	var distance_to_target := global_position.distance_to(target.global_position)

	if following and distance_to_target <= follow_distance:
		following = false

	if not following and distance_to_target >= resume_distance:
		following = true

	if not following:
		velocity = Vector2.ZERO
		return

	navigation_agent.target_position = target.global_position

	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_position := navigation_agent.get_next_path_position()
	var direction := global_position.direction_to(next_position)

	velocity = direction * speed
	move_and_slide()


func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		print("Attack")
