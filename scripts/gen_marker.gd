extends Node2D
class_name GenMarker

@export var weighted_scenes: Array[WeightedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if weighted_scenes.size() <= 0:
		return

	var cumulative_weights: Array = weighted_scenes.reduce(func(acc, weighted: WeightedScene): return acc+[weighted.weight + (0 if acc.size() == 0 else acc[-1])], [])
	var chosen_weight = randi_range(1, cumulative_weights[-1])
	var chosen_i = cumulative_weights.find_custom(func(weight: int): return chosen_weight <= weight)
	var chosen_scene = load(weighted_scenes[chosen_i].scene)
	if chosen_scene:
		self.get_child(0).add_child.call_deferred(chosen_scene.instantiate())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
