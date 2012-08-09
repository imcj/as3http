package flexUnitTests.rfc822
{
	import flash.utils.ByteArray;
	
	import org.flexunit.asserts.assertEquals;
	
	import rfc822.Message;
	
	import utils.TextIterator;

	public class TestMessage
	{	
		public var message : Message;
		
		[Before]
		public function setUp():void
		{
			var mail : String = 'From cj@ubuntu  Sat Jul 21 17:26:31 2012\nReturn-Path: <cj@ubuntu>\nX-Original-To: cj@ubuntu\nDelivered-To: cj@ubuntu\nReceived: by ubuntu (Postfix, from userid 1000)\n	id 9C408A106; Sat, 21 Jul 2012 17:26:31 +0800 (CST)\nSubject: title\nTo: <cj@ubuntu>\nX-Mailer: mail (GNU Mailutils 2.2)\nMessage-Id: <20120721092631.9C408A106@ubuntu>\nDate: Sat, 21 Jul 2012 17:26:31 +0800 (CST)\nFrom: cj@ubuntu (cj)\nX-IMAPbase: 1342862793 2\nStatus: O\nX-UID: 1\n\ntest\n\nFrom cj@ubuntu  Sat Jul 21 17:26:59 2012\nReturn-Path: <cj@ubuntu>\nX-Original-To: cj@ubuntu\nDelivered-To: cj@ubuntu\nReceived: by ubuntu (Postfix, from userid 1000)\n	id 45F80AABD; Sat, 21 Jul 2012 17:26:59 +0800 (CST)\nSubject: title2\nTo: <cj@ubuntu>\nX-Mailer: mail (GNU Mailutils 2.2)\nMessage-Id: <20120721092659.45F80AABD@ubuntu>\nDate: Sat, 21 Jul 2012 17:26:59 +0800 (CST)\nFrom: cj@ubuntu (cj)\n\ntest\n\n';
			var bytes : ByteArray = new ByteArray ( );
			bytes.writeUTFBytes ( mail.replace ( '\\n', '\n' ) );
			bytes.position = 0;
			var readIterator : TextIterator = new TextIterator ( bytes );
			message = new Message ( readIterator );
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Test]
		public function TestGetHeadersByNameIsStatus ( ) : void
		{
			var result : Array = message.getheaders ( "Status" );
			assertEquals ( "O", result[0] );
		}
		
		[Test]
		public function TestGetByNameIsStatus ( ) : void
		{
			assertEquals ( "O", message.get ( "Status" ) );
		}
	}
}