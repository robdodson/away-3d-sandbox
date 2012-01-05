package com.inchworm
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.SegmentSet;
	import away3d.primitives.LineSegment;
	
	import flash.geom.Vector3D;
	
	public class TimelineCell extends ObjectContainer3D
	{
		//-----------------------------------------------------------------
		// CLASS MEMBERS
		private var _lines					:SegmentSet;
		private var _startLine				:LineSegment;
		private var _endLine				:LineSegment;
		private var _width					:Number;
		
		//-----------------------------------------------------------------
		
		public function TimelineCell()
		{
			super();
			
			_width = 30;
			_startLine = new LineSegment(new Vector3D(0, -100, 0), new Vector3D(0, 100, 0), 0xFFFFFF, 0xFFFFFF, 4);
			_endLine = new LineSegment(new Vector3D(_width, -100, 0), new Vector3D(_width, 100, 0), 0xFFFFFF, 0xFFFFFF, 4);
			_lines = new SegmentSet();
			_lines.addSegment(_startLine);
			_lines.addSegment(_endLine);
			addChild(_lines);
		}
		
		public function get width():Number
		{
			return _width;
		}
	}
}