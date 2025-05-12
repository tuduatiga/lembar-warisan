extends Resource
class_name WeightedScene

@export_file("*.tscn") var scene: String
@export var weight: int = 1


func _init(p_scene: String = "", p_weight: int = 1) -> void:
	self.scene = p_scene
	self.weight = p_weight
