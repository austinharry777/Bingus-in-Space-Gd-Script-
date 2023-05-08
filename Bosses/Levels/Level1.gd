extends ParallaxBackground

export var scrolling_speed = 0.0 # pixels per second
var max_speed = 2000.0
var min_speed = 250.0 
var de_acceleration = 350.0 
var acceleration = 400.0 
onready var anim_player = $ParallaxLayer/TextureRect/AnimationPlayer
var zoomed = false

func _process(delta):
	if scrolling_speed == max_speed:
		
		if zoomed == false:
			anim_player.play("BackgroundZoom")
			$ParallaxLayer/SlowdownTimer.start() 
			$ParallaxLayer/StartTimer.queue_free() # stop the scrolling
			zoomed = true

	scroll_offset.y += scrolling_speed * delta
		
func _on_StartTimer_timeout():
	scrolling_speed = clamp(scrolling_speed + acceleration, 0, max_speed)

func _on_LaunchTimer_timeout():
	$ParallaxLayer/StartTimer.start() # start the scrolling

func _on_AnimationPlayer_animation_finished(anim_name : String):
	if anim_name == "BackgroundZoom":
		anim_player.queue_free()
		
func _on_SlowdownTimer_timeout():
	scrolling_speed = clamp(scrolling_speed - de_acceleration, min_speed, max_speed) 

func _on_BackgroundRelease_timeout():
	self.queue_free() # remove the background when it's off screen


