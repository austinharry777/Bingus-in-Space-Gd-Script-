extends ParallaxBackground

var scrolling_speed = 0
onready var parallax = $ParallaxLayer
onready var anim_player = $ParallaxLayer/AnimationPlayer

func _process(delta):
	scroll_offset.y += scrolling_speed * delta
	
func _on_Timer_timeout():
	parallax.visible = true
	scrolling_speed = 270 # pixels per second

func _on_DisappearTimer_timeout():
	anim_player.play("RoofFade")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "RoofFade":
		self.queue_free() # remove the roof when the animation is finished


