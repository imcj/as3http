package utils
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class TextIterator
	{
		private var _input : IDataInput;
		private var data : String = "";
		private var offset : int = 0;
		
		public function TextIterator ( input : IDataInput )
		{
			_input = input;
		}
		
		public function readline ( length : int = 0 ) : String
		{
			if ( _input.bytesAvailable > 0 )
				data += _input.readUTFBytes ( _input.bytesAvailable );
			
			var crlf : String = "\r\n";
			var index : int = data.indexOf ( crlf, offset );
			if ( index < 0 ) {
				crlf = "\n";
				index = data.indexOf ( crlf, offset );
			}
			var found : String;
			if ( index > -1 ) {
				found = data.substring ( offset, index );
				offset = index + crlf.length;
			} else if ( data.length > offset )
				found = data.substring ( offset );
			else
				found = null;
			
			return found;
		}
		
		static public function createFromString ( text : String ) : TextIterator
		{
			var bytes : ByteArray = new ByteArray ( );
			bytes.writeUTFBytes ( text );
			bytes.position = 0;
			
			var iterator : TextIterator = new TextIterator ( bytes );
			return iterator;
		}
	}
}