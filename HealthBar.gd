extends TextureProgress

# Called when the node enters the scene tree for the first time.
func _on_health_updated(health):
	self.value = health
	#update_tween.interpolate_property(health_bar, "value", health_bar.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#update_tween.start()
func _on_max_health_updated(max_health):
	self.max_value = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
