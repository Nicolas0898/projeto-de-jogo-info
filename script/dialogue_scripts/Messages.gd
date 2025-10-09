extends Resource
class_name Message

#enum Personagens{
#	personagem_a, 
#	personagem_b,
#	personagem_c
#}

enum Posicoes{
	direita,
	esquerda,
	nenhum
}

#enum Bordas{
#	borda_1,
#	borda_2,
#	borda_3
#}

@export var text : String
#@export var character : Personagens
@export var sprite_pos : Posicoes
@export var sprite : Texture
@export var border : Texture
#@export var border : Bordas
