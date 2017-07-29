package ;

enum Tile {
	Empty;
	Soldier;
	Blacksmith;
	Farmer;
}
typedef GridSize = {
	var width:Int;
	var height:Int;
}

class NationGrid {
	public var tiles:Array<Tile> = [];
	public var size:GridSize = {width: 9, height: 6};
	public var worldpos:kha.math.Vector2;
	public var humanControlled = false;
	public var name:String;

	public function new (){
		for (y in 0...size.height){
			for (x in 0...size.width){
				tiles.push(Math.random() > .9999999999 ? Tile.Empty : Tile.Soldier);
			}
		}
		/*
		var m = 
		"sssssssss
		 eefffffee
		 eefffffee
		 eeefffeee
		 eeebbbeee
		 eeebbeeee".split("");
		tiles = [];
		for (tile in m){
			if (tile=='\n'||tile==""||tile==" ") continue;
			tiles.push(switch(tile){
				case "s":Tile.Soldier;
				case "f":Tile.Farmer;
				case "b":Tile.Blacksmith;
				case "e":Tile.Empty;
				case _:Tile.Empty;
			});
		}*/

		worldpos = new kha.math.Vector2(0,0);
	}
	public function render(g:kha.graphics2.Graphics){
		g.pushTranslation(worldpos.x*4,worldpos.y*4);
		g.color = kha.Color.Black;
		g.fillRect(0,0,size.width*16,size.height*16);
		g.color = kha.Color.fromBytes(145,190,100);
		g.drawRect(0,0,size.width*16,size.height*16);
		g.color = kha.Color.White;
		
		for (y in 0...size.height){
			for (x in 0...size.width){
				var tile = tiles[y*size.width + x];
				if (tile == null){
					throw "Null tile";
				}
				// g.color = switch tile{
				// 	case Tile.Empty: kha.Color.Black ;
				// 	case Tile.Blacksmith:kha.Color.Blue;
				// 	case Tile.Farmer: kha.Color.Yellow;
				// 	case Tile.Soldier: kha.Color.White; 
				// }
				g.drawSubImage(kha.Assets.images.Spritesheet,x*16,y*16,16*(tile.getIndex()),0,16,16);
			}
		}
		g.popTransformation();
	}
	public function setTile(x:Int,y:Int,tile:Tile){
		tiles[(y*size.width)+x] = tile;
	}
}