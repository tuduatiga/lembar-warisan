class_name GenMarker
extends Node2D

@export var weighted_scenes: Array[WeightedScene]
@export var depth: int = 0
@export_file("*.tscn") var fallback_scene: String


func _ready() -> void:
	self.find_child("Label").text = str(self.depth)

	if self.weighted_scenes.size() <= 0:
		return

	if self.depth <= 0:
		if not self.fallback_scene:
			return

		var FallbackScene = load(self.fallback_scene)
		if FallbackScene:
			self.get_child(0).add_child.call_deferred(FallbackScene.instantiate())

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
		var chosen_scene_instance: Node2D = chosen_scene.instantiate()

		for marker in chosen_scene_instance.find_children("*", "GenMarker"):
			marker.depth = max(self.depth - 1, 0)

		self.get_child(0).add_child.call_deferred(chosen_scene_instance)
