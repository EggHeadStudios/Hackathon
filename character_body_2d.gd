class_name Player
extends CharacterBody2D

# constants
const SPEED = 200.0
const START_HEALTH = 100

# global vars
var health := 100.0
var victory := false

@export var health_bar: ProgressBar
@export var health_label: Label
@export var died_ui: Control
@export var victory_ui: PanelContainer
@export var player_sprite: Sprite2D
@export var main_menu: PackedScene
@export var attack_range: Area2D
@export var animated_sprite: AnimatedSprite2D


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var movement := Input.get_vector("left", "right", "up", "down")
	
	if movement:
		velocity = movement * SPEED
		if velocity.x > 0:
			$PlayerSprite.texture = preload ("res://Assets/king_side_1.png")
			$PlayerSprite.flip_h = true
			animated_sprite.play("side")
			animated_sprite.flip_h = true
		elif velocity.x < 0:
			$PlayerSprite.texture = preload ("res://Assets/king_side_1.png")
			$PlayerSprite.flip_h = false
			animated_sprite.play("side")
			animated_sprite.flip_h = false
		elif velocity.y > 0:
			$PlayerSprite.texture = preload ("res://Assets/king_down_1.png")
			animated_sprite.play("down")
		else:
			$PlayerSprite.texture = preload ("res://Assets/king_up_1.png")
			animated_sprite.play("up")
	else:
		velocity = Vector2 (0, 0)
		animated_sprite.pause()
		animated_sprite.frame = 0

	if health > 0 and !victory:
		move_and_slide()

func _process (delta: float) -> void:
	# update call
	animated_sprite.speed_scale = SPEED / 100
	
func _decrement_health (num: float) -> void:
	# Reduce hp by given amount
	if health > num:
		health = health - num
	else:
		health = 0
		_died()
	health_bar.value = health
	health_label.text = str(int(health))

func _swing_sword () -> void:
	#if Input.get_
	#print ("Swing!")
	pass

func _died() -> void:
	died_ui.visible = true
	animated_sprite.visible = false
	health_bar.visible = false
	if attack_range:
		attack_range.queue_free()
	
	# go to main menu after 5 sec
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://Home.tscn")

func set_victory() -> void:
	victory = true
	victory_ui.visible = true
	animated_sprite.visible = false
	health_bar.visible = false
	if attack_range:
		attack_range.queue_free()
	
	# go to main menu after 5 sec
	await get_tree().create_timer(5.0).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Home.tscn")
