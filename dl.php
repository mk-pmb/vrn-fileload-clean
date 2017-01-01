<?php # -*- coding: utf-8, tab-width: 2 -*-

Header('Content-Type: text/plain; charset=UTF-8');

if (!@chdir(__DIR__ . '/tmp')) { die('Failed to chdir'); }

function flinch_if_header($hdr) {
  if ((string)@$_SERVER[$hdr] !== '') { die('bad header: ' . $hdr); }
}
flinch_if_header('HTTP_PROXY');
flinch_if_header('HTTPS_PROXY');


$bfn = (string)@$_REQUEST['bfn'];
if (preg_match('!^[A-Za-z0-9_\\-]+$!', $bfn, $bfn)) {
  $bfn = $bfn[0];
} else {
  die('bad ?bfn=');
}

$result_fn = $bfn . '.png';
$output = array();
$retval = NULL;
if (@file_exists($result_fn)) {
  $retval = 0;
} else {
  putenv('FILELOAD_BFN=' . $bfn);
  exec('../fileload_clean.sh --clean-old-tmp --env 2>&1', $output, $retval);
}

if ($retval === 0) { Header('Location: ./tmp/' . $result_fn); }

foreach ($output as $ln) { echo "$ln\n"; }
