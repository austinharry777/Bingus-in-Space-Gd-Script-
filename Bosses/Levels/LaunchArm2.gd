extends Sprite

var speed = 100
var arm_move1 = false #for the first arm movement
var arm_move2 = false #for the second arm movement

func _process(delta):
	var velocity = Vector2()
	if arm_move1 == true:
		velocity.x -= 1
		velocity.y += 1
		position += velocity * speed * delta
	if arm_move2 == true:
		velocity.y += 1
		position += velocity * speed * delta
	if position.y > 920:
		self.queue_free() 

func _on_Timer_timeout():
	arm_move1 = true

func _on_Timer2_timeout():
	arm_move2 = true
	arm_move1 = false


