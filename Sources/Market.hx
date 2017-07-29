package ;

class Market extends Citizen {
	override public function new (project){
		super(project);
		tileType = NationGrid.Tile.Market;
		returned = true;
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,5*16,0,16,16);
	}
	
	override function idle () {
		
	}
}