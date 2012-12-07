<?php
/**
 * \php\database.php
 *
 * This file makes necessary initialize for Doctrine DBAL library.
 *
 * @package     HomeAI
 * @subpackage  Core
 * @category    Database
 *
 * @date        $Date$
 * @author      $Author$
 * @revision    $Rev$
 */
use Doctrine\Common\ClassLoader;

defined('HOMEAI_INIT') OR die('No direct access allowed.');

// Require doctrine class loader
require_once PATH_BASE .'libs/DoctrineDBAL/Doctrine/Common/ClassLoader.php';

// Register doctrine class loader
$classLoader = new ClassLoader('Doctrine', PATH_BASE .'libs/doctrine-dbal/');
$classLoader->register();