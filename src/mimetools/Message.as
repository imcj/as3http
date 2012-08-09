package mimetools
{
	import rfc822.Message;
	import utils.TextIterator;
	
	public class Message extends rfc822.Message
	{
		public function Message ( iterator : TextIterator, seekable : Boolean = true )
		{
			super ( iterator, seekable );
		}
	}
}