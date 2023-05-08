extends ParallaxBackground

var scrolling_speed = 0.0
onready var canyon_layer_3 = $ParallaxLayer 


func _process(delta):
	scroll_offset.y += scrolling_speed * delta

func _on_Timer_timeout():
	scrolling_speed = 100 # pixels per second
	canyon_layer_3.visible = true # show the canyon layer




