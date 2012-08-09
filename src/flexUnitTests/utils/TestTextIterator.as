package flexUnitTests.utils
{
	import org.flexunit.asserts.assertEquals;
	
	import utils.TextIterator;

	public class TestTextIterator
	{		
		public var iter : TextIterator;
		
		[Before]
		public function setUp():void
		{
			iter = TextIterator.createFromString ( "2B\r\nXiaoHua\nJiaJia" );
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[Test]
		public function testReadline ( ) : void
		{
			assertEquals ( "2B", iter.readline ( 65537 ) );
			assertEquals ( "XiaoHua", iter.readline ( ) );
			assertEquals ( "JiaJia", iter.readline ( ) );
		}
		
	}
}