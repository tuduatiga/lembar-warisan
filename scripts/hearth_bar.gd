extends HBoxContainer

var _player: Player

@onready var _hearth_panel: Panel = get_node("HearthPanel0")


func init(player: Player) -> void:
	self._player = player

	for i in range(self._player.health_component.health - 1):
		var hearth: Panel = self._hearth_panel.duplicate()
		hearth.name = "HearthPanel" + str(i + 1)
		self.add_child(hearth)

	self._player.health_component.damage_taken.connect(self._on_damage_taken)


func _on_damage_taken(health: int) -> void:
	if health >= 0 and self._player.health_component.is_invincible:
		self.get_node("HearthPanel" + str(health)).queue_free()
