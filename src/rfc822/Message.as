package rfc822
{
	import s.isin;
	import s.isspace;

	public class Message
	{
		public var iterator : ReadIterator;
		public var seekable : Boolean;
		
		public var dict : Object = {};
		public var unixfrom : String = '';
		public var headers : Array = new Array ( );
		public var status : String = '';
		
		public function Message ( iterator : ReadIterator, seekable : Boolean = true )
		{
			this.iterator = iterator;
			this.seekable = seekable;
			
			readheaders ( );
		}
		
		public function readheaders():void
		{
			var line : String;
			var lst : Array = new Array ( );
			var firstLine : Boolean = true;
			var headerseen : String;
			while ( true ) {
				line = iterator.readline ( 65537 );
				if ( ! line )
					break;
				
				if ( firstLine && line.indexOf ( "From " ) )
					unixfrom = unixfrom + line;
				
				firstLine = false;
				
				headerseen = isheader ( line );
				if ( headerseen ) {
					lst[lst.length] = line;
					dict[headerseen] = line.substring ( headerseen.length + 1 );
				} else {
					// TODO Not dict
					if ( ! dict )
						status = "No headers";
					else
						status = 'Non-header line where header expected';
				}
			}
		}
		
		public function isheader ( line : String ) : String
		{
			var i : int = line.indexOf ( ":" );
			if ( i > 0 )
				return line.substring ( 0, i ).toLowerCase ( );
			return null;
		}
		
		public function islast ( line : String ) : Boolean
		{
			return isin ( line, [ '\r\n', '\n' ] );
		}
		
		public function iscomment ( line ) : Boolean
		{
			return false;
		}
		
		public function getallmatchingheaders ( name : String ) : Array
		{
			var n : int;
			var lst : Array;
			var hit : int;
			var line : String;
			name = name.toLowerCase ( ) + ":";
			n = name.length;
			lst = new Array ( );
			hit = 0;
			
			for each ( line in headers )
				if ( line.substring ( 0, n ).toLowerCase ( ) == name )
					hit = 1;
				else if ( isspace ( line.substring ( 0, 1 ) ) )
					hit = 0;
				if ( hit )
					lst[lst.length] = line;
						
			return lst;
		}
		
		public function getfirstmatchingheader ( name : String ) : Array
		{
			var n : int;
			var lst : Array;
			var hit : int;
			var line : String;
			name = name.toLowerCase ( ) + ":";
			n = name.length;
			lst = new Array ( );
			hit = 0;
			
			for each ( line in headers )
				if ( hit )
					if ( ! isspace ( line.substr ( 0, 1 ) ) )
						break;
				else if ( line.substring ( 0, n ) == name )
					hit = 1;
				if ( hit )
					lst[lst.length] = line;
			
			return lst;
		}
		
		public function getheader ( name : String, Default : String = null ) : String
		{
			return dict[name.toUpperCase ( )];
		}
		
		public function getheaders ( name : String ) : Array
		{
			var result : Array = new Array ( );
			var current : String = "";
			var have_header : Boolean = false;
			var str : String;
			
			for each ( str in getallmatchingheaders ( name ) ) {
				if ( isspace ( str.substring ( 0, 1 ) ) )
					if ( current )
						current = 
			}
		}
	}
}