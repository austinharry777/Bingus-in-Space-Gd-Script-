extends Area2D

var speed = 600
var velocity = Vector2(0, -1)
onready var position_node = $Position2D
onready var arm_attached_timer = $ArmAttachedTimer
onready var kill_timer = $KillTimer
var arm_attached = false
var above_screen: bool 

func _ready():
	
	if position_node.global_position.y < 0:
		above_screen = true
	elif position_node.global_position.y > 720:   
		above_screen = false
	
	var angle = position_node.global_rotation
	var direction_vector = Vector2(0,-1).rotated(angle) 
	set_direction(direction_vector)
	
func _process(delta):
	translate(velocity * delta)

	if above_screen:
		if position_node.global_position.y >= 650 and arm_attached == false:
			velocity = Vector2(0,0)
			arm_attached_timer.start()
			arm_attached = true
	else:
		if position_node.global_position.y <= 70 and arm_attached == false:
			velocity = Vector2(0,0)
			arm_attached_timer.start()
			arm_attached = true

func set_direction(direction):
	direction = direction.normalized()
	velocity = direction * speed
	
func _on_ArmAttachedTimer_timeout():
	var angle = position_node.global_rotation
	var direction_vector = Vector2(0,1).rotated(angle) 
	set_direction(direction_vector)
	kill_timer.start()

func _on_KillTimer_timeout():
	queue_free()


func _on_FlopilotArm_body_entered(body:Node):
	body.take_damage() #this is the function in the player script that is supposed to be called



