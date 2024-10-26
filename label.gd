extends Label

@export var h_slider: HSlider
@export var decimals:int = 2
func _process(delta: float) -> void:
	text= str(round(h_slider.value * pow(10.0, decimals)) / pow(10.0, decimals))
