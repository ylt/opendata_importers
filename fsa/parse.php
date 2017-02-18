#!/usr/bin/php
<?php

require_once(__DIR__.'/../config.php');

function toSQL($filename) {
    /**
     * @var $db \PDO
     */
    $db = Config::$database;

    $doc = simplexml_load_file($filename);

    $sql = <<<SQL
INSERT INTO `food` (
    `FHRSID`,
    `LocalAuthorityBusinessID`,
    `BusinessName`,
    `BusinessType`,
    `BusinessTypeID`,
    `AddressLine1`,
    `AddressLine2`,
    `AddressLine3`,
    `AddressLine4`,
    `RatingValue`,
    `RatingStatus`,
    `RatingDate`,
    `LocalAuthorityCode`,
    `ScoreHygiene`,
    `ScoreStructural`,
    `ScoreConfidenceInManagement`,
    `SchemeType`,
    `NewRatingPending`,
    `Geocode_Lon`,
    `Geocode_Lat`
  ) VALUES
 -- comment out first comma ;)
SQL;


    $authorities = [];

    $ests = $doc->xpath('*/EstablishmentDetail');
    foreach($ests as $est) {
        //print_r($est);

        $data = [
            'FHRSID' => $db->quote($est->FHRSID, PDO::PARAM_INT),
            'LocalAuthorityBusinessID'=> $db->quote($est->LocalAuthorityBusinessID),
            'BusinessName'=> $db->quote($est->BusinessName),
            'BusinessType'=> $db->quote($est->BusinessType),
            'BusinessTypeID'=> $db->quote($est->BusinessTypeID, PDO::PARAM_INT),
            'AddressLine1'=> $db->quote($est->AddressLine1),
            'AddressLine2'=> $db->quote($est->AddressLine2),
            'AddressLine3'=> $db->quote($est->AddressLine3),
            'AddressLine4'=> $db->quote($est->AddressLine4),
            'RatingValue'=> is_numeric((string)$est->RatingValue)?$db->quote($est->RatingValue, PDO::PARAM_INT):'NULL',
            'RatingStatus'=> !is_numeric((string)$est->RatingValue)?$db->quote($est->RatingValue):'NULL',
            'RatingDate'=> !empty((string)$est->RatingDate)?$db->quote($est->RatingDate):'NULL',
            'LocalAuthorityCode'=> $db->quote($est->LocalAuthorityCode, PDO::PARAM_INT),
            'ScoreHygiene'=> is_numeric((string)$est->Scores->Hygiene)?$db->quote($est->Scores->Hygiene, PDO::PARAM_INT):'NULL',
            'ScoreStructural'=> is_numeric((string)$est->Scores->Structural)?$db->quote($est->Scores->Structural, PDO::PARAM_INT):'NULL',
            'ScoreConfidenceInManagement'=> is_numeric((string)$est->Scores->ConfidenceInManagement)?$db->quote($est->Scores->ConfidenceInManagement, PDO::PARAM_INT):'NULL',
            'SchemeType'=> $db->quote($est->SchemeType, PDO::PARAM_BOOL),
            'NewRatingPending'=> $db->quote($est->NewRatingPending == 'True'?1:0, PDO::PARAM_BOOL),
            'Geocode_Lon'=> isset($est->Geocode->Longitude)?$db->quote($est->Geocode->Longitude, PDO::PARAM_INT):'NULL',
            'Geocode_Lat'=> isset($est->Geocode->Latitude)?$db->quote($est->Geocode->Latitude, PDO::PARAM_INT):'NULL'
        ];

        $sql .= ", \r\n";
        $sql .= '('.implode(', ', $data).')';

    }

    //echo $sql;

    if (!$db->query($sql))
        print_r($db->errorInfo());
}

/**
 * @var $db \PDO
 */
$db = Config::$database;

$db->query(<<<SQL
DROP TABLE IF EXISTS `food`;
CREATE TABLE `food` (
	`FHRSID` INT(11) NOT NULL,
	`LocalAuthorityBusinessID` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`BusinessName` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`BusinessType` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`BusinessTypeID` INT(11) NULL DEFAULT NULL,
	`AddressLine1` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`AddressLine2` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`AddressLine3` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`AddressLine4` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`RatingValue` INT(11) NULL DEFAULT NULL,
	`RatingStatus` VARCHAR(20) NULL DEFAULT NULL,
	`RatingDate` DATE NULL DEFAULT NULL,
	`LocalAuthorityCode` INT(11) NULL DEFAULT NULL,
	`ScoreHygiene` INT(11) NULL DEFAULT NULL,
	`ScoreStructural` INT(11) NULL DEFAULT NULL,
	`ScoreConfidenceInManagement` INT(11) NULL DEFAULT NULL,
	`SchemeType` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`NewRatingPending` TINYINT(1) NULL DEFAULT NULL,
	`Geocode_Lon` DOUBLE NULL DEFAULT NULL,
	`Geocode_Lat` DOUBLE NULL DEFAULT NULL
);
SQL
);


$files = scandir(__DIR__.'/xml');
foreach($files as $i => $filename) {
    if ($filename[0] == '.') continue;
    toSQL(__DIR__.'/xml/'.$filename);
    echo sprintf('%.2f', $i / (count($files)-1) * 100)."% \n";
}


//toSQL(__DIR__.'/xml/FHRS336en-GB.xml');