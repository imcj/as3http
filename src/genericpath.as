package
{
	public class genericpath
	{
		static public function _splitext ( path : String, sep : String, altsep : String, extsep : String ) : Array
		{
			var sepIndex      : int;
			var altsepIndex   : int;
			var dotIndex      : int;
			var filenameIndex : int;
			sepIndex = path.lastIndexOf ( sep );
			if ( altsep )
				altsepIndex = path.lastIndexOf ( altsep );
			
			sepIndex = sepIndex > altsepIndex ? sepIndex : altsepIndex;
			
			dotIndex = path.lastIndexOf ( extsep );
			if ( dotIndex > sepIndex ) {
				filenameIndex = sepIndex + 1;
				while ( filenameIndex < dotIndex ) {
					if ( path.substr ( filenameIndex, 1 ) != extsep )
						return [ path.substring ( 0, dotIndex ), path.substring ( dotIndex ) ];
					filenameIndex += 1;
				}
			}
			
			return [ path, '' ];
		}
	}
}