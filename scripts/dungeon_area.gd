class_name DungeonArea
extends Area2D

@export var clear: bool = false

var _visited: bool
var _atmosphere_music: AudioStreamPlayer2D


func _ready() -> void:
	self.clear = false
	self._visited = false
	self._atmosphere_music = get_node("/root/AtmosphereMusic")

	self.body_entered.connect(self._on_body_entered)


func _physics_process(_delta: float) -> void:
	var should_be_clear: bool = true
	if self._visited:
		for body in self.get_overlapping_bodies():
			if body is PhysicsBody2D:
				if (
					body is Bar
					and not body.owner.name.begins_with("End")
					and body.collision_layer & Enums.CollisionLayer.BAR > 0
				):
					if body.open and not self.clear:
						self._atmosphere_music.stop()
						self._atmosphere_music.stream = AudioStreamMP3.load_from_file(
							"res://assets/audios/atmospheres/tension.mp3"
						)
						self._atmosphere_music.play()

						body.transition_close()

					if not body.open and self.clear:
						self._atmosphere_music.stop()
						self._atmosphere_music.stream = AudioStreamMP3.load_from_file(
							"res://assets/audios/atmospheres/main.mp3"
						)
						self._atmosphere_music.play(5)

						body.transition_open()
						if (
							self.get_tree().get_nodes_in_group("DungeonArea").find_custom(
								func(dungeon_area: DungeonArea) -> bool: return not dungeon_area.clear
							)
							== -1
						):
							for end_bar in self.get_tree().get_nodes_in_group("EndBar"):
								end_bar.transition_open()

				if body is Player:
					if self.clear:
						(body.find_child("EnemyDetectionArea") as Area2D).monitoring = false
					else:
						(body.find_child("EnemyDetectionArea") as Area2D).monitoring = true

				if body.collision_layer & Enums.CollisionLayer.ENEMY and not body.dead:
					body.set_invincible(false)
					if body.find_child("DetectionArea"):
						body.find_child("DetectionArea").monitoring = true
					should_be_clear = false

				if body.is_in_group("Destructible"):
					body.set_invincible(false)

		if not self.clear and should_be_clear:
			self.get_tree().root.get_node("Game").get_node("GameManager").inc_room_cleared()

		self.clear = should_be_clear


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body is Player:
		self.get_tree().root.get_node("Game").find_child("MinimapPanel").queue_redraw.call_deferred()

	if self.clear:
		return

	if body.is_in_group("Enemy") and not self._visited:
		body.set_invincible.call_deferred(true)
		if body.find_child("DetectionArea"):
			body.find_child("DetectionArea").monitoring = false

	if body.is_in_group("Destructible") and not self._visited:
		body.set_invincible.call_deferred(true)

	if body is Player and not self._visited:
		self._visited = true
		var dir: Vector2 = (self.global_position - body.global_position).normalized()
		body.global_position += dir * (6 if abs(dir.x) > 0.5 else 18)
