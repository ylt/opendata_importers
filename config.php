<?php
/**
 * Created by PhpStorm.
 * User: joe
 * Date: 18/02/17
 * Time: 05:06
 */


class Config {
    /**
     * @var PDO
     */
    public static $database = null;

    public static function init() {
        self::$database = new PDO('mysql:host=localhost;dbname=OS;', 'root', 'root');
    }


}

Config::init();