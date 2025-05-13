class_name GenArea
extends Area2D

@export_file("*.tscn") var fallback_scene: String


func _ready() -> void:
	self.area_entered.connect(_area_entered)


func _area_entered(area: Area2D) -> void:
	if not area is GenArea:
		return

	var FallbackScene = load(self.fallback_scene)
	if not FallbackScene:
		return

	var node_parent: Node = self.get_parent()
	node_parent.get_parent().add_child.call_deferred(FallbackScene.instantiate())
	node_parent.queue_free()
