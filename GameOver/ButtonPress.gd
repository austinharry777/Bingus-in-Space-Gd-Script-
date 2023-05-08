extends Timer

var timer_started = false

func _ready():
    set_process_input(true)

func _input(event):
    if event.is_action_pressed("left_click")\
    or event.is_action_pressed("right_click")\
    or event.is_action_pressed("superbeam")\
    or event.is_action_pressed("dash") and not timer_started:
        self.start() # start the timer
        timer_started = true
        