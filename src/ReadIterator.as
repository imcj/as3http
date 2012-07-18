package
{
	import flash.utils.IDataInput;

	public class ReadIterator
	{
		private var _input : IDataInput;
		private var data:String;
		private var offset : int = 0;
		
		public function ReadIterator ( input : IDataInput )
		{
			_input = input;
		}
		
		public function readline ( length : int ) : String
		{
			if ( _input.bytesAvailable > 0 )
				data += _input.readUTFBytes ( 65537 );
			
			var index : int = data.indexOf ( "\r\n", offset );
			var found : String;
			if ( index > -1 ) {
				found = data.substring ( offset, index );
				offset = index + "\r\n".length;
			} else
				found = null;
			
			return found;
		}
	}
}