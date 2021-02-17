extends AnimatedSprite


# IMPORTANT: for the sprite of each human, make a material copy so we can change the shader parameter
func _ready():
	self.set_material(self.get_material().duplicate())
