extends TextureRect

onready var fadeout = $Fadeout
onready var music = $BingusIntroMusic
onready var tween = $Tween
onready var text_1 = $TextIntro1/TextSound
onready var text_2 = $TextIntro2/TextSound
onready var text_3 = $TextIntro3/TextSound
onready var text_4 = $TextIntro4/TextSound
onready var text_5 = $TextIntro5/TextSound


func _process(delta):
	press_mouse_button()
	 
func press_mouse_button() -> void:
	if (Input.is_mouse_button_pressed(BUTTON_LEFT)
		or Input.is_mouse_button_pressed(BUTTON_RIGHT)):
		
		#Start fading out music and scene
		tween.interpolate_property(music, "volume_db", 0.0, -40.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(text_1, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(text_2, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(text_3, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(text_4, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(text_5, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		
		fadeout.get_node("AnimationPlayer").play("Fadeout")
		
		yield(tween, "tween_completed")
		music.stop()
		text_1.stop()
		text_2.stop()
		text_3.stop()
		text_4.stop()
		text_5.stop()
		get_tree().change_scene("res://Title/BingusTitle.tscn")
		
			


			
		

		

	
