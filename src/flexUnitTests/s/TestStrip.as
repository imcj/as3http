package flexUnitTests.s
{
	import org.flexunit.asserts.assertEquals;
	
	import s.strip;

	public class TestStrip
	{			
		[Test]
		public function testStrip ( ) : void
		{
			assertEquals ( "2B", strip ( " 2B" ) );
			assertEquals ( "2B ", strip ( "  2B " ) );
			assertEquals ( "2 B", strip ( " 2 B" ) );
			assertEquals ( "2B\t", strip ( " \t\n\r\v\f2B\t" ) );
		}
	}
}