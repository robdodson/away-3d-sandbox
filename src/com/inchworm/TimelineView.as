package com.inchworm
{
	import away3d.containers.ObjectContainer3D;
	
	import com.inchworm.pools.SimpleObjectPool;
	
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	
	public class TimelineView extends ObjectContainer3D
	{
		//-----------------------------------------------------------------
		// Primitives etc
		private var numCells			:int = 10;
		private var cells				:Array;
		private var cellList			:DLinkedList;
		private var listItr				:DListIterator;
		private var minBoundsX			:Number;
		private var maxBoundsX			:Number;
		
		//-----------------------------------------------------------------
		
		public function TimelineView()
		{
			super();
			
			var centerCell:TimelineCellView = new TimelineCellView();
			//addChild(centerCell);
			
			minBoundsX = -((numCells * centerCell.width) / 2);
			maxBoundsX = -(minBoundsX);
			
			// Setup the primitives
			cells = new Array();
			var firstCell:TimelineCellView = new TimelineCellView();
			cellList = new DLinkedList();
			firstCell.x = minBoundsX;
			cells.push(firstCell);
			cellList.append(firstCell);
			addChild(firstCell);
			
			for (var i:int = 1; i < numCells; i++) 
			{
				var cell:TimelineCellView = new TimelineCellView();
				var prevCell:TimelineCellView = cells[i - 1];
				cell.x = prevCell.x + prevCell.width; 
				cells.push(cell);
				cellList.append(cell);
				addChild(cell);
			}
			
			listItr = cellList.getListIterator();
		}
		
		public function moveCells(vx:Number):void
		{
			var cell:TimelineCellView;
			if (vx < 0) // TODO: Maybe switch this to a bitwise operation?
			{
				// We're moving left
				listItr.start();
				while (listItr.hasNext())
				{
					cell = listItr.next();
					cell.x += vx;
					// If a cell has gone past the minimum boundary
					// recycle it to the other side of the screen
					if (cell.x < minBoundsX)
					{
						var tail:TimelineCellView = cellList.tail.data;
						cell.x = tail.x + tail.width;
						cellList.append(cellList.removeHead());
					}
				}
			}
			else
			{
				// We're moving right
				listItr.end();
				while (listItr.hasPrev())
				{
					cell = listItr.prev(); 
					cell.x += vx;
					// If a cell has gone past the maximum boundary
					// recycle it to the other side of the screen
					if (cell.x > maxBoundsX)
					{
						var head:TimelineCellView = cellList.head.data;
						cell.x = head.x - cell.width;
						cellList.prepend(cellList.removeTail());
					}
				}	
			}
		}
	}
}