class_name GenMarker
extends Node2D

signal done_gen

@export var weighted_scenes: Array[WeightedScene]
@export var depth: int = 0
@export_file("*.tscn") var fallback_scene: String

var _generating: bool = false
var _children_generating: Dictionary = {}


func _ready() -> void:
	self.find_child("Label").text = str(self.depth)

	if self.weighted_scenes.size() <= 0:
		return

	self._generating = true

	if self.depth <= 0:
		if self.fallback_scene:
			var FallbackScene: Resource = load(self.fallback_scene)
			if FallbackScene:
				self.get_child(0).add_child.call_deferred(FallbackScene.instantiate())

		self._generating = false
		done_gen.emit.call_deferred()

		return

	var cumulative_weights: Array = self.weighted_scenes.reduce(
		func(acc: Array, weighted: WeightedScene) -> Array:
			return acc + [weighted.weight + (0 if acc.size() == 0 else acc[-1])],
		[]
	)
	var chosen_weight: int = randi_range(1, cumulative_weights[-1])
	var chosen_scene: Resource = load(
		(
			self
			. weighted_scenes[cumulative_weights.find_custom(
				func(weight: int) -> bool: return chosen_weight <= weight
			)]
			. scene
		)
	)

	if chosen_scene:
		var chosen_scene_instance: Node2D = chosen_scene.instantiate()
		var gen_markers: Array[Node] = chosen_scene_instance.find_children("*", "GenMarker")
		if gen_markers.size() == 0:
			self._generating = false
			done_gen.emit.call_deferred()

		for marker in gen_markers:
			if marker is GenMarker:
				marker.depth = max(self.depth - 1, 0)
				self._children_generating[marker.get_instance_id()] = true
				marker.done_gen.connect(
					func() -> void: self._child_done_generating(marker.get_instance_id())
				)

		self.get_child(0).add_child.call_deferred(chosen_scene_instance)


func _child_done_generating(instance_id: int) -> void:
	self._children_generating[instance_id] = false
	if self._children_generating.values().all(
		func(generating: bool) -> bool: return not generating
	):
		self._generating = false
		done_gen.emit.call_deferred()
