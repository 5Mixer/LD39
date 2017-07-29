package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Project {
	var playerGrid:NationGrid;
	var enemyGrid:NationGrid;
	var input:Input;
	var inBattle = false;
	var camera:Camera;
	var tilePlaceIndex = 0;
	public var citizens = new Array<Citizen>();
	public var particles = new Array<Particle>();
	public var projectiles = new Array<Projectile>();
	var nationGrids = new Array<NationGrid>();
	var frame = 0;
	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);

		input = new Input(this);
		camera = new Camera();

		playerGrid = new NationGrid(true);
		playerGrid.worldpos = new kha.math.Vector2(20,160);
		playerGrid.name = "human";
		nationGrids.push(playerGrid);

		enemyGrid = new NationGrid();
		enemyGrid.worldpos = new kha.math.Vector2(20,-15);
		enemyGrid.name = "cpu";
		nationGrids.push(enemyGrid);

	}

	public function startBattle(){
		inBattle = true;

		for (grid in nationGrids){
			grid.endOfDay();

			var i = 0;
			for (tile in grid.tiles){
				var tx = i % grid.size.width;
				var ty = Math.floor(i/grid.size.width);

				var citizen:Citizen = null;
				if (tile == NationGrid.Tile.Soldier)
					citizen = new Soldier(this);
				if (tile == NationGrid.Tile.Archer)
					citizen = new Archer(this);
				
				if (citizen != null){
					citizen.pos.x = (grid.worldpos.x) + (tx*16); 
					citizen.pos.y = (grid.worldpos.y) + (ty*16);
					citizen.returnToLocation = citizen.pos.mult(1);
					citizen.returnToTile = new kha.math.Vector2(tx,ty);
					citizen.nation = grid;
					citizen.fromNation = grid.name;
					citizens.push(citizen);
					grid.setTile(tx,ty,NationGrid.Tile.Empty);
				}

				i++;
			}
		}
		
	}

	function update(): Void {
		frame++;
		

		for (particle in particles){
			particle.update();
			if (particle.life < 1){
				particles.remove(particle);
			}
		}
		for (projectile in projectiles){
			projectile.update();
			if (projectile.life < 1){
				projectiles.remove(projectile);
				continue;
			}
			for (citizen in citizens){
				if (citizen.fromNation == projectile.fromNation) continue;
				if(Util.aabbCheck(projectile.pos.x+3,projectile.pos.y+3,10,10,citizen.pos.x,citizen.pos.y,16,16)){
					citizens.remove(citizen);
				}
			}
		}

		if (inBattle){
			
			for (citizen in citizens){
				citizen.update();
				if (citizen.health < 1){
					citizens.remove(citizen);
				}
				if (citizen.returned){
					citizen.nation.setTile(Math.floor(citizen.returnToTile.x),Math.floor(citizen.returnToTile.y),citizen.tileType);
					citizens.remove(citizen);
				}
			}
			if (citizens.length == 0){
				inBattle = false;
			}
		}else{
			tilePlaceIndex += input.mouseScroll;
			if (tilePlaceIndex < 0) tilePlaceIndex = 3;
			if (tilePlaceIndex > 3) tilePlaceIndex = 0;

			if (input.mouseButtonDown){
				if (Util.aabbPointCheck(playerGrid.worldpos.x,playerGrid.worldpos.y,playerGrid.size.width*16,playerGrid.size.height*16,input.worldMousePos.x,input.worldMousePos.y)){
					var tileMousex = Math.floor((input.worldMousePos.x - playerGrid.worldpos.x)/16);	
					var tileMousey = Math.floor((input.worldMousePos.y - playerGrid.worldpos.y)/16);
					playerGrid.setTile(tileMousex,tileMousey,NationGrid.Tile.createByIndex(tilePlaceIndex));
				}
			}
		}
		input.mouseScroll = 0;
	}

	function render(framebuffer: Framebuffer): Void {
		var g = framebuffer.g2;
		g.begin(true,kha.Color.fromBytes(145,190,100));
		camera.transform(g);
		for (grid in nationGrids){
			grid.render(g);
		}
		for (citizen in citizens){
			citizen.render(g);
		}

		for (projectile in projectiles)
			projectile.render(g);
		for (particle in particles)
			particle.render(g);
		
		// g.drawImage(kha.Assets.images.Spritesheet,input.worldMousePos.x,input.worldMousePos.y);
		
		g.drawSubImage(kha.Assets.images.Spritesheet,input.worldMousePos.x,input.worldMousePos.y,16*tilePlaceIndex,0,16,16);
		camera.restore(g);
		g.end();
	}
}
