extends ParallaxBackground

var scrolling_speed = 0.0 

onready var canyon_layer_1 = $CanyonLayer1
onready var canyon_layer_2 = $CanyonLayer2

func _process(delta):
	scroll_offset.y += scrolling_speed * delta


func _on_CanyonLayer2Timer_timeout():
	canyon_layer_2.visible = true 
	scrolling_speed = 250.0 


func _on_CanyonLayer1Timer_timeout():
	canyon_layer_1.visible = true

func _on_RemoveCanyon_timeout():
	self.queue_free() 
