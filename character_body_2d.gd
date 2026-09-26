extends CharacterBody2D

# constants
const SPEED = 200.0
const START_HEALTH = 100

# global vars
var health = 100


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var movement := Input.get_vector("left", "right", "up", "down")
	
	if movement:
		velocity = movement * SPEED
		if velocity.x > 0:
			$PlayerSprite.texture = preload ("res://Assets/king_side_1.png")
			$PlayerSprite.flip_h = true
		elif velocity.x < 0:
			$PlayerSprite.texture = preload ("res://Assets/king_side_1.png")
			$PlayerSprite.flip_h = false
		elif velocity.y > 0:
			$PlayerSprite.texture = preload ("res://Assets/king_down_1.png")
		else:
			$PlayerSprite.texture = preload ("res://Assets/king_up_1.png")
	else:
		velocity = Vector2 (0, 0)

	move_and_slide()

func _process (delta: float) -> void:
	# update call
	pass
	
func _decrement_health (num: float) -> void:
	# Reduce hp by given amount
	if health > num:
		health = health - num
	else:
		pass
func _swing_sword () -> void:
	#if Input.get_
	#print ("Swing!")
	pass
