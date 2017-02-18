#!/usr/bin/php
<?php
function toSQL($filename) {
    $doc = new DOMDocument();
    $doc->loadXML(file_get_contents($filename));


    $ests = $doc->getElementsByTagName('EstablishmentDetail');

    $sql = '';

    $authorities = '';



}



toSQL(__DIR__.'/xml/FHRS336en-GB.xml');