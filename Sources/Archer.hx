package ;

class Archer extends Citizen {
	var closest:Citizen = null;
	var dist = Math.POSITIVE_INFINITY;
	var attacking:Citizen;
	var damage = .25;
	var firerate = 1;
	override public function new (project){
		super(project);
		tileType = NationGrid.Tile.Archer;
		speed = .5+(Math.random()*.75);
	}
	override public function render(g:kha.graphics2.Graphics){
		g.drawSubImage(kha.Assets.images.Spritesheet,pos.x,pos.y,4*16,0,16,16);
		damage = .7+Math.random();

		firerate = Math.floor(30+Math.random()*20);//30-50 frames between shots
	}
	function shoot(){
		if (attacking == null || attacking.health < 1){
			attacking = null;
			activity = idle;
		}else{
			velocity = velocity.mult(.6);
			attacking.health -= damage;
			project.particles.push(new BloodParticle(new kha.math.Vector2(8+(pos.x+attacking.pos.x)/2,8+(pos.y+attacking.pos.y)/2)));
			velocity = velocity.mult(.5);
		}
		distBasedBehaviour();
		
		if (health < 10)
			activity = returning;
	}
	function firing (){
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

		if (frame%firerate==0 && closest != null){
			var arrow = new Arrow(pos.mult(1));
			var angle = Math.atan2(closest.pos.y - pos.y,closest.pos.x - pos.x);
			arrow.fromNation = fromNation;
			arrow.angle = angle;
			arrow.setVelocityFromAngle(angle,3);
			project.projectiles.push(arrow);
		}
		
		distBasedBehaviour();
	}
	function gettingCloser (){
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

		if (closest != null){
			var angle = Math.atan2(closest.pos.y - pos.y,closest.pos.x - pos.x);
			velocity.x = Math.cos(angle)*speed;
			velocity.y = Math.sin(angle)*speed;
		}
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

		distBasedBehaviour();
	}
	function distBasedBehaviour(){
		if (dist < 20){
			activity = returning;
		}else if (dist < 100){
			activity = firing;
		}else{
			activity = gettingCloser;
		}
	}
}