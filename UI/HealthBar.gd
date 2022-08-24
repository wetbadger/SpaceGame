extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var health_bar = $HealthBar
onready var update_tween = $UpdateTween

# Called when the node enters the scene tree for the first time.
func _on_health_updated(health):
	health_bar.value = health
	#update_tween.interpolate_property(health_bar, "value", health_bar.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#update_tween.start()
func _on_max_health_updated(max_health):
	health_bar.max_value = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
