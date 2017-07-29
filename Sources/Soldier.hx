package ;

class Soldier extends Citizen {
	var closest:Citizen = null;
	var dist = Math.POSITIVE_INFINITY;
	var attacking:Citizen;
	var damage = .25;
	override public function new (project){
		super(project);
		tileType = NationGrid.Tile.Soldier;
		activity = idle;
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,16,0,16,16);
		damage = .7+Math.random();
	}
	function attack(){
		if (attacking == null || attacking.health < 1){
			attacking = null;
			activity = returning;
		}else{
			velocity = velocity.mult(.6);
			attacking.health -= damage;
			project.particles.push(new BloodParticle(new kha.math.Vector2(8+(pos.x+attacking.pos.x)/2,8+(pos.y+attacking.pos.y)/2)));
		}
		
		if (health < 10)
			activity = returning;
	}
	override function idle () {
		dist = Math.POSITIVE_INFINITY;
		closest = null;
		for (citizen in project.citizens){
			if (citizen != this && citizen.fromNation != fromNation){
				var d = Math.sqrt(Math.pow(citizen.pos.x - pos.x,2) + Math.pow(citizen.pos.y - pos.y,2));
				if (d < dist){
					closest = citizen;
					dist = d;
				}
			}
		}

		
		if (dist < 30){
			attacking = closest;
			activity = attack;
		}
		if (dist > 200){
			activity = returning;
		}else{
			if (closest != null){
				var angle = Math.atan2(closest.pos.y - pos.y,closest.pos.x - pos.x);
				velocity.x = Math.cos(angle)*speed;
				velocity.y = Math.sin(angle)*speed;
			}
		}
	}
}