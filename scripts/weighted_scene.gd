extends Resource
class_name WeightedScene	

@export_file("*.tscn") var scene: String = ""
@export var weight: int = 1

func _init(p_scene="", p_weight=1):
	scene = p_scene
	weight = p_weight
