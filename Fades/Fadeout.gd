extends ColorRect

onready var anim_player = $AnimationPlayer

func _ready():
    #create signal for animation player finished
    anim_player.connect("animation_finished", self, "_on_anim_finished")

func _on_anim_finished(_Fadeout):
    pass #do something