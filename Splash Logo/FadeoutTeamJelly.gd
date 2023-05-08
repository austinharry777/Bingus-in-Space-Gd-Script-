extends "res://Fades/Fadeout.gd"

func _on_anim_finished(_Fadeout):
    var error = get_tree().change_scene("res://Intro/Intro.tscn")
    if error != OK:
        print("Error: ", error)

