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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if verticalMovement:
		velocity.y = verticalMovement * SPEED
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
