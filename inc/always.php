<?php
/**
* @package rscds
* @author Andrew McMillan <andrew@catalyst.net.nz>
* @copyright Catalyst IT Ltd
* @license   http://gnu.org/copyleft/gpl.html GNU GPL v2
*/

// Ensure the configuration starts out as an empty object.
unset($c);

// Default some of the configurable values
$c->sysabbr     = 'rscds';
$c->admin_email = 'andrew@catalyst.net.nz';
$c->system_name = "Really Simple CalDAV Store";
$c->domain_name = $_SERVER['SERVER_NAME'];

// Kind of private configuration values
$c->total_query_time = 0;

if ( $debugging && isset($_GET['method']) ) {
  $_SERVER['REQUEST_METHOD'] = $_GET['method'];
}

/**
* Writes a debug message into the error log using printf syntax
* @package rscds
*/
function dbg_error_log() {
  global $c;
  $argc = func_num_args();
  $args = func_get_args();
  if ( 2 <= $argc ) {
    $format = array_shift($args);
  }
  else {
    $format = "%s";
  }
  error_log( $c->sysabbr.": DBG: ". vsprintf( $format, $args ) );
}


dbg_error_log( "==========> method =%s= =%s:%d= =%s= =%s=",
            $_SERVER['REQUEST_METHOD'], $_SERVER['SERVER_NAME'], $_SERVER['SERVER_PORT'], $_SERVER['SCRIPT_NAME'], $_SERVER['PATH_INFO']);
if ( file_exists("/etc/rscds/".$_SERVER['SERVER_NAME']."-conf.php") ) {
  include_once("/etc/rscds/".$_SERVER['SERVER_NAME']."-conf.php");
}
else if ( file_exists("../config/config.php") ) {
  include_once("../config/config.php");
}
else {
  include_once("rscds_configuration_missing.php");
  exit;
}

// In case this was forced in the configuration file
$_SERVER['SERVER_NAME'] = $c->domain_name;

if ( !function_exists('apache_request_headers') ) {
  function apache_request_headers() {
    return getallheaders();
  }
}

function dbg_log_array( $name, $arr, $recursive = false ) {
  foreach ($arr as $key => $value) {
    dbg_error_log( "%s: >>%s<< = >>%s<<", $name, $key, $value);
    if ( $recursive && (gettype($value) == 'array' || gettype($value) == 'object') ) {
      dbg_log_array( "$name"."[$key]", $value, $recursive );
    }
  }
}

include_once("PgQuery.php");
include_once("BasicAuthSession.php");
// include_once("iCalendar.php");

?>