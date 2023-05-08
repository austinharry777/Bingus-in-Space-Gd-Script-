extends ColorRect

onready var fadeout = $FadeoutTeamJelly
onready var fadein = $Fadein 
onready var timer = $Timer


func _ready():
	fadein.get_node("AnimationPlayer").play("Fadein")
	timer.start() # start timer
	


func _on_Timer_timeout():
	fadeout.get_node("AnimationPlayer").play("Fadeout")
	
	


	




