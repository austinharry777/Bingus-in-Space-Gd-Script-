extends Node2D

var message = "HELP BINGUS!"

var typing_speed = .04 
var display = ""
var current_char = 0

func _ready():
	$MessageDelay.start()
	
func start_dialogue():
	display = ""
	current_char = 0

	$NextChar.set_wait_time(typing_speed)
	$NextChar.start()

func _on_NextChar_timeout():
	if current_char < len(message):
		var next_char = message[current_char]
		display += next_char
		
		$Label.text = display
		current_char += 1
	else:
		$NextChar.stop()
		$TextSound.stop()
		
func _on_MessageDelay_timeout():
	start_dialogue()
	$TextSound.play()
