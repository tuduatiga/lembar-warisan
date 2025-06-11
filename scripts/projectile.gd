class_name Projectile
extends Node2D

@export var texture: Texture2D
@export var bullet_speed: float

var direction: Vector2 = Vector2.ZERO
var _speed: float = 150.0

@onready var _sprite: Sprite2D = self.find_child("Sprite2D")
@onready var _hitbox: HitboxComponent = self.find_child("HitboxComponent")


func _ready() -> void:
	if self.texture:
		self._sprite.texture = self.texture

	self._hitbox.body_hit.connect(_on_body_hit)
	self._hitbox.area_hit.connect(_on_area_hit)


func with_texture(p_texture: Texture2D) -> Projectile:
	self.texture = p_texture
	return self


func with_modulate(p_modulate: Color) -> Projectile:
	self._sprite.modulate = p_modulate
	return self


func spawn(proprietor: Node2D, speed: float = 150) -> Projectile:
	proprietor.get_node("/root/Game").add_child(self)
	self._hitbox.proprietor = proprietor
	var proprietor_pos: Vector2 = proprietor.global_position
	self.direction = (self.get_global_mouse_position() - proprietor_pos).normalized()
	self._sprite.rotate(self.direction.angle())
	# var dir_angle: float = self.direction.angle()
	# var on_the_bottom_edge: bool = (
	# dir_angle <= 0 and dir_angle > -PI / 8
	# ) or (
	# dir_angle > -PI and dir_angle < -7/8*PI
	# )
	#
	# if on_the_bottom_edge:
	# 	proprietor_pos.y -= 8.0
	# 	self.direction = (self.get_global_mouse_position() - proprietor_pos).normalized()

	self.global_position = proprietor_pos + self.direction * 10
	self._speed = speed
	return self


func spawn_with_direction(
	proprietor: Node2D, p_direction: Vector2, speed: float = 150
) -> Projectile:
	proprietor.get_node("/root/Game").add_child(self)
	self._hitbox.proprietor = proprietor
	self.direction = p_direction
	self._sprite.rotate(self.direction.angle())
	self.global_position = proprietor.global_position + self.direction * 10
	self._speed = speed
	return self


func _physics_process(delta: float) -> void:
	self.position += self.direction * self._speed * delta


func _on_area_hit(area: Area2D) -> void:
	if self._hitbox.proprietor:
		if self._hitbox.proprietor.is_in_group("Player") and area.is_in_group("Enemy"):
			self.queue_free()
		if self._hitbox.proprietor.is_in_group("Enemy") and area.is_in_group("Player"):
			self.queue_free()
	else:
		if area.is_in_group("Enemy"):
			self.queue_free()


func _on_body_hit(body: Node2D) -> void:
	if self._hitbox.proprietor:
		if self._hitbox.proprietor == body:
			return
	self.queue_free()
