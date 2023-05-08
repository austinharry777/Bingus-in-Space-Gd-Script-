extends TextureRect

onready var fadeout = $Fadeout
onready var fadein = $Fadein
onready var music = $Music
onready var tween = $Tween
onready var text_1 = $"TextCutscene1-1/TextSound"
onready var text_2 = $"TextCutscene1-2/TextSound"
onready var text_3 = $"TextCutscene1-3/TextSound"
onready var text_4 = $"TextCutscene1-4/TextSound"
onready var text_5 = $"TextCutscene1-5/TextSound"
onready var text_6 = $"TextCutscene1-6/TextSound"
onready var text_7 = $"TextCutscene1-7/TextSound"
onready var text_8 = $"TextCutscene1-8/TextSound"

func _process(_delta):
	press_mouse_button()

func _ready():
	fadein.get_node("AnimationPlayer").play("Fadein") #Play fade in animation
	
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
		tween.interpolate_property(text_6, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(text_7, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.interpolate_property(text_8, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start() 

		fadeout.get_node("AnimationPlayer").play("Fadeout")
		
		yield(tween, "tween_completed")
		music.stop()
		text_1.stop()
		text_2.stop()
		text_3.stop()
		text_4.stop()
		text_5.stop()
		text_6.stop()
		text_7.stop()
		text_8.stop()
		
		var error = get_tree().change_scene("res://Title/BingusTitle.tscn")
		if error != OK:
			print("Error changing scene: ", error)

func _on_IntroTimer_timeout():
	#Start fading out music and scene
	tween.interpolate_property(music, "volume_db", 0.0, -40.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_1, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_2, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_3, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_4, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_5, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_6, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_7, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(text_8, "volume_db", 1.8, -80.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

	fadeout.get_node("AnimationPlayer").play("Fadeout")
	
	yield(tween, "tween_completed")
	music.stop()
	text_1.stop()
	text_2.stop()
	text_3.stop()
	text_4.stop()
	text_5.stop()
	text_6.stop()
	text_7.stop()
	text_8.stop()

	var error = get_tree().change_scene("res://Title/BingusTitle.tscn")
	if error != OK:
		print("Error changing scene: ", error)

func _on_BingusTextDisappear_timeout():
	$"TextCutscene1-1".hide()
	$"TextCutscene1-2".hide()

func _on_FloppaTextDisappear_timeout():
	$"TextCutscene1-5".hide()
	$"TextCutscene1-6".hide()


