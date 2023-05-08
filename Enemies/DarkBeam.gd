extends Area2D

var velocity = Vector2(0,1)
var speed = 800
onready var anim_player = $AnimatedSprite

func _process(delta):
    translate(velocity * speed * delta) 
    if position.y > 1000:
        queue_free() 
        
func set_beam_speed_and_direction(direction: Vector2):
    velocity = direction
            
func _on_AnimatedSprite_animation_finished():
    if anim_player.animation == "stoplaser":
        queue_free()
                    
func _on_DarkBeam_body_entered(body:Node):
    body.absorb_hit_dark(5)
    speed = 0
    anim_player.play("stoplaser")