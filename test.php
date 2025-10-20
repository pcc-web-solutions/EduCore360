<?php
require "server.php";
$timetable = new Timetable();
if($timetable->generate($dmo->getSchInfo($_SESSION['user'])['data'],'1')){
    echo "Timetable successfully generated"."<br>"."Go to options to export it.";
}else{
    die('Unable to generate timetable'."<br>"."View <a href='#' target='_blank'> event log </a> to see what happened.");
}