#!/bin/bash
PWD=`pwd`

SQL=$(cat <<'SQL'
	DROP TABLE IF EXISTS `postcodes`;
	CREATE TABLE `postcodes` (
		`Postcode` VARCHAR(50) NOT NULL COLLATE 'utf8_unicode_ci',
		`Positional_quality_indicator` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`Eastings` INT(11) NULL DEFAULT NULL,
		`Northings` INT(11) NULL DEFAULT NULL,
		`Country_code` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`NHS_regional_HA_code` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`NHS_HA_code` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`Admin_county_code` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`Admin_district_code` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		`Admin_ward_code` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
		PRIMARY KEY (`Postcode`),
		INDEX `Admin_ward_code` (`Admin_ward_code`),
		INDEX `Admin_district_code` (`Admin_district_code`),
		INDEX `NHS_HA_code` (`NHS_HA_code`),
		INDEX `NHS_regional_HA_code` (`NHS_regional_HA_code`),
		INDEX `Admin_county_code` (`Admin_county_code`)
	)
	COLLATE='utf8_unicode_ci'
	ENGINE=InnoDB
	;


SQL
)

for file in codepo_gb/Data/CSV/*.csv; do
	SQL=$SQL$(cat <<SQL
	LOAD DATA LOCAL
		INFILE '$PWD/$file'
		REPLACE INTO TABLE \`postcodes\`
		FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"' LINES TERMINATED BY '\\r\\n'
		(\`Postcode\`, \`Positional_quality_indicator\`, \`Eastings\`, \`Northings\`, \`Country_code\`, \`NHS_regional_HA_code\`, \`NHS_HA_code\`, \`Admin_county_code\`, \`Admin_district_code\`, \`Admin_ward_code\`);

SQL
	)
done;

SQL=$SQL$(cat <<'SQL'
	DROP TABLE IF EXISTS `codetype`;
	CREATE TABLE `codetype` (
		`code` VARCHAR(3) NOT NULL,
		`name` VARCHAR(40) NULL,
		PRIMARY KEY (`code`)
	)
	COLLATE='utf8_unicode_ci'
	ENGINE=InnoDB
	;

	INSERT INTO `codetype` (`code`, `name`) VALUES ('CTY', 'County');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('DIS', 'District');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('DIW', 'District Ward');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('LBO', 'London Borough');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('LBW', 'London Borough Ward');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('MTD', 'Metropolitan District');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('MTW', 'Metropolitan District Ward');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('UTA', 'Unitary Authority');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('UTE', 'Unitary Authority Electrol Division');
	INSERT INTO `codetype` (`code`, `name`) VALUES ('UTW', 'Unity Authority Ward');

	DROP TABLE IF EXISTS `codelist`;
	CREATE TABLE `codelist` (
	`value` VARCHAR(200) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	`code` VARCHAR(10) NOT NULL COLLATE 'utf8_unicode_ci',
	`type` VARCHAR(3) NULL DEFAULT NULL COLLATE 'utf8_unicode_ci',
	INDEX `value` (`value`),
	INDEX `code` (`code`),
	PRIMARY KEY (`code`)
)
COLLATE='utf8_unicode_ci'
ENGINE=InnoDB
;

SQL
)


mkdir -p scratch
# 1 = Metadata
# 2 = AREA_CODES
xlsx2csv -s 3 codepo_gb/Doc/Codelist.xlsx scratch/cty.csv # CTY - County
xlsx2csv -s 4 codepo_gb/Doc/Codelist.xlsx scratch/dis.csv # DIS - District
xlsx2csv -s 5 codepo_gb/Doc/Codelist.xlsx scratch/diw.csv # DIW - District Ward
xlsx2csv -s 6 codepo_gb/Doc/Codelist.xlsx scratch/lbo.csv # LBO - London Borough
xlsx2csv -s 7 codepo_gb/Doc/Codelist.xlsx scratch/lbw.csv # LBW - London Borough Ward
xlsx2csv -s 8 codepo_gb/Doc/Codelist.xlsx scratch/mtd.csv # MTD - Metropolitan District
xlsx2csv -s 9 codepo_gb/Doc/Codelist.xlsx scratch/mtw.csv # MTW - Metropolitan District Ward
xlsx2csv -s 10 codepo_gb/Doc/Codelist.xlsx scratch/uta.csv # UTA - Unitary Authority
xlsx2csv -s 11 codepo_gb/Doc/Codelist.xlsx scratch/ute.csv # UTE - Unitary Authority Electrol Division
xlsx2csv -s 12 codepo_gb/Doc/Codelist.xlsx scratch/utw.csv # UTW - Unity Authority Ward

for type in cty dis diw lbo lbw mtd mtw uta ute utw; do
	SQL=$SQL$(cat <<SQL
	LOAD DATA LOCAL
		INFILE '$PWD/scratch/$type.csv'
		REPLACE INTO TABLE \`codelist\` 
		FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"' LINES TERMINATED BY '\\r\\n'
		(\`value\`, \`code\`)
		SET \`type\`='$type';
SQL
	)
done

echo $SQL;
