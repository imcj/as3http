package flexUnitTests.s
{
	import org.flexunit.asserts.assertEquals;
	
	import s.rstrip;

	public class TestRstrip
	{			
		[Test]
		public function testRstrip ( ) : void
		{
			assertEquals ( "2B", rstrip ( "2B " ) );
			assertEquals ( " 2B", rstrip ( " 2B " ) );
			assertEquals ( "2 B", rstrip ( "2 B " ) );
			assertEquals ( " \t\n\r\v\f2B", rstrip ( " \t\n\r\v\f2B\t" ) );
		}
	}
}