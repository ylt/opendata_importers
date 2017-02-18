#!/bin/bash
PWD=`pwd`


SQL=$(cat <<'SQL'
	DROP TABLE IF EXISTS `places`;
	CREATE TABLE `places` (
		`ID` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
		`NAMES_URI` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`NAME1` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`NAME1_LANG` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`NAME2` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`NAME2_LANG` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`TYPE` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`LOCAL_TYPE` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`GEOMETRY_X` FLOAT NULL DEFAULT NULL,
		`GEOMETRY_Y` FLOAT NULL DEFAULT NULL,
		`MOST_DETAIL_VIEW_RES` INT(11) NULL DEFAULT NULL,
		`LEAST_DETAIL_VIEW_RES` INT(11) NULL DEFAULT NULL,
		`MBR_XMIN` FLOAT NULL DEFAULT NULL,
		`MBR_YMIN` FLOAT NULL DEFAULT NULL,
		`MBR_XMAX` FLOAT NULL DEFAULT NULL,
		`MBR_YMAX` FLOAT NULL DEFAULT NULL,
		`POSTCODE_DISTRICT` VARCHAR(10) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`POSTCODE_DISTRICT_URI` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`POPULATED_PLACE` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`POPULATED_PLACE_URI` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`POPULATED_PLACE_TYPE` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`DISTRICT_BOROUGH` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`DISTRICT_BOROUGH_URI` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`DISTRICT_BOROUGH_TYPE` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`COUNTY_UNITARY` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`COUNTY_UNITARY_URI` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`COUNTY_UNITARY_TYPE` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`REGION` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`REGION_URI` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`COUNTRY` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`COUNTRY_URI` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`RELATED_SPATIAL_OBJECT` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`SAME_AS_DBPEDIA` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`SAME_AS_GEONAMES` VARCHAR(100) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		PRIMARY KEY (`ID`)
	)
	COLLATE='utf8_unicode_ci'
	ENGINE=InnoDB
	;
SQL
);

for file in opname_csv_gb/DATA/*.csv; do
	SQL=$SQL$(cat <<SQL
	LOAD DATA LOCAL
	INFILE '$PWD/$file' REPLACE INTO TABLE \`places\`
	FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"' LINES TERMINATED BY '\r\n'
	(\`ID\`, \`NAMES_URI\`, \`NAME1\`, \`NAME1_LANG\`, \`NAME2\`, \`NAME2_LANG\`, \`TYPE\`, \`LOCAL_TYPE\`, \`GEOMETRY_X\`, \`GEOMETRY_Y\`, \`MOST_DETAIL_VIEW_RES\`, \`LEAST_DETAIL_VIEW_RES\`, @MBR_XMIN, @MBR_YMIN, @MBR_XMAX, @MBR_YMAX, \`POSTCODE_DISTRICT\`, \`POSTCODE_DISTRICT_URI\`, \`POPULATED_PLACE\`, \`POPULATED_PLACE_URI\`, \`POPULATED_PLACE_TYPE\`, \`DISTRICT_BOROUGH\`, \`DISTRICT_BOROUGH_URI\`, \`DISTRICT_BOROUGH_TYPE\`, \`COUNTY_UNITARY\`, \`COUNTY_UNITARY_URI\`, \`COUNTY_UNITARY_TYPE\`, \`REGION\`, \`REGION_URI\`, \`COUNTRY\`, \`COUNTRY_URI\`, \`RELATED_SPATIAL_OBJECT\`, \`SAME_AS_DBPEDIA\`, \`SAME_AS_GEONAMES\`)
	
	SET
	MBR_XMIN=nullif(@MBR_XMIN, ''),
	MBR_YMIN=nullif(@MBR_YMIN, ''),
	MBR_XMAX=nullif(@MBR_XMAX, ''),
	MBR_YMAX=nullif(@MBR_YMAX, '')
;
SQL
	);
done

echo $SQL;
