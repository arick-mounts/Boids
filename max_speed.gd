extends HSlider


func _on_min_speed_value_changed(min_value: float) -> void:
	if(value < min_value):
		value = min_value
