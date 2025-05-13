class_name GenMarker
extends Node2D

@export var weighted_scenes: Array[WeightedScene]


func _ready() -> void:
	if self.weighted_scenes.size() <= 0:
		return

	var cumulative_weights: Array = self.weighted_scenes.reduce(
		func(acc, weighted: WeightedScene):
			return acc + [weighted.weight + (0 if acc.size() == 0 else acc[-1])],
		[]
	)
	var chosen_weight: int = randi_range(1, cumulative_weights[-1])
	var chosen_scene: Resource = load(
		(
			self
			. weighted_scenes[cumulative_weights.find_custom(
				func(weight: int): return chosen_weight <= weight
			)]
			. scene
		)
	)

	if chosen_scene:
		self.get_child(0).add_child.call_deferred(chosen_scene.instantiate())
