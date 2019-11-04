var utils = {
	containsPoint: function( rect, x, y ) {
		return !( x < rect.x || x > rect.x + rect.width || 
				  y < rect.y || y > rect.y + rect.height )
	},

	intersects: function( rectA, rectB ) {
		return !( rectA.x + rectA.width < rectB.x ||
				  rectB.x + rectB.width < rectA.x ||
				  rectA.y + rectA.height < rectB.y ||
				  rectB.y + rectB.height < rectA.y )
	}
}