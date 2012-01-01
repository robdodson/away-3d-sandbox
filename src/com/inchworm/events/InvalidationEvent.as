package com.inchworm.events
{
	import flash.events.Event;
	
	public class InvalidationEvent extends Event
	{
		public static const INVALIDATED:String = "invalidationInvalidated";
		public static const VALIDATED:String = "invalidationValidated";
		
		public function InvalidationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new InvalidationEvent(type, bubbles, cancelable);
		}
		override public function toString():String
		{
			return formatToString("InvalidationEvent", "type", "bubbles", "cancelable",
				"eventPhase");
		}
	}
}