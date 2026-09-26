extends CharacterBody2D

# constants
const SPEED = 200.0
const START_HEALTH = 100

# global vars
var health = 100


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var sidewaysMovement := Input.get_axis("left", "right")
	var verticalMovement := Input.get_axis("up", "down")
	
	if sidewaysMovement:
		velocity.x = sidewaysMovement * SPEED
		if velocity.x > 0:
			$PlayerSprite.texture = load ("res://Assets/king_side_1.png")
			$PlayerSprite.flip_h = true
		else:
			$PlayerSprite.texture = load ("res://Assets/king_side_1.png")
			$PlayerSprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if verticalMovement:
		velocity.y = verticalMovement * SPEED
		if velocity.y > 0:
			$PlayerSprite.texture = load ("res://Assets/king_down_1.png")
		else:
			$PlayerSprite.texture = load ("res://Assets/king_up_1.png")
	else:
		velocity.y = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process (delta: float) -> void:
	# update call
	pass
	
func _decrement_health (num: float) -> void:
	# Reduce hp by given amount
	if health > num:
		health = health - num
