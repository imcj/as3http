package mimetools
{
	import rfc822.Message;
	
	public class Message extends rfc822.Message
	{
		public function Message ( iterator : ReadIterator, seekable : Boolean = true )
		{
			super ( iterator, seekable );
		}
	}
}