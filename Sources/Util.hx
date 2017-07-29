package ;

class Util {
	public function new (){

	}
	inline public static function aabbCheck(ax:Float,ay:Float,awidth:Float,aheight:Float,bx:Float,by:Float,bwidth:Float,bheight:Float){
		return (ax < bx + bwidth &&
				ax + awidth > bx &&
				ay < by + bheight &&
				aheight + ay > by);
	}
	inline public static function aabbPointCheck(ax:Float,ay:Float,awidth:Float,aheight:Float,pointx:Float,pointy:Float){
		return (ax < pointx &&
				ax + awidth > pointx &&
				ay < pointy &&
				aheight + ay > pointy);
	}
}