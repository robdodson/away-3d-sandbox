package
{
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	
	import flash.display.Sprite;
	
	public class LinkedListIteration extends Sprite
	{
		private var list:DLinkedList;
		private var obj1:Object;
		private var obj2:Object;
		private var obj3:Object;
		
		public function LinkedListIteration()
		{
			super();
			
			obj1 = {name: 'hello'};
			obj2 = {name: 'world'};
			obj3 = {name: 'foo'};
			
			list = new DLinkedList(obj1, obj2, obj3);
			
			var listItr:DListIterator = list.getListIterator();
			var value:*;
			
			/*
			// read all the values out
			while (listItr.hasNext())
			{
				value = listItr.next();
				trace(value.name);
			}
			*/
			
			/*
			// move the head to the back
			while (listItr.hasNext())
			{
				value = listItr.next();
				trace(value.name);
				if (value.name == 'hello')
				{
					value.name = 'bar';
					list.append(list.removeHead());
				}
			}
			*/
			
			// move the tail to the front
			listItr.end();
			while (listItr.hasPrev())
			{
				value = listItr.prev();
				trace(value.name);
				if (value.name == 'foo')
				{
					value.name = 'bar';
					list.prepend(list.removeTail());
				}
			}
		}
	}
}