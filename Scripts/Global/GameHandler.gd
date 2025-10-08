extends Node
var total_coins = 0

var Player : PlayerCharacter

func collect_coin(value:int):
	total_coins+= value
