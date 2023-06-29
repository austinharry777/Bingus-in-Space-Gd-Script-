extends Area2D

var speed = 0
var max_speed = 1200

func _ready():
    $AnimatedSprite.play("fly")
func _process(delta):
    if speed < max_speed:
        speed += 15
    else:
        speed = max_speed
    translate(Vector2(-speed * delta, 0))
    if position.x < -200:
        queue_free()

func _on_FlopilotFire_body_entered(body:Node):
	body.take_damage() 
