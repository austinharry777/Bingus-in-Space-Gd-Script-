extends CanvasLayer

onready var light_bar = get_node("EnergyMeter/TextureProgress")
onready var dark_bar = get_node("EnergyMeterDark/TextureProgress")
onready var boss_bar2 = get_node("BossBar/TextureProgress")
onready var boss_bar1 = get_node("BossBar/TextureProgress2")
onready var player = get_parent()

func _process(_delta):
	$Control/ShipsLeft/Player1Lives/LivesCount.text = str(Game.lives)
	$Control/Player1Score/Label.text = "P1       " + str(Game.score)
	light_bar.value = Game.meter
	dark_bar.value = Game.meter
	boss_bar1.value = Game.boss_health
	boss_bar2.value = Game.boss_health

	
	if player.light_color == false:
		light_bar.visible = false
		dark_bar.visible = true
	elif player.light_color == true:
		light_bar.visible = true
		dark_bar.visible = false 

