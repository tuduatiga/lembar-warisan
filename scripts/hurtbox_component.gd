class_name HurtBox extends Area2D


func _init() -> void:
	self.collision_layer = Enums.CollisionLayer.HURTBOX
	self.collision_mask = Enums.CollisionLayer.HITBOX

	self.area_entered.connect(self._on_area_entered)
	self.area_exited.connect(self._on_area_exited)


func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox is HitBox:
		if self.owner == hitbox.owner:
			return

		hitbox.damage(self.attack)
		self.owner.modulate = Color.RED


func _on_area_exited(hitbox: Area2D) -> void:
	if hitbox is HitBox and self.owner:
		if self.owner == hitbox.owner:
			return

		self.owner.modulate = Color.WHITE
