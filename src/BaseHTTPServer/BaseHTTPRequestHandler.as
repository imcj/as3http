package BaseHTTPServer
{
	import SocketServer.BaseServer;
	import SocketServer.StreamRequestHandler;
	
	import flash.net.Socket;
	import flash.utils.Dictionary;
	
	import mimetools.Message;
	
	import mx.utils.StringUtil;
	
	import utils.TextIterator;
	
	public class BaseHTTPRequestHandler extends StreamRequestHandler
	{
		static public const sys_version : String = "ActionScript/3.0";
		static public const __version__ : String = "0.1";
		static public const default_request_version : String = "HTTP/0.9";
		static public const protocol_version : String = "HTTP/1.0";
		
		// TODO Python string dict
		static public const DEFAULT_ERROR_MESSAGE : String = "\
		<head>\n\
		<title>Error response</title>\n\
		</head>\n\
		<body>\n\
		<h1>Error response</h1>\n\
		<p>Error code {0}.\n\
		<p>Message: {1}.\n\
		<p>Error code explanation: {0} = {2}.\n\
		</body>\n\
		";
		
		static public const DEFAULT_ERROR_CONTENT_TYPE : String = "text/html";
		
		static public const responses : Object = {
			100: ['Continue', 'Request received, please continue'],
			101: ['Switching Protocols',
				'Switching to new protocol; obey Upgrade header'],
			
			200: ['OK', 'Request fulfilled, document follows'],
			201: ['Created', 'Document created, URL follows'],
			202: ['Accepted',
				'Request accepted, processing continues off-line'],
			203: ['Non-Authoritative Information', 'Request fulfilled from cache'],
			204: ['No Content', 'Request fulfilled, nothing follows'],
			205: ['Reset Content', 'Clear input form for further input.'],
			206: ['Partial Content', 'Partial content follows.'],
			
			300: ['Multiple Choices',
				'Object has several resources -- see URI list'],
			301: ['Moved Permanently', 'Object moved permanently -- see URI list'],
			302: ['Found', 'Object moved temporarily -- see URI list'],
			303: ['See Other', 'Object moved -- see Method and URL list'],
			304: ['Not Modified',
				'Document has not changed since given time'],
			305: ['Use Proxy',
				'You must use proxy specified in Location to access this ' +
				'resource.'],
			307: ['Temporary Redirect',
				'Object moved temporarily -- see URI list'],
			
			400: ['Bad Request',
				'Bad request syntax or unsupported method'],
			401: ['Unauthorized',
				'No permission -- see authorization schemes'],
			402: ['Payment Required',
				'No payment -- see charging schemes'],
			403: ['Forbidden',
				'Request forbidden -- authorization will not help'],
			404: ['Not Found', 'Nothing matches the given URI'],
			405: ['Method Not Allowed',
				'Specified method is invalid for this resource.'],
			406: ['Not Acceptable', 'URI not available in preferred format.'],
			407: ['Proxy Authentication Required', 'You must authenticate with ' +
				'this proxy before proceeding.'],
			408: ['Request Timeout', 'Request timed out; try again later.'],
			409: ['Conflict', 'Request conflict.'],
			410: ['Gone',
				'URI no longer exists and has been permanently removed.'],
			411: ['Length Required', 'Client must specify Content-Length.'],
			412: ['Precondition Failed', 'Precondition in headers is false.'],
			413: ['Request Entity Too Large', 'Entity is too large.'],
			414: ['Request-URI Too Long', 'URI is too long.'],
			415: ['Unsupported Media Type', 'Entity body in unsupported format.'],
			416: ['Requested Range Not Satisfiable',
				'Cannot satisfy request range.'],
			417: ['Expectation Failed',
				'Expect condition could not be satisfied.'],
			
			500: ['Internal Server Error', 'Server got itself in trouble'],
			501: ['Not Implemented',
				'Server does not support this operation'],
			502: ['Bad Gateway', 'Invalid responses from another server/proxy.'],
			503: ['Service Unavailable',
				'The server cannot process the request due to a high load'],
			504: ['Gateway Timeout',
				'The gateway server did not receive a timely response'],
			505: ['HTTP Version Not Supported', 'Cannot fulfill request.']
		};
		
		static public const weekdayname : Array = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
		
		static public const monthname : Array = [null,
			'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
			'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
		
		public var request_version : String;
		public var close_connection:Boolean;
		public var command : String;
		public var path : String;
		public var version : String;
		public var raw_requestline:String;
		public var requestline:String;
		public var iter : TextIterator;
		public var headers : Message;
		public var MessageClass : Class = mimetools.Message;
		
		public function BaseHTTPRequestHandler ( request : Socket, client_address : Array, server : BaseServer )
		{
			iter = new TextIterator ( request );
			super(request, client_address, server);
		}
		
		override public function handle ( ) : void
		{
			close_connection = true;
			handle_one_request ( );
			while ( ! close_connection )
				handle_one_request ( );
		}
		
		public function handle_one_request():void
		{
			var mname : String;
			var method : Function;
			raw_requestline = iter.readline ( 65537 );
			if ( raw_requestline.length > 65536 ) {
				requestline = '';
				request_version = '';
				command = '';
				send_error ( 414 );
			}
			
			if ( ! raw_requestline ) {
				close_connection = true;
				return;
			}
			
			if ( ! parse_header ( ) )
				return;
			
			mname = "do_" + command;
			if ( ! this.hasOwnProperty ( mname ) ) {
				send_error ( 501, StringUtil.substitute ( "Unsupported method ({0})", command ) );
				return;
			}
			
			method = this[mname];
			method ( );
			request.flush ( );
		}
		
		public function parse_header():Boolean
		{
			var version : String;
			var words : Array;
			var command : String;
			var path : String;
			var conntype : String;
			
			command = null;
			this.request_version = version = default_request_version;
			close_connection = true;
			requestline = raw_requestline;
//			requestline.rstrip
			words = requestline.split ( " " );
			if ( 3 == words.length )
			{
				command = words[0];
				path = words[1];
				version = words[2];
				if ( "HTTP/" == version.substring ( 0, 5 ) ){
					
				}
			} else if ( ! words )
				return false;
			else {
				send_error ( 501, StringUtil.substitute ( "Bad request syntax ({0})", requestline ) );
				return false;
			}
			
			this.command = command;
			this.path    = path;
			this.request_version = version;
			headers = new this.MessageClass ( iter, 0 );
			conntype = headers.get ( "Connection" );
			if ( "close" == conntype.toLowerCase ( ) )
				close_connection = true;
			else if ( "keep-alive" == conntype.toLowerCase ( ) && protocol_version >= "HTTP/1.1" )
				close_connection = false;
			
			return true;
		}
		
		public function send_error ( code : int, message : String = null ) : void
		{
			var short : String, long : String, explain : String;
			var error : Array = responses[code];
			var content : String;
			if ( null == error ) {
				short = long = "???";
			} else {
				short = error[0];
				long  = error[1];
			}
			
			if ( ! message )
				message = short;
			explain = long;
			log_error ( StringUtil.substitute ( "code {0}, message {1}", code, message ) );
			
			content = StringUtil.substitute ( DEFAULT_ERROR_MESSAGE, code, _quote_html ( message ), explain ) ;
			send_response ( code, message );
			send_header ( "Content-Type", DEFAULT_ERROR_CONTENT_TYPE );
			send_header ( "Connection", "close" );
			end_headers ( );
			
			if ( "HEAD" != this.command && 200 <= code && ! ( code in [ 204, 304 ] ) )
				request.writeUTFBytes ( content );
		}
		
		public function send_response ( code : int, message : String = null ) : void
		{
			log_request ( new String ( code ) );
			if ( ! message )
				if ( code in responses )
					message = responses[code][0];
				else
					message = '';
			
			if ( request_version != 'HTTP/0.9' )
				request.writeUTFBytes ( StringUtil.substitute ( "{0} {1} {2}\r\n", protocol_version, code, message ) );
			
			send_header ( 'Server', version_string ( ) );
			send_header ( 'Date', date_time_string ( ) );
		}
		
		public function send_header ( keyword : String, value : String ) : void
		{
			if ( 'HTTP/0.9' != request_version )
				request.writeUTFBytes ( StringUtil.substitute ( "{0}: {1}\r\n", keyword, value ) );
			
			if ( keyword.toLowerCase ( ) == 'connection' )
				if ( value.toLowerCase ( ) == 'close' )
					close_connection = true;
				else
					close_connection = false;
		}
		
		public function end_headers ( ) : void
		{
			if ( 'HTTP/0.9' != request_version )
				request.writeUTFBytes ( "\r\n" );
		}
		
		// TODO ...
		public function log_error ( format : String, ... args ) : void
		{
			log_message ( format, args );
		}
		
		public function log_message ( format : String, ... args ) : void
		{
			
		}
		
		public function log_request ( code : String = '-', size : String = '-' ) : void
		{
			log_message ( '"{0}" {1} {2}', requestline, code, size );
		}
		
		private function _quote_html ( html : String ) : String
		{
			return html.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
		}
		
		public function get server_version ( ) : String
		{
			return "BaseHTTP/" + __version__;
		}
		
		public function version_string ( ) : String
		{
			return server_version + ' ' + sys_version;
		}
		
		public function date_time_string ( ) : String
		{
			var now : Date = new Date ( );
			
			return StringUtil.substitute (
				"{0}/{1}/{2} {3}:{4}:{5}",
				weekdayname[now.getDay ( ) - 1],
				monthname[now.monthUTC],
				now.fullYearUTC,
				b0 ( now.hoursUTC ),
				b0 ( now.minutesUTC ),
				b0 ( now.secondsUTC )
			);
		}
		
		protected function b0 ( num : int ) : String
		{
			if ( num < 10 )
				return "0" + new String ( num );
			else
				return new String ( num );
		}
	}
}
