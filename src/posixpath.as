package
{
	public class posixpath
	{
		static public var curdir : String = '.';
		static public var pardir : String = '..';
		static public var extsep : String = '.';
		static public var sep : String = '/';
		static public var pathsep : String = ':';
		static public var defpath : String = ':/bin:/usr/bin';
		static public var altsep : String = null;
		static public var devnull : String = '/dev/null';

			
		public function posixpath()
		{
		}
		
		static public function splitext ( path : String ) : Array
		{
			return genericpath._splitext ( path, sep, altsep, extsep);
		}
	}
}