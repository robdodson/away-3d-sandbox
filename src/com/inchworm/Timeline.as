package com.inchworm
{
	import away3d.containers.ObjectContainer3D;
	
	public class Timeline extends ObjectContainer3D
	{
		//-----------------------------------------------------------------
		// Primitives etc
		private var numCells			:int = 3;
		private var cells				:Array;
		private var minBoundsX			:Number = -50;
		private var maxBoundsX			:Number = 50;
		
		//-----------------------------------------------------------------
		
		public function Timeline()
		{
			super();
			
			var centerCell:TimelineCell = new TimelineCell();
			
			addChild(centerCell);
			
			// Setup the primitives
			cells = new Array();
			var firstCell:TimelineCell = new TimelineCell();
			//firstCell.x = -150;
			cells.push(firstCell);
			addChild(firstCell);
			
			for (var i:int = 1; i < numCells; i++) 
			{
				var cell:TimelineCell = new TimelineCell();
				var prevCell:TimelineCell = cells[i - 1];
				cell.x = prevCell.x + prevCell.width; 
				cells.push(cell);
				addChild(cell);
			}
		}
		
		public function moveCells(vx:Number):void
		{
			for (var i:int = 0; i < numCells; i++) 
			{
				var cell:TimelineCell = cells[i];
				cell.x += vx;
				
				if (cell.x < minBoundsX)
				{
					// remove the cell
					// add to front queue
				}
				else if (cell.x + cell.width > maxBoundsX)
				{
					// remove the cell
					// add to back queue
				}
			}
		}
	}
}