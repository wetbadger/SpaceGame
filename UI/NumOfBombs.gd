extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var num_of_bombs = 0

onready var bombsLabel = get_node("Bombs")
# Called when the node enters the scene tree for the first time.
func _ready():
	bombsLabel.set_text(String(num_of_bombs))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
