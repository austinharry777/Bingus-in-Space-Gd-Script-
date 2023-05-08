extends ParallaxBackground

var scrolling_speed = 0 # The speed of the scrolling in pixels per second
onready var begin_canyon = $ParallaxLayer 

func _process(delta):
	scroll_offset.y += scrolling_speed * delta


func _on_StartTimer_timeout():
	begin_canyon.visible = true
	scrolling_speed = 250 # Start scrolling

