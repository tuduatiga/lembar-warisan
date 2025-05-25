extends Node2D

const SPEED = 200.0

var direction: Vector2 = Vector2.ZERO

@onready var _hitbox: HitboxComponent = self.find_child("HitboxComponent")


func _ready() -> void:
	self._hitbox.body_hit.connect(_on_body_hit)
	self._hitbox.area_hit.connect(_on_area_hit)


func spawn(proprietor: Node2D):
	proprietor.get_tree().root.get_child(1).add_child(self)
	self._hitbox.proprietor = proprietor
	self.direction = (self.get_global_mouse_position() - proprietor.global_position).normalized()
	self.rotate(self.direction.angle())
	self.global_position = proprietor.global_position + self.direction * 10
	self.find_child("HitboxComponent").proprietor = proprietor


func _physics_process(delta: float) -> void:
	self.position += self.direction * self.SPEED * delta


func _on_area_hit(area: Area2D):
	if area.is_in_group("Enemy"):
		self.queue_free()


func _on_body_hit(_body):
	self.queue_free()
