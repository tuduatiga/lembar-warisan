class_name DungeonArea
extends Area2D

var _clear: bool
var _visited: bool
var _atmosphere_music: AudioStreamPlayer2D


func _ready() -> void:
	self._clear = false
	self._visited = false
	self._atmosphere_music = get_node("/root/AtmosphereMusic")

	self.body_entered.connect(self._on_body_entered)


func _physics_process(_delta: float) -> void:
	var should_be_clear: bool = true
	if self._visited:
		for body in self.get_overlapping_bodies():
			if body is PhysicsBody2D:
				if body is Bar and body.collision_layer & Enums.CollisionLayer.BAR > 0:
					if body.open and not self._clear:
						self._atmosphere_music.stop()
						self._atmosphere_music.stream = AudioStreamMP3.load_from_file(
							"res://assets/audios/atmospheres/tension.mp3"
						)
						self._atmosphere_music.play()

						body.transition_close()

					if not body.open and self._clear:
						self._atmosphere_music.stop()
						self._atmosphere_music.stream = AudioStreamMP3.load_from_file(
							"res://assets/audios/atmospheres/main.mp3"
						)
						self._atmosphere_music.play(5)

						body.transition_open()

				if body is Player:
					if self._clear:
						(body.find_child("EnemyDetectionArea") as Area2D).monitoring = false
					else:
						(body.find_child("EnemyDetectionArea") as Area2D).monitoring = true

				if body.collision_layer & Enums.CollisionLayer.ENEMY and not body.dead:
					body.set_invincible(false)
					should_be_clear = false

		self._clear = should_be_clear


func _on_body_entered(body: PhysicsBody2D) -> void:
	if self._clear:
		return

	if body.is_in_group("Enemy") and not self._visited:
		body.set_invincible.call_deferred(true)

	if body is Player and not self._visited:
		self._visited = true
		body.global_position.y = min(body.global_position.y, self.global_position.y - 16)
