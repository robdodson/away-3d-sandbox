package com.app
{
	import away3d.containers.ObjectContainer3D;
	import away3d.loaders.parsers.Max3DSParser;
	import away3d.primitives.InteractiveSpritePlane;
	import away3d.tools.utils.Bounds;
	
	public class MasonryLayout
	{
		public var rowCount:uint;
		public var colCount:uint;
		public var cellWidth:uint;		// cell width not counting padding
		public var cellHeight:uint;		// cell height not counting padding
		public var cellPaddingX:uint;
		public var cellPaddingY:uint;
		
		private var grid:Array;
		
		private var bias:Array;
		private var biasIndex:uint;
		//private var biasSuccessTestArray:Array;
		
		private var i:int;
		private var j:int;
		
		//private var items:Array;		// *** not sure we need this
		private var firstItem:Object;	// definitely need this
		
		private var cellsWide:uint;
		private var cellsHigh:uint;
		
		private var centerX:uint;
		private var centerY:uint;
		
		private const whichApproach:String = "BIAS";
		private const e:Number = 2.71828183;
		
		private const UP:String = "UP";			
		private const DOWN:String = "DOWN";
		private const RIGHT:String = "RIGHT";
		private const LEFT:String = "LEFT";
		
		public function MasonryLayout(_colCount:uint=12, _rowCount:uint=8, _cellWidth:uint=128, _cellHeight:uint=128, _cellPaddingX:uint=0, _cellPaddingY:uint=0)
		{
			rowCount = _rowCount;
			colCount = _colCount;
			cellWidth = _cellWidth;
			cellHeight = _cellHeight;
			cellPaddingX = _cellPaddingX;
			cellPaddingY = _cellPaddingY;
			
			
			
			// define our 2d array, setting a boolean value for "full" and defining each cell's x/y position in the grid
			grid = new Array();
			
			for (i=0; i < colCount; i++){
				grid[i] = new Array();
				for (j=0; j < rowCount; j++){
					grid[i][j] = { full:false, x: (i * (cellWidth + cellPaddingX)), y: (j * (cellHeight + cellPaddingY)), weight:0 };
				}
			}
			
			
			
			/*
			// nice touch but we don't need it yet
			// define up/down/left/right pointers for each cell
			for (i=0; i < colCount; i++){
			for (j=0; j < rowCount; j++){
			if (i > 0){
			grid[i][j][LEFT] = grid[i-1][j];
			}
			if (j > 0){
			grid[i][j][UP] = grid[i][j-1];	
			}
			if (i < (colCount - 1)){
			grid[i][j][RIGHT] = grid[i+1][j];
			}
			if (j < (rowCount - 1)){
			grid[i][j][DOWN] = grid[i][j+1];
			}
			}
			}
			*/
			
			// approach #1 - BIAS - assume we'll always start from the center (plus or minus some random offset) and seek to add items generally in one direction or another
			if (whichApproach == "BIAS"){
				var r:Number = Math.random();
				if (r < 0.25){
					bias = new Array(RIGHT,LEFT,DOWN,UP);
				} else if (r >= 0.25 && r < 0.5) {
					bias = new Array(LEFT,RIGHT,UP,DOWN);
				} else if (r >= 0.5 && r < 0.75){
					bias = new Array(RIGHT,LEFT,UP,DOWN);
				} else {
					bias = new Array(LEFT,RIGHT,DOWN,UP);
				}
				//biasSuccessTestArray = new Array(false, false, false, false);
				biasIndex = 0;
			}
			
			// approach #2, WEIGHT - assign gaussian weights to central grid nodes, and prefer the probability of the heavier weights at some point
			if (whichApproach == "WEIGHT"){
				var normal_rows:uint = grid[0].length;
				var normal_cols:uint = grid.length;
				var m:Number = 0;
				var sd:Number = 1;
				var sq2pi:Number = Math.sqrt(2*Math.PI);
				var sdsq:Number = sd*sd;
				
				for(i=0; i < normal_cols; i++){
					var xmsq:Number = -1 * (i-m)*(i-m);
					for (j=0; j < normal_rows; j++){
						var ymsq:Number = -1 * (j-m)*(j-m);
						grid[i][j].weight = (((1 / (sd * sq2pi)) * (Math.pow(e, (xmsq/sdsq)))) + ((1 / (sd * sq2pi)) * (Math.pow(e, (ymsq/sdsq)))) / 2);  // should result in weights 0-1
					}
					
				}
			}
		}
		
		public function get centerXInCells():uint{
			return(Math.round(colCount/2));
		}
		public function set centerXInCells(n:uint):void{
			
		}
		public function get centerYInCells():uint{
			return(Math.round(rowCount/2));
		}
		public function set centerYInCells(n:uint):void{
			
		}
		public function get centerXInSnappedUnits():Number{
			return(Math.round(colCount/2) * (cellWidth + cellPaddingX));
		}
		public function set centerXInSnappedUnits(n:Number):void{
			
		}
		public function get centerYInSnappedUnits():Number{
			return(Math.round(rowCount/2) * (cellHeight + cellPaddingY));
		}
		public function set centerYInSnappedUnits(n:Number):void{
			
		}
		public function get centerXInExactUnits():Number{
			return((colCount/2) * (cellWidth + cellPaddingX));
		}
		public function set centerXInExactUnits(n:Number):void{
			
		}
		public function get centerYInExactUnits():Number{
			return((rowCount/2) * (cellHeight + cellPaddingY));
		}
		public function set centerYInExactUnits(n:Number):void{
			
		}
		
		
		// this should be called if you want to refresh the grid after placing some items
		public function clearGrid():void{
			for (i=0; i < colCount; i++){
				for (j=0; j < rowCount; j++){
					grid[i][j].full = false;
				}
			}
			//items = null;
			firstItem = null;
		}
		
		
		// assumes each item in the array supports assignment of the x and y values and has width and height parameters
		// also assumes items is pre-sorted by whatever you want to be placed first towards whatever you want to be placed last
		// returns the index of the last placed item in the array before we ran out of room
		
		// Possible values for positioning:
		// "" - normal, don't do anything other than fit items in the grid, 0,0 is the top-left of the grid
		// "centered" - centers grid of items around 0,0
		// "centeredsnap" -  it snaps the centered grid to the nearest grid position to 0,0
		// "topleftjustified" - justify the visible content so that it is flush with the top-left of the cartesian coordinate system
		
		public function placeItems(items:Vector.<InteractiveSpritePlane>, positioning:String=""):uint{
			//items = _items; // *** do I not want to hold onto this?
			for (i=0; i < items.length; i++){
				cellsWide = Math.ceil(items[i].width / (cellWidth + cellPaddingX));
				cellsHigh = Math.ceil(items[i].height / (cellHeight + cellPaddingY));
				
				centerX = Math.round(colCount/2 - cellsWide/2);
				centerY = Math.round(rowCount/2 - cellsHigh/2);
				
				var cX:Number;
				var cY:Number;
				var mX:Number;
				var mY:Number;
				
				// find the item a home
				switch(whichApproach){
					case "BIAS":
						var j:uint;
						if (i == 0){
							// first item, position near the center, somewhat randomly
							firstItem = { item: items[0], x: centerX + (Math.round((Math.random() * 3) - 1.5)), y: centerY + (Math.round((Math.random() * 3) - 1.5)), cellsWide: cellsWide, cellsHigh: cellsHigh  }
							placeItem(items[i], firstItem.x, firstItem.y);
						} else {
							if (!bias_findItemAPlace(items[i])){
								
								if (positioning=="centeredsnap"){
									cX = centerXInSnappedUnits;
									cY = centerYInSnappedUnits;
									for (j=0; j < i; j++){
										items[j].x = items[j].x - cX;
										items[j].y = items[j].y + cY;	// *** optimized for ObjectContainer3D, make it a - if using DisplayObjects here
									}
								} else if (positioning=="centered"){
									cX = centerXInExactUnits;
									cY = centerYInExactUnits;
									for (j=0; j < i; j++){
										items[j].x = items[j].x - cX;
										items[j].y = items[j].y + cY;
									}
								} else if (positioning=="justifiedbottomleft"){
									
									cX = Number.MAX_VALUE;
									cY = Number.MAX_VALUE;
									for (j=0; j < i; j++){
										cX = Math.min(cX, items[j].x - items[j].width/2);
										cY = Math.min(cY, items[j].y - items[j].height/2);
									}
									for (j=0; j < i; j++){
										items[j].x -= cX;
										items[j].y -= cY;
									}
									
								} else if (positioning=="justifiedtopleft"){
									trace("a");
									mY = Number.MIN_VALUE;
									cX = Number.MAX_VALUE;
									cY = Number.MAX_VALUE;
									for (j=0; j < i; j++){
										cX = Math.min(cX, items[j].x - items[j].width/2);
										cY = Math.min(cY, items[j].y - items[j].height/2);
										mY = Math.max(mY, items[j].y - items[j].height/2);
									}
									for (j=0; j < i; j++){
										items[j].x -= cX;
										items[j].y -= (cY + Math.abs(mY - cY));
									}
									
								}
								
								return(i);
							}
						}
						
						break;
					
					case "WEIGHT":
						
						break;
				}
			}
			
			if (positioning=="centeredsnap"){
				cX = centerXInSnappedUnits;
				cY = centerYInSnappedUnits;
				for (j=0; j < i; j++){
					items[j].x = items[j].x - cX;
					items[j].y = items[j].y + cY;	// *** optimized for ObjectContainer3D, make it a - if using DisplayObjects here
				}
			} else if (positioning=="centered"){
				cX = centerXInExactUnits;
				cY = centerYInExactUnits;
				for (j=0; j < i; j++){
					items[j].x = items[j].x - cX;
					items[j].y = items[j].y + cY;
				}
			} else if (positioning=="justifiedbottomleft"){
				cX = Number.MAX_VALUE;
				cY = Number.MAX_VALUE;
				for (j=0; j < i; j++){
					cX = Math.min(cX, items[j].x - items[j].width/2);
					cY = Math.min(cY, items[j].y - items[j].height/2);
				}
				for (j=0; j < i; j++){
					items[j].x -= cX;
					items[j].y -= cY;
				}
			} else if (positioning=="justifiedtopleft"){
				trace("b");
				mY = Number.MIN_VALUE;
				cX = Number.MAX_VALUE;
				cY = Number.MAX_VALUE;
				for (j=0; j < i; j++){
					cX = Math.min(cX, items[j].x - items[j].width/2);
					cY = Math.min(cY, items[j].y - items[j].height/2);
					mY = Math.max(mY, items[j].y - items[j].height/2);
				}
				for (j=0; j < i; j++){
					items[j].x -= cX;
					items[j].y -= (cY + Math.abs(mY - cY));
				}
			}
			
			//clearGrid();
			
			return(i);
		}
		
		
		// BIAS method: returns true if item was placed successfully, returns false if we weren't able to find it a home (ran out of room)
		private function bias_findItemAPlace(item:Object):Boolean{
			var startingBiasIndex:uint = biasIndex;
			
			//for (j=0; j < biasSuccessTestArray.length; j++){
			//	biasSuccessTestArray[j] = false;
			//}
			
			var placed:Boolean=false;
			// step 1. using the current bias direction, explore out from the center all the available spots, starting out 
			// either the width or height (depending on the direction) away from the center item, scanning perpendicular
			// to the direction we're heading in an ever-widening scope, gradually expanding outwards in our bias
			// direction as we fail.  (*** note: should we remember our distance from the last thing placed in this direction?)
			while (!placed){
				placed = bias_crawl(item, bias[biasIndex], firstItem.x, firstItem.y);
				
				// step 2. if we've failed in that direction, move onto the next bias direction and repeat step 1 until we've run out of directions
				// otherwise, break out and return true.
				
				if (++biasIndex >= bias.length){
					biasIndex = 0;
				}
				
				if (placed){
					return(true);
				} else if (biasIndex == startingBiasIndex){
					// we're out of room, return false
					return(false);
				} 
			}
			
			// step 3. if step 2 has failed, we're out of directions and this piece won't fit, return false
			return(false);
		}
		
		
		private function bias_crawl(item:Object, direction:String, startX:uint, startY:uint):Boolean{
			var vX:int = startX;  // vX and vY reflect the current positions in the crawl
			var vY:int = startY;
			var delta:int; // delta is the direction in which the primary crawl is going, either on the X or Y axis of the grid
			var initX:int; // initX and initY are used to define the starting point of a perpendicular crawl 
			var initY:int;
			var destX:int; // destX and Y are used to define the terminus of a perpendicular crawl
			var destY:int;
			
			//trace("direction: "+direction);
			
			switch(direction){
				case LEFT:
					delta = -1;
					break;
				case RIGHT:
					delta = 1;
					break;
				case UP:
					delta = -1;
					break;
				case DOWN:
					delta = 1;
					break;
			}
			
			// step 1a. move away cellWidth or cellHeight from the center in the direction we want to start and scan (the width of the firstItem # of cells + 2) (perpendicular scan direction randomly chosen)
			
			
			
			// init
			var creepDirection:int = (Math.random() > 0.5) ? 1 : -1;
			//trace("creepDirection: "+creepDirection);
			
			switch(direction){	// *** to do, remove switch
				case LEFT:
				case RIGHT:
					if (direction == LEFT){
						vX = initX = startX + (-cellsWide);
					} else if (direction == RIGHT){
						vX = initX = startX + (firstItem.cellsWide);
					}
					if (creepDirection == 1){
						vY = initY = startY - 1;
						destY = startY + firstItem.cellsHigh; // - cellsHigh;  // that last bit fails if center item is smaller than the next in the Y direction
					} else {
						vY = initY = startY + firstItem.cellsHigh; // - cellsHigh;  // that last bit fails if center item is smaller than the next in the Y direction
						destY = startY - 1;
					}
					break;
				case UP:
				case DOWN:
					if (direction == UP){
						vY = initY = startY + (-cellsHigh);
					} else if (direction == DOWN){
						vY = initY = startY + (firstItem.cellsHigh);
					}
					
					if (creepDirection == 1){
						vX = initX = startX - 1;
						destX = startX + firstItem.cellsWide; //  - cellsWide;  // that last bit fails if center item is smaller than the next in the X direction
					} else {
						vX = initX = startX + firstItem.cellsWide; // - cellsWide;  // that last bit fails if center item is smaller than the next in the X direction
						destX = startX - 1;
					}
					
					break;
			}
			
			// creep
			//var success:Boolean = false;
			var wif:int;
			
			switch(direction){
				case LEFT:
				case RIGHT:
					if (creepDirection == 1){
						for (vY = initY; vY <= destY; vY++){
							wif = willItemFit(item,vX,vY);
							if (wif == 1){
								placeItem(item,vX,vY);
								return(true);
							} else if (wif == -1) {
								break;
							}
						}
					} else {
						for (vY = initY; vY >= destY; vY--){
							wif = willItemFit(item,vX,vY);
							if (wif == 1){
								placeItem(item,vX,vY);
								return(true);
							} else if (wif == -1) {
								break;
							}
						}
					}
					break;
				case UP:
				case DOWN:
					if (creepDirection == 1){
						for (vX = initX; vX <= destX; vX++){
							wif = willItemFit(item,vX,vY);
							if (wif == 1){
								placeItem(item,vX,vY);
								return(true);
							} else if (wif == -1) {
								break;
							}
						}
					} else {
						for (vX = initX; vX >= destX; vX--){
							wif = willItemFit(item,vX,vY);
							if (wif == 1){
								placeItem(item,vX,vY);
								return(true);
							} else if (wif == -1) {
								break;
							}
						}
					}
					break;
			}
			
			
			// step 1b. if no spot is found, move away one more cell and do the same scan, but with expanding the sweep +2 cells on either side
			// repeat this until we run out of room.  
			while (wif != -1) {
				switch(direction){
					case LEFT:
					case RIGHT:
						vX = vX + (delta * 1);
						if (creepDirection == 1){
							initY = initY - 1;
							destY = destY + 1;	
						} else {
							initY = initY + 1;
							destY = destY - 1;
						}
						break;
					case UP:
					case DOWN:
						vY = vY + (delta * 1);
						if (creepDirection == 1){
							initX = initX - 1;
							destX = destX + 1;
							//vX = startX - 1;
							//destX = startX + firstItem.cellsWide + 1 - cellsWide;
						} else {
							initX = initX + 1;
							destX = destX - 1;
							//vX = startX + firstItem.cellsWide + 1 - cellsWide;
							//destX = startX - 1;
						}
						
						break;
				}
				
				
				switch(direction){
					case LEFT:
					case RIGHT:
						if (creepDirection == 1){
							for (vY = initY; vY <= destY; vY++){
								wif = willItemFit(item,vX,vY);
								if (wif == 1){
									placeItem(item,vX,vY);
									return(true);
								} else if (wif == -1) {
									break;
								}
							}
						} else {
							for (vY = initY; vY >= destY; vY--){
								wif = willItemFit(item,vX,vY);
								if (wif == 1){
									placeItem(item,vX,vY);
									return(true);
								} else if (wif == -1) {
									break;
								}
							}
						}
						break;
					case UP:
					case DOWN:
						if (creepDirection == 1){
							for (vX = initX; vX <= destX; vX++){
								wif = willItemFit(item,vX,vY);
								if (wif == 1){
									placeItem(item,vX,vY);
									return(true);
								} else if (wif == -1) {
									break;
								}
							}
						} else {
							for (vX = initX; vX >= destX; vX--){
								wif = willItemFit(item,vX,vY);
								if (wif == 1){
									placeItem(item,vX,vY);
									return(true);
								} else if (wif == -1) {
									break;
								}
							}
						}
						break;
				}	
			} 
			
			// step 1c. return false if the grid is full, true if we've placed something
			return(false);
		}
		
		
		private function placeItem(item:Object, x:uint, y:uint):Boolean{
			//trace("MasonryLayout.placeItem("+item+", "+x+", "+y+") cellsWide="+cellsWide+", cellsHigh="+cellsHigh);
			if (item is ObjectContainer3D){
				item.x = (x * (cellWidth + cellPaddingX)) + (item.width/2);
				item.y = -((y * (cellHeight + cellPaddingY)) + (item.height/2));
			} else {
				item.x = x * (cellWidth + cellPaddingX);
				item.y = y * (cellHeight + cellPaddingY);
			}
			for(var j:uint=x; j < (x + cellsWide); j++){
				for (var k:uint=y; k < (y + cellsHigh); k++){
					grid[j][k].full = true;
				}
			}
			return(true);
		}
		
		
		// assumes cellsWide and cellsHigh is still good -- 0: won't fit, 1: will fit, -1: out of room on edge of grid
		private function willItemFit(item:Object, x:uint, y:uint):int{
			//trace("MasonryLayout.willItemFit("+item+", "+x+", "+y+")");
			for (var j:uint=x; j < x + cellsWide; j++){
				for (var k:uint=y; k < y + cellsHigh; k++){
					if (grid[j]){
						if (grid[j][k]){
							
							if (grid[j][k].full){
								//trace("wif: 0");
								return(0);
							}
						} else {
							//trace("wif: -1");
							return(-1); // out of room
						}
					} else {
						//trace("wif: -1");
						return(-1); // out of room
					}
				}
			}
			//trace("wif: 1");
			return(1);
		}
		
		
		
	}
}