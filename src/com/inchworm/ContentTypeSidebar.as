package com.inchworm
{
	import away3d.containers.ObjectContainer3D;
	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.entities.SegmentSet;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.Plane;
	import away3d.tools.Merge;
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.gskinner.utils.Rnd;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class ContentTypeSidebar extends ObjectContainer3D
	{
		//-----------------------------------------------------------------
		// Stage
		private var _stage					:Stage;
		
		// Dimensions
		private var _width					:Number = 50;
		private var _height					:Number = 745;
		
		// Padding
		private var _padding				:Number = 2;
		
		// Contents
		private var _numContents			:int = 100;
		private var _contentTypes			:Vector.<int>;
		
		// Blocks
		private var _blocks					:Vector.<Plane>;
		private var _material				:ColorMaterial;
		
		//-----------------------------------------------------------------
		
		public function ContentTypeSidebar(stage:Stage)
		{
			super();
			
			_stage = stage;
			_createContents();
			_createBlocks();
			
			TweenMax.to(_material, 2, {delay: 2, hexColors:{color:0x00FF00}});
		}
		
		//-----------------------------------------------------------------
		//
		// PRIVATE
		//
		//-----------------------------------------------------------------
		
		private function _createContents():void
		{
			_contentTypes = new Vector.<int>();
			for (var i:int = 0; i < _numContents; i++) 
			{
				var type:int = Rnd.integer(1, 6);
				_contentTypes.push(type);
			}
		}
		
		private function _createBlocks():void
		{
			_blocks = new Vector.<Plane>();
			var blockHeight:Number = (_height - (_padding * (_numContents - 1))) / _numContents;
			for (var i:int = 0; i < _numContents; i++) 
			{
				var block:Plane = new Plane(new ColorMaterial(Math.random() * 0xFFFFFF), _width, blockHeight, 1, 1, false);
				if (i > 0)
				{
					var prevBlock:Plane = _blocks[i - 1];
					block.y = prevBlock.y - blockHeight - _padding
				}
				else
				{
					_material = ColorMaterial(block.material);
				}
				
				_blocks.push(block);
				addChild(block);
			}
		}
		
		//-----------------------------------------------------------------
		//
		// GETTERS / SETTERS
		//
		//-----------------------------------------------------------------
		
		public function get width():Number
		{
			return _width;
		}
		
		public function get height():Number
		{
			return _height;
		}
	}
}