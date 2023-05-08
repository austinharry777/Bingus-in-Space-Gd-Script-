extends ParallaxBackground

var scrolling_speed = 0
onready var background = $ParallaxLayer

func _process(delta):
    scroll_offset.y += scrolling_speed * delta
    
    
func _on_Timer_timeout():
    background.visible = true
    scrolling_speed = 250 # pixels per second