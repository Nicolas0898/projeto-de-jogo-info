extends Node
var total_coins = 15

var Player : PlayerCharacter
var player_health = 100
var spawnpoint = null

func collect_coin(value:int):
	total_coins+= value
