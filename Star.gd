extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
var speed_y = 1
var speed_x  = 0
var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	speed = rng.randi_range(50,500)
	set_process(true)
	
func _process(delta):
	var motion = Vector2(speed_x, speed_y) * speed
	set_position(get_position() + motion * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
