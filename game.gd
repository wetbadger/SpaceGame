extends Node2D


func _init():
	# Note: a Node doesn't have a "name" yet here.

	print("TestRoot init")

func _enter_tree():
	print(name + " enter tree")

func _ready():
	print(name + " ready")

# This ensures we only print *once* in process().

var test = true
func _process(delta):
	if test:
		print(name + " process")
	test = false
	
func call_this():
	print("This was called")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
