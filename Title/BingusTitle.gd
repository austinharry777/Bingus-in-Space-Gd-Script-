extends TextureRect

onready var fadein = $Fadein
onready var fadeout = $Fadeout
onready var tween = $Tween

onready var tracks = [$Track1, $Track2, $Track3, $Track4]
var random_track 
var button_pressed = false

func _ready():
	randomize()
	random_track = randi() % tracks.size()
	fadein.get_node("AnimationPlayer").play("Fadein")
	tracks[random_track].play()

func _process(_delta):
	if Input.is_action_just_pressed("left_click") and button_pressed == false:
		button_pressed = true
		tween.interpolate_property(tracks[random_track], "volume_db", 0.0, -40.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start() # start the tween 
		fadeout.get_node("AnimationPlayer").play("Fadeout")
		yield(get_tree().create_timer(2), "timeout")
		var error = get_tree().change_scene("res://Levels/Earth.tscn")
		if error != OK:
			print("Error: ", error)
		
func _on_Timer_timeout():
	fadeout.get_node("AnimationPlayer").play("Fadeout")

func _on_Timer2_timeout():
	var error = get_tree().change_scene("res://Intro/Intro.tscn")
	if error != OK:
		print("Error: ", error) 




