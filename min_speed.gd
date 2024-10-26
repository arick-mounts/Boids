extends HSlider


func _on_max_speed_value_changed(max_value: float) -> void:
	if(value > max_value):
		value = max_value
