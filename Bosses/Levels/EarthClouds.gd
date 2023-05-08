extends ParallaxBackground

export var scrolling_speed = 400
onready var anim_player = $ParallaxLayer/AnimationPlayer
onready var anim_player2 = $ParallaxLayer/AnimationPlayer2

func _process(delta):
    scroll_offset.y += scrolling_speed * delta
    

func _on_CloudTimer_timeout():
    anim_player.play("CloudFade")
    $ParallaxLayer.visible = true

func _on_RemoveClouds_timeout():
    anim_player2.play("CloudRemove")

func _on_AnimationPlayer2_animation_finished(anim_name):
    if anim_name == "CloudRemove":
        self.queue_free() 
    
