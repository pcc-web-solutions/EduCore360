<?php
if (session_status() === PHP_SESSION_NONE) { session_start(); }
require 'vendor/autoload.php';

use Safaricom\Mpesa\Mpesa;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PhpOffice\PhpWord\PhpWord;
use PhpOffice\PhpWord\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;
use Symfony\Component\Yaml\Yaml;
use Dotenv\Dotenv;

$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

$key = $_ENV['ENCRYPTION_KEY'];
$iv = $_ENV['ENCRYPTION_IV'];

define('LOCK_AFTER', 5 * 60);
define('LOGOUT_AFTER', 10 * 60);

$sodiumKey = base64_decode($key);
if (strlen($sodiumKey) !== SODIUM_CRYPTO_SECRETBOX_KEYBYTES) {
    $err = "Invalid encryption key size.";
}

class FileHandler {
    public $uploadDir = "upload";
    public function encryptFile($fileName): string {
        global $key;
        $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length('AES-256-CBC'));
        $cipherText = openssl_encrypt($fileName, 'AES-256-CBC', $key, 0, $iv);
        $encrypted = base64_encode($iv . $cipherText);
        return str_replace(['+', '/', '='], ['-', '_', ''], $encrypted);
    }
    public function decryptFile($encryptedName): bool|string {
        global $key;
        $clean = str_replace(['-', '_'], ['+', '/'], $encryptedName);
        $decoded = base64_decode($clean);
        $ivLength = openssl_cipher_iv_length('AES-256-CBC');
        $iv = substr($decoded, 0, $ivLength);
        $cipherText = substr($decoded, $ivLength);
        return openssl_decrypt($cipherText, 'AES-256-CBC', $key, 0, $iv);
    }
    public function storeRoute(string $filePath): string {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        if (!isset($_SESSION['route_tokens'])) {
            $_SESSION['route_tokens'] = [];
        }
        $token = bin2hex(random_bytes(8));
        $_SESSION['route_tokens'][$token] = $filePath;
        return $token;
    }
    public function getRoute(string $token): ?string {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }
        return $_SESSION['route_tokens'][$token] ?? null;
    }
    public function clearRoute(string $token): void {
        if (isset($_SESSION['route_tokens'][$token])) {
            unset($_SESSION['route_tokens'][$token]);
        }
    }
    public function replicateModule($sourceDir, $opt, $destinationDir, $npt) {
        if (!is_dir($destinationDir)) {
            mkdir($destinationDir, 0777, true);
            $this->setFullPermissions($destinationDir);
        }
        foreach (scandir($sourceDir) as $file) {
            if (strpos($file, $opt) === 0 && is_file("$sourceDir/$file")) {
                $newName = $npt . substr($file, strlen($opt));
                $target = "$destinationDir/$newName";
                if (copy("$sourceDir/$file", $target)) {
                    $this->setFullPermissions($target);
                }
            }
        }
    }
    public function upload($file): array {
        if ($file['error'] !== UPLOAD_ERR_OK) {
            return ["status" => false, "message" => $this->getUploadErrorMessage($file['error'])];
        }

        if (!is_uploaded_file($file['tmp_name'])) {
            return ["status" => false, "message" => "The uploaded file is not valid."];
        }

        try {
            $this->getFolderByType(mime_content_type($file['tmp_name']));
            $uploadedFilePath = $this->uploadFile($file, $this->uploadDir);
            return ["status" => true, "path" => $uploadedFilePath];
        } catch (Exception $e) {
            return ["status" => false, "message" => $e->getMessage()];
        }
    }
    private function uploadFile($file, $path): string {
        if ($file['error'] !== UPLOAD_ERR_OK) {
            throw new Exception($this->getUploadErrorMessage($file['error']));
        }

        $fileType = mime_content_type($file['tmp_name']);
        $fileSize = $file['size'];

        if (!$this->isValidFileType($fileType)) throw new Exception("Invalid file type.");
        if (!$this->isValidFileSize($fileSize)) throw new Exception("File size exceeds limit.");

        $newFileName = $this->renameFile($file['name']);
        $fileFolder = $this->getFolderByType($fileType);
        $folderPath = $path . "/" . $fileFolder;

        if (!is_dir($folderPath)) {
            mkdir($folderPath, 0777, true);
            $this->setFullPermissions($folderPath);
        }

        $filePath = $folderPath . "/" . $newFileName;
        if (!move_uploaded_file($file['tmp_name'], $filePath)) {
            throw new Exception("Failed to save file.");
        }
        $this->setFullPermissions($filePath);

        return $filePath;
    }
    private function setFullPermissions(string $target): void {
        if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
            @exec('icacls "' . $target . '" /grant IUSR:(F) /grant IIS_IUSRS:(F) /T /C', $output, $code);
        } else {
            @chmod($target, 0777);
        }
    }
    private function isValidFileType($fileType): bool {
        $allowedTypes = [
            'application/pdf', 'application/msword', 'application/vnd.ms-excel',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'image/jpeg', 'image/png', 'text/plain'
        ];
        return in_array($fileType, $allowedTypes);
    }
    private function isValidFileSize($fileSize): bool {
        return $fileSize <= 5 * 1024 * 1024; // 5 MB
    }
    private function renameFile($originalName): string {
        return uniqid() . '_' . time() . '.' . pathinfo($originalName, PATHINFO_EXTENSION);
    }
    private function getFolderByType($fileType): string {
        $folders = [
            'application/pdf' => 'pdf',
            'application/msword' => 'word',
            'application/vnd.ms-excel' => 'excel',
            'image/jpeg' => 'jpeg',
            'image/png' => 'png',
            'text/plain' => 'text'
        ];
        return $folders[$fileType] ?? 'others';
    }
    private function getUploadErrorMessage($errorCode): string {
        return match ($errorCode) {
            UPLOAD_ERR_INI_SIZE => "The file exceeds the upload_max_filesize directive in php.ini",
            UPLOAD_ERR_FORM_SIZE => "The file exceeds the MAX_FILE_SIZE directive specified in the HTML form.",
            UPLOAD_ERR_PARTIAL => "The file was only partially uploaded.",
            UPLOAD_ERR_NO_FILE => "No file was uploaded.",
            UPLOAD_ERR_NO_TMP_DIR => "Missing a temporary folder.",
            UPLOAD_ERR_CANT_WRITE => "Failed to write file to disk.",
            UPLOAD_ERR_EXTENSION => "A PHP extension stopped the file upload.",
            default => "Unknown upload error."
        };
    }
}
class DataHandler extends FileHandler {
    private string $filePath;
    private array $data = [];

    /**
     * Construct optionally with a file path or an initial array.
     * If a valid JSON file path is provided, it will auto-load data.
     */
    public function __construct(string $filePath = '', array $initialData = []) {
        $this->filePath = $filePath;
        if (!empty($initialData)) {
            $this->data = $initialData;
            if ($filePath !== '') $this->saveData();
        } elseif ($filePath !== '') {
            $this->loadData();
        }
    }

    /** ---------- JSON FILE OPERATIONS ---------- */
    private function loadData(): void {
        if ($this->filePath && file_exists($this->filePath)) {
            $json = file_get_contents($this->filePath);
            $decoded = json_decode($json, true);
            $this->data = is_array($decoded) ? $decoded : [];
        } else {
            $this->data = [];
        }
    }

    private function saveData(): void {
        if ($this->filePath) {
            file_put_contents($this->filePath, json_encode($this->data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
        }
    }

    /** Load or set new data manually */
    public function set(array $data): void { $this->data = $data; }
    public function get(): array { return $this->data; }

    /** ---------- CRUD-LIKE SECTION OPERATIONS ---------- */
    public function addItem(string $section, array $item): void {
        $this->ensureSectionExists($section);
        $this->data[$section][] = $item;
        $this->saveData();
    }

    public function updateItemByIndex(string $section, int $index, array $newItem): void {
        if (!isset($this->data[$section][$index])) {
            throw new Exception("Index out of bounds or section not found");
        }
        $this->data[$section][$index] = $newItem;
        $this->saveData();
    }

    public function deleteItemByIndex(string $section, int $index): void {
        if (!isset($this->data[$section][$index])) {
            throw new Exception("Index out of bounds or section not found");
        }
        array_splice($this->data[$section], $index, 1);
        $this->saveData();
    }

    public function findItemByKeyValue(string $section, string $key, $value): mixed {
        if (!isset($this->data[$section])) return null;
        foreach ($this->data[$section] as $item) {
            if (isset($item[$key]) && $item[$key] === $value) {
                return $item;
            }
        }
        return null;
    }

    public function updateItemByKeyValue(string $section, string $key, $value, array $newItem): bool {
        if (!isset($this->data[$section])) return false;
        foreach ($this->data[$section] as $index => $item) {
            if (isset($item[$key]) && $item[$key] === $value) {
                $this->data[$section][$index] = $newItem;
                $this->saveData();
                return true;
            }
        }
        return false;
    }

    public function deleteItemByKeyValue(string $section, string $key, $value): bool {
        if (!isset($this->data[$section])) return false;
        foreach ($this->data[$section] as $index => $item) {
            if (isset($item[$key]) && $item[$key] === $value) {
                array_splice($this->data[$section], $index, 1);
                $this->saveData();
                return true;
            }
        }
        return false;
    }

    public function appendDataToItem(string $section, int $index, array $newData): void {
        if (!isset($this->data[$section][$index]) || !is_array($this->data[$section][$index])) {
            throw new Exception("Index out of bounds or item is not an array");
        }
        $this->data[$section][$index] = array_merge($this->data[$section][$index], $newData);
        $this->saveData();
    }

    public function getAllData(?string $section = null): mixed {
        return $section ? ($this->data[$section] ?? []) : $this->data;
    }

    public function clearAllData(?string $section = null): void {
        if ($section) {
            $this->data[$section] = [];
        } else {
            $this->data = [];
        }
        $this->saveData();
    }
    public function sortDataByKey(string $section, string $key, string $order = 'ASC'): void {
        if (!isset($this->data[$section])) return;
        usort($this->data[$section], function ($a, $b) use ($key, $order): int {
            if (!isset($a[$key]) || !isset($b[$key])) return 0;
            return $order === 'ASC' ? ($a[$key] <=> $b[$key]) : ($b[$key] <=> $a[$key]);
        });
        $this->saveData();
    }
    public function filterDataByKeyValue(string $section, string $key, $value): array {
        if (!isset($this->data[$section])) return [];
        return array_values(array_filter($this->data[$section], fn($item) => isset($item[$key]) && $item[$key] === $value));
    }
    private function ensureSectionExists(string $section): void {
        if (!isset($this->data[$section]) || !is_array($this->data[$section])) {
            $this->data[$section] = [];
        }
    }
    /** ---------- DATA MANAGEMENT UTILITIES ---------- */
    public function decryptData($jsonInput, $sodiumKey = null) {
        if (!$sodiumKey) return $jsonInput;
        $data = json_decode($jsonInput, true);
        if (!isset($data['nonce'], $data['cipher'])) throw new Exception("Invalid JSON format for encrypted data.");
        $nonce = base64_decode($data['nonce'], true);
        $cipher = base64_decode($data['cipher'], true);
        if ($nonce === false || $cipher === false) throw new Exception("Base64 decoding failed.");
        $decrypted = sodium_crypto_secretbox_open($cipher, $nonce, $sodiumKey);
        if ($decrypted === false) throw new Exception("Decryption failed. Invalid key or corrupted data.");
        return $decrypted;
    }
    public function safeData($data): string {
        return htmlspecialchars($data ?? '', ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
    }
    public function cleanData($data, $allowFilePath = false): string|array {
        if (is_array($data)) {
            return array_map(fn($v) => $this->cleanData($v, $allowFilePath), $data);
        }

        $data = trim((string)$data);
        $data = mb_convert_encoding($data, 'UTF-8', 'UTF-8');
        $data = preg_replace('/[\x00-\x1F\x7F]/u', '', $data); // remove control chars

        if ($allowFilePath) {
            $data = preg_replace('/[^a-zA-Z0-9\/_.\-\s]/u', '', $data);
            $data = str_replace('..', '', $data);
        } else {
            $data = strip_tags($data);
        }
        return $data;
    }
    /** Generic array filtering with AND/OR support */
    public function filter(array $dataSets, array $filters, ?string $targetSet = null, string $logic = 'AND'): array {
        $logic = strtoupper($logic);
        $apply = function ($items, $filters) use ($logic) {
            return array_values(array_filter($items, function ($item) use ($filters, $logic) {
                $results = [];
                foreach ($filters as $key => $value) {
                    $match = isset($item[$key]) && $item[$key] == $value;
                    $results[] = $match;
                }
                return $logic === 'AND' ? !in_array(false, $results, true) : in_array(true, $results, true);
            }));
        };
        if ($targetSet !== null) {
            if (!isset($dataSets[$targetSet]) || !is_array($dataSets[$targetSet])) return [];
            return $apply($dataSets[$targetSet], $filters);
        }
        $output = [];
        foreach ($dataSets as $section => $items) {
            if (is_array($items)) $output[$section] = $apply($items, $filters);
        }
        return $output;
    }
    public function paginate(int $page = 1, int $perPage = 10): array {
        $total = count($this->data);
        $offset = max(0, ($page - 1) * $perPage);
        $items = array_slice($this->data, $offset, $perPage);
        return [
            'page' => $page,
            'per_page' => $perPage,
            'total' => $total,
            'last_page' => ceil($total / $perPage),
            'data' => $items,
        ];
    }
    public function groupBy(string $key): array {
        $result = [];
        foreach ($this->data as $item) {
            $groupKey = $item[$key] ?? null;
            $result[$groupKey][] = $item;
        }
        return $result;
    }
    public function pluck(string $key): array {
        return array_map(fn($item) => $item[$key] ?? null, $this->data);
    }
}
class UserAccessManager {
    private string $filePath;
    private array $data = [];
    private bool $loaded = false;
    private static ?array $cache = null;
    private static ?string $cacheFilePath = null;

    public function __construct(string $filePath) {
        $this->filePath = $filePath;
        $this->load();
    }

    private function load(): void {
        if (self::$cache !== null && self::$cacheFilePath === $this->filePath) {
            $this->data = self::$cache;
            $this->loaded = true;
            return;
        }

        if (!file_exists($this->filePath)) {
            $this->data = [];
            $this->loaded = true;
            self::$cache = $this->data;
            self::$cacheFilePath = $this->filePath;
            return;
        }

        $json = @file_get_contents($this->filePath);
        if ($json === false) {
            $this->data = [];
            $this->loaded = true;
            self::$cache = $this->data;
            self::$cacheFilePath = $this->filePath;
            return;
        }

        $decoded = json_decode($json, true);
        $this->data = is_array($decoded) ? $decoded : [];
        $this->loaded = true;

        self::$cache = $this->data;
        self::$cacheFilePath = $this->filePath;
    }
    public function get(): array {
        if (!$this->loaded) $this->load();
        return $this->data;
    }
    public function getSwitchableProfiles(string $currentProfile, ?string $userId = null): array {
        $data = $this->get();
        $rules = $data['profile_switch'] ?? [];
        $roles = $data['user_roles'] ?? [];

        // select rules matching current profile
        $selected = array_values(array_filter($rules, function($r) use ($currentProfile) {
            return isset($r['profile']) && $r['profile'] === $currentProfile;
        }));

        // if userId provided, limit to allowed profiles derived from user_permission
        if ($userId !== null) {
            $allowed = $this->getUserAllowedProfiles($userId);
            $selected = array_values(array_filter($selected, function($r) use ($allowed) {
                return in_array($r['can_switch_to'], $allowed, true);
            }));
        }

        // enrich with role meta
        foreach ($selected as &$row) {
            $match = array_filter($roles, function($role) use ($row) {
                return isset($role['role_id']) && $role['role_id'] === $row['can_switch_to'];
            });
            if (!empty($match)) {
                $role = array_values($match)[0];
                $row['default_page'] = $role['default_page'] ?? '';
                $row['is_available'] = $role['is_available'] ?? false;
                $row['status'] = $role['status'] ?? '';
            } else {
                $row['default_page'] = '';
                $row['is_available'] = false;
                $row['status'] = '';
            }
        }
        return $selected;
    }
    public function getUserAllowedProfiles(string $userId): array {
        $data = $this->get();
        $perms = $data['user_permission'] ?? [];
        $allowed = [];

        foreach ($perms as $p) {
            if (!isset($p['user']) || $p['user'] !== $userId) continue;
            if (empty($p['is_allowed'])) continue;
            if (!isset($p['permission'])) continue;

            if (preg_match('/access_(.*?)_portal/', $p['permission'], $m)) {
                $allowed[] = $m[1];
            }
        }
        return array_values(array_unique($allowed));
    }
    public function getProfilePermissions(string $profile): array {
        $data = $this->get();
        $keys = $data['permission_keys'] ?? [];
        return array_values(array_filter($keys, function($k) use ($profile) {
            return isset($k['profile']) && $k['profile'] === $profile;
        }));
    }
    public static function clearCache(): void {
        self::$cache = null;
        self::$cacheFilePath = null;
    }
}
class DBController extends DataHandler {
    private static $instance = null;
	public $pdo;
    private $user_agent;
    private $user_ip;
    private $backupDir = __DIR__ . "/db/backup/";
    private $logFile = __DIR__ . "/db/user.log";
    private $loggableOps = ['INSERT', 'UPDATE', 'DELETE', 'REPLACE', 'ALTER', 'DROP', 'CREATE', 'TRUNCATE'];
    public function __construct(){
        try {
            $this->initializeSystem();
        } catch (PDOException $e) {
            $this->log($e->getMessage());
            throw new Exception("Unable to initialize system");
        }
	}
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new DbController();
        }
        return self::$instance;
    }
    private function database(){
        $params = ["connection"=>$_ENV['DB_CONNECTION'],"host"=>$_ENV['DB_HOST'].":".$_ENV['DB_PORT']?? 3306,"user"=>$_ENV['DB_USERNAME'],"password"=>$_ENV['DB_PASSWORD'],"name"=>$_ENV['DB_DATABASE']];
        return $params;
    }
    private function initializeSystem(){
        try {
            $this->user_agent = $_SERVER['HTTP_USER_AGENT'];
            $this->user_ip = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
            $this->connect();
            $this->pdo->exec("SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY',''))");
        } catch (Exception $e){
            throw new Exception($e->getMessage());
        }
    }
    private function connect(){
        try {
            $this->pdo = new PDO(
                "".$this->database()['connection'].":host=".$this->database()['host'].";dbname=".$this->database()['name'].";",
                $this->database()['user'],
                $this->database()['password'],
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false
                ]
        );
        } catch (PDOException $e) {
            $this->log($e->getMessage());
            throw new Exception("Database connection failed");
        }
    }
    public function log($message) {
        $userData = $this->UserAccessData();
        file_put_contents($this->logFile, "[".$userData['date']."] [".$userData['time']."] [".$userData['ip']."] [".$userData['is_bot']."] [".$userData['platform']."] [".$userData['browser']."] [$message]" . PHP_EOL, FILE_APPEND);
    }
    public function updateCharsetCollation($charset = 'utf8mb4', $collation = 'utf8mb4_general_ci') {
        try {
            $db = $this->database()['name'];
            $tables = $this->pdo->query("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '{$db}' AND TABLE_TYPE = 'BASE TABLE' ")->fetchAll(PDO::FETCH_COLUMN);
    
            foreach ($tables as $table) {
                $sql = "ALTER TABLE `$table` CONVERT TO CHARACTER SET $charset COLLATE $collation";
                $this->pdo->exec($sql);
                $this->log("Converted table `$table` to CHARSET $charset and COLLATION $collation");
            }
            $this->log("All tables in `$db` updated to $charset / $collation");
        } catch (PDOException $e) {
            $this->log("Charset/Collation update failed: " . $e->getMessage());
            throw $e;
        }
    }
    private function getPlatform() {
        $os_platform = "Unknown";

        $os_array = [
            '/windows nt 11.0/i'    => 'Windows 11',
            '/windows nt 10.0/i'    => 'Windows 10',
            '/windows nt 6.3/i'     => 'Windows 8.1',
            '/windows nt 6.2/i'     => 'Windows 8',
            '/windows nt 6.1/i'     => 'Windows 7',
            '/windows nt 6.0/i'     => 'Windows Vista',
            '/windows nt 5.2/i'     => 'Windows Server 2003/XP x64',
            '/windows nt 5.1/i'     => 'Windows XP',
            '/windows xp/i'         => 'Windows XP',
            '/windows nt 5.0/i'     => 'Windows 2000',
            '/windows me/i'         => 'Windows ME',
            '/win98/i'              => 'Windows 98',
            '/win95/i'              => 'Windows 95',
            '/win16/i'              => 'Windows 3.11',
            '/macintosh|mac os x/i' => 'Mac OS X',
            '/mac_powerpc/i'        => 'Mac OS 9',
            '/android/i'            => 'Android',
            '/linux/i'              => 'Linux',
            '/ubuntu/i'             => 'Ubuntu',
            '/iphone/i'             => 'iPhone',
            '/ipod/i'               => 'iPod',
            '/ipad/i'               => 'iPad',
            '/blackberry/i'         => 'BlackBerry',
            '/webos/i'              => 'Mobile',
            '/cros/i'               => 'Chrome OS'
        ];

        foreach ($os_array as $regex => $value) { 
            if (preg_match($regex, $this->user_agent)) {
                $os_platform = $value;
                break;
            }
        }   
        return $os_platform;
    }
    private function getBrowser() {
        $browser = "Unknown Browser";

        $browser_array = [
            '/Edg/i'        => 'Microsoft Edge',
            '/Brave/i'      => 'Brave Browser',
            '/Vivaldi/i'    => 'Vivaldi',
            '/chrome/i'     => 'Google Chrome',
            '/safari/i'     => 'Safari',
            '/firefox/i'    => 'Mozilla Firefox',
            '/msie/i'       => 'Internet Explorer',
            '/opera/i'      => 'Opera',
            '/netscape/i'   => 'Netscape',
            '/maxthon/i'    => 'Maxthon',
            '/konqueror/i'  => 'Konqueror',
            '/mobile/i'     => 'Handheld Browser',
            '/CriOS/i'      => 'Chrome for iOS',
            '/FxiOS/i'      => 'Firefox for iOS',
            '/SamsungBrowser/i' => 'Samsung Internet'
        ];

        foreach ($browser_array as $regex => $value) { 
            if (preg_match($regex, $this->user_agent)) {
                $browser = $value;
                break;
            }
        }
        return $browser;
    }
    private function isBot($ua) {
        return preg_match('/bot|crawl|slurp|spider/i', $ua) ? 'Yes' : 'No';
    }
    private function UserAccessData(){
        $data = [];
        $data['date']  = $this->todaysDate();
        $data['time']  = $this->currentTime();
        $data['ip']         = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
        $data['user_agent'] = $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown';
        $data['method']     = $_SERVER['REQUEST_METHOD'] ?? 'Unknown';
        $data['uri']        = $_SERVER['REQUEST_URI'] ?? '';
        $data['referrer']   = $_SERVER['HTTP_REFERER'] ?? '';
        $data['https']      = isset($_SERVER['HTTPS']) ? 'Yes' : 'No';
        $data['session_id'] = session_id();
        $data['userid']    = $_SESSION['userid'] ?? 'Guest';
        $data['is_bot']     = $this->isBot($data['user_agent']);
        $data['platform']   = $this->getPlatform();
        $data['browser']    = $this->getBrowser();
        return $data;
    }
    public function buildWhereClauses($conditions): string{
        $whereClauses = [];
        foreach($conditions AS $column => $value){
            $whereClauses[] = "$column = ?";
        }
        return " WHERE " . implode(separator: " AND ", array: $whereClauses);
    }
    public function buildParams($conditions){
        $params = [];
        foreach($conditions AS $column => $value){
            $params[] = $value;
        }
        return $params;
    }
	public function readData($query, $params) {
		try {
            $stmt = $this->pdo->prepare(query: $query);
            $stmt->execute(params: $params);
            $resultset = $stmt->fetch(mode: PDO::FETCH_ASSOC);
			return $resultset;
        } catch (PDOException $e) {
            $this->log("Query Error: " . $e->getMessage() . " | SQL: " . $query);
            throw new Exception("Failed to retrieve data.");
        }
	}
	public function readData_array($query, $params){
        try {
            $stmt = $this->pdo->prepare(query: $query);
            $stmt->execute(params: $params);
            $resultset = $stmt->fetchAll(mode: PDO::FETCH_ASSOC);
            if(!empty($resultset))
			    return $resultset;
        } catch (PDOException $e) {
            $this->log("Query Error: " . $e->getMessage() . " | SQL: " . $query);
            throw new Exception("Failed to retrieve data.");
        }
	}
	public function numRows($query, $params) {
        try {
            $stmt = $this->pdo->prepare(query: $query);
            $stmt->execute(params: $params);
            return $stmt->fetchColumn();
        } catch (PDOException $e) {
            $this->log("Query Error: " . $e->getMessage() . " | SQL: " . $query);
            throw new Exception("Row Count Failed.");
        }
	}
	public function executeInsert($query, $params): int|string {
        $this->pdo->beginTransaction();
        try {
            $stmt = $this->pdo->prepare(query: $query);
            $stmt->execute(params: $params);
            $lastInsertId = $this->pdo->lastInsertId();
            $this->pdo->commit();
            
            $operation = strtoupper(strtok(trim($query), " "));
            if (in_array($operation, $this->loggableOps)) {
                $this->log("[$operation] SQL: " . $query . " | Params: " . json_encode($params));
            }

            return $lastInsertId;
        } catch (PDOException $e) {
            $this->pdo->rollBack();
            $this->log("Query Error: " . $e->getMessage() . " | SQL: " . $query);
            throw new Exception("Unable to insert record.");
        }	
	}
	public function executeUpdate($query, $params): bool{
        $this->pdo->beginTransaction();
		try {
            $stmt = $this->pdo->prepare(query: $query);
            $stmt->execute(params: $params);
            $this->pdo->commit();
            
            $operation = strtoupper(strtok(trim($query), " "));
            if (in_array($operation, $this->loggableOps)) {
                $this->log("[$operation] SQL: " . $query . " | Params: " . json_encode($params));
            }
            
			return $stmt->rowCount();
        } catch (PDOException $e) {
            $this->pdo->rollBack();
            $this->log("Query Error: " . $e->getMessage() . " | SQL: " . $query);
            throw new Exception("Updation Failed.");
        }
	}
	public function executeDelete($query, $params): bool{
        $this->pdo->beginTransaction();
        try {
            $stmt = $this->pdo->prepare(query: $query);
            $stmt->execute(params: $params);
            $this->pdo->commit();
            
            $operation = strtoupper(strtok(trim($query), " "));
            if (in_array($operation, $this->loggableOps)) {
                $this->log("[$operation] SQL: " . $query . " | Params: " . json_encode($params));
            }
            
            return $stmt->rowCount();
        } catch (PDOException $e) {
            $this->pdo->rollBack();
            $this->log("Delete Error: " . $e->getMessage() . " | SQL: " . $query);
            throw new Exception("Deletion Failed.");
        }
	}
    private function safeQuote($value) {
        return $value === null ? 'NULL' : $this->pdo->quote($value, PDO::PARAM_STR);
    }
    private function backupCSV() {
        $tables = $this->pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
        $zip = new ZipArchive();
        $zipFilename = $this->backupDir . $this->database()['name'] . '_backup_on_' . date('Y-m-d_H-i-s') . '.zip';
    
        if ($zip->open($zipFilename, ZipArchive::CREATE) !== true) {
            throw new Exception("Could not create ZIP file.");
        }
        $zipfiles = [];
        foreach ($tables as $table) {
            $filename = $this->backupDir . "$table.csv";
            $handle = fopen($filename, 'w');
    
            $rows = $this->pdo->query("SELECT * FROM `$table`")->fetchAll(PDO::FETCH_ASSOC);
            if (!empty($rows)) {
                fputcsv($handle, array_keys($rows[0]), ",", '"', "\\");
                foreach ($rows as $row) {
                    fputcsv($handle, $row, ",", '"', "\\");
                }
            }
            fclose($handle);
            $zip->addFile($filename, basename($filename));
            $zipfiles[] = $filename;
        }
        $zip->close();
        foreach ($zipfiles as $zipfile) { unlink($zipfile); }

        return $this->downloadFile($zipFilename, 'application/zip');
    }
    private function backupExcel() {
        $spreadsheet = new Spreadsheet();
        $tables = $this->pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);

        foreach ($tables as $index => $table) {
            $sheet = ($index == 0) ? $spreadsheet->getActiveSheet() : $spreadsheet->createSheet();
            $sheet->setTitle($table);
            $rows = $this->pdo->query("SELECT * FROM `$table`")->fetchAll(PDO::FETCH_ASSOC);
            if (!empty($rows)) {
                $columnNames = array_keys($rows[0]);
                $sheet->fromArray([$columnNames], null, 'A1');
                $sheet->fromArray($rows, null, 'A2');
            }
        }
        $filename = $this->backupDir . $this->database()['name'] . '_backup_on_' . date('Y-m-d_H-i-s') . '.xlsx';
        $writer = new Xlsx($spreadsheet);
        $writer->save($filename);
        $this->downloadFile($filename, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    }
    private function backupJSON() {
        $filename = $this->backupDir . $this->database()['name'] . '_backup_on_' . date('Y-m-d_H-i-s') . ".json";
        $tables = $this->pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
        $data = [];
        foreach ($tables as $table) {
            $data[$table] = $this->pdo->query("SELECT * FROM `$table`")->fetchAll(PDO::FETCH_ASSOC);
        }
        file_put_contents($filename, json_encode($data, JSON_PRETTY_PRINT));
        return $this->downloadFile($filename, 'application/json');
    }
    private function backupXML() {
        $filename = $this->backupDir . $this->database()['name'] . '_backup_on_' . date('Y-m-d_H-i-s') . ".xml";
        $xml = new SimpleXMLElement('<database/>'); // Root element

        $tables = $this->pdo->query("SHOW FULL TABLES")->fetchAll(PDO::FETCH_NUM);
        
        foreach ($tables as $tableData) {
            $table = $tableData[0];
            $tableXML = $xml->addChild($table);

            $stmt = $this->pdo->query("SELECT * FROM `$table`");
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

            foreach ($rows as $row) {
                $rowXML = $tableXML->addChild('row');
                foreach ($row as $column => $value) {
                    $cleanValue = htmlspecialchars((string)$value, ENT_XML1, 'UTF-8');
                    $rowXML->addChild($column, $cleanValue);
                }
            }
        }
        $dom = new DOMDocument('1.0', 'UTF-8');
        $dom->preserveWhiteSpace = false;
        $dom->formatOutput = true;
        $dom->loadXML($xml->asXML());
        file_put_contents($filename, $dom->saveXML());
        return $this->downloadFile($filename, 'application/xml');
    }
    private function backupYAML() {
        $filename = $this->backupDir . $this->database()['name'] . '_backup_on_' . date('Y-m-d_H-i-s') . ".x-yaml";
        if (!class_exists('Symfony\Component\Yaml\Yaml')) {
            throw new Exception("Symfony YAML package is not installed. Run 'composer require symfony/yaml'.");
        }
        $tables = $this->pdo->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
        $data = [];
    
        foreach ($tables as $table) {
            $data[$table] = $this->pdo->query("SELECT * FROM `$table`")->fetchAll(PDO::FETCH_ASSOC);
        }
        file_put_contents($filename, Yaml::dump($data, 2, 4));
        return $this->downloadFile($filename, 'application/x-yaml');   
    }
	private function backupSQL(){
        $filename = $this->backupDir . $this->database()['name'] . '_backup_on_' . date('Y-m-d_H-i-s') . '.sql';
        $sqlScript = "";
        $sqlScript .= "-- Database Backup: ".$this->database()['name']."\n";
        $sqlScript .= "-- Generated on: " . date('Y-m-d H:i:s') . "\n\n";
        $sqlScript .= "SET FOREIGN_KEY_CHECKS=0;\n\n";
        
        $tables = [];
        $stmt = $this->pdo->query("SHOW FULL TABLES WHERE Table_type = 'BASE TABLE'");
        while ($row = $stmt->fetch(mode: PDO::FETCH_NUM)) {
            $tables[] = $row[0];
        }

        foreach ($tables as $table) {
            $sqlScript .= "-- Structure for table `$table`\n";
            $stmt = $this->pdo->query("SHOW CREATE TABLE `$table`");
            $row = $stmt->fetch();
            $sqlScript .= $row['Create Table'] . ";\n\n";
    
            $stmt = $this->pdo->query("DESCRIBE `$table`");
            $columns = [];
            while ($col = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $columns[] = "`" . $col['Field'] . "`";
            }
            
            $stmt = $this->pdo->query("SELECT * FROM `$table`");
            if ($stmt->rowCount() > 0) {
                $sqlScript .= "-- Data for table `$table`\n";
                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    $values = array_map([$this, 'safeQuote'], array_values($row));
                    $sqlScript .= "INSERT INTO `$table` (" . implode(", ", $columns) . ") VALUES (" . implode(", ", $values) . ");\n";
                }
                $sqlScript .= "\n";
            }
        }
        
        $sqlScript .= "-- Backup Views\n";
        $stmt = $this->pdo->query("SHOW FULL TABLES WHERE Table_type = 'VIEW'");
        while ($row = $stmt->fetch(PDO::FETCH_NUM)) {
            $viewName = $row[0];
            $stmtView = $this->pdo->query("SHOW CREATE VIEW `$viewName`");
            $rowView = $stmtView->fetch();
            $sqlScript .= "DROP VIEW IF EXISTS `$viewName`;\n";
            $sqlScript .= $rowView['Create View'] . ";\n\n";
        }

        $sqlScript .= "-- Backup Stored Procedures & Functions\n";
        $stmt = $this->pdo->query("SHOW PROCEDURE STATUS WHERE Db = '".$this->database()['name']."'");
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $procedureName = $row['Name'];
            $stmtProc = $this->pdo->query("SHOW CREATE PROCEDURE `$procedureName`");
            $rowProc = $stmtProc->fetch();
            $sqlScript .= "DROP PROCEDURE IF EXISTS `$procedureName`;\n";
            $sqlScript .= $rowProc['Create Procedure'] . ";\n\n";
        }

        $stmt = $this->pdo->query("SHOW FUNCTION STATUS WHERE Db = '".$this->database()['name']."'");
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $functionName = $row['Name'];
            $stmtFunc = $this->pdo->query("SHOW CREATE FUNCTION `$functionName`");
            $rowFunc = $stmtFunc->fetch();
            $sqlScript .= "DROP FUNCTION IF EXISTS `$functionName`;\n";
            $sqlScript .= $rowFunc['Create Function'] . ";\n\n";
        }

        $sqlScript .= "-- Backup Triggers\n";
        $stmt = $this->pdo->query("SHOW TRIGGERS");
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $triggerName = $row['Trigger'];
            $sqlScript .= "DROP TRIGGER IF EXISTS `$triggerName`;\n";
            $sqlScript .= "DELIMITER $$\n" . $row['Statement'] . " $$\nDELIMITER ;\n\n";
        }

        $sqlScript .= "-- Backup Events\n";
        $stmt = $this->pdo->query("SHOW EVENTS");
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $eventName = $row['Name'];
            $stmtEvent = $this->pdo->query("SHOW CREATE EVENT `$eventName`");
            $rowEvent = $stmtEvent->fetch();
            $sqlScript .= "DROP EVENT IF EXISTS `$eventName`;\n";
            $sqlScript .= $rowEvent['Create Event'] . ";\n\n";
        }

        $sqlScript .= "SET FOREIGN_KEY_CHECKS=1;\n\n";
        $sqlScript .= "SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY',''));";
        file_put_contents($filename, $sqlScript);
        $this->downloadFile($filename, 'application/sql');
    }
    private function backupSqlGzip() {
        $timestamp = date("Y-m-d_H-i-s");
        $dbName = $this->database()['name'];
        $sqlFile = $this->backupDir . $dbName . "_backup_" . $timestamp . ".sql";
        $gzFile  = $sqlFile . ".gz";
        $mysqldumpPath = "\"C:\\Program Files\\MySQL\\MySQL Server 9.1\\bin\\mysqldump.exe\"";
        $cnfPath = __DIR__ . "\\db\\.my.cnf";
        $cnfArg = escapeshellarg($cnfPath);
        $logFile = escapeshellarg($this->logFile);
        $sqlFileEscaped = escapeshellarg($sqlFile);
    
        $command = "{$mysqldumpPath} --defaults-extra-file={$cnfArg} --databases {$dbName} " .
                   "--routines --events --triggers --add-drop-table --log-error={$logFile} > {$sqlFileEscaped}";
    
        $output = [];
        $returnVar = 0;
        exec($command, $output, $returnVar);
    
        if ($returnVar !== 0 || !file_exists($sqlFile)) {
            file_put_contents(__DIR__ . "/backup_debug.txt", implode("\n", $output));
            throw new Exception("Backup failed! Error: " . implode("\n", $output) . "\nCheck log: {$this->logFile}");
        }
        $sqlContent = file_get_contents($sqlFile);
        $gzContent = gzencode($sqlContent, 9);
        file_put_contents($gzFile, $gzContent);
        unlink($sqlFile);
        $this->downloadFile($gzFile, 'application/gzip');
    }
    private function downloadFile($filename, $mimeType = 'application/octet-stream') {
        if (!file_exists($filename)) {
            throw new Exception("File does not exist: $filename");
        }
        $fileSize = filesize($filename);
        header("Content-Description: File Transfer");
        header("Content-Type: $mimeType");
        header("Content-Disposition: attachment; filename=\"" . basename($filename) . "\"");
        header("Content-Length: $fileSize");
        readfile($filename);
        exit;
    }
    public function export($format) {
        switch (strtolower($format)) {
            case 'sql': return $this->backupSQL();
            case 'sql.gz': return $this->backupSqlGzip();
            case 'csv': return $this->backupCSV();
            case 'json': return $this->backupJSON();
            case 'xml': return $this->backupXML();
            case 'yaml': return $this->backupYAML();
            case 'xlsx': return $this->backupExcel();
            default: return "Unsupported format!";
        }
    }
	public function todaysDate(): string{
		$date = date(format: 'Y-m-d');
		$today = new DateTime(datetime: $date);
		$today->modify(modifier: '+0 days');
		$today = $today->format(format: 'Y-m-d');
		return $today;
	}
    public function currentTime(): string{
        return Date(format: 'h:i:s');
    }
}
class User extends DBController {
    private $username;
    private $password;
    private UserAccessManager $uac;

    public function __construct() {
        parent::__construct();
        $this->uac = new UserAccessManager(__DIR__ . DIRECTORY_SEPARATOR . "user" . DIRECTORY_SEPARATOR . "uac.json");
    }
    public function regenerateSession(array $keepKeys = ['route_tokens']): void {
        $preserved = [];
        foreach ($keepKeys as $key) {
            if (isset($_SESSION[$key])) {
                $preserved[$key] = $_SESSION[$key];
            }
        }
        session_regenerate_id(true);
        foreach ($preserved as $key => $value) {
            $_SESSION[$key] = $value;
        }
    }
    /* ---------- CSRF Protection ---------- */
    public function generateCsrfToken(): string {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }

    public function validateCsrfToken($token): bool {
        return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], (string)$token);
    }

    /* ---------- Authentication ---------- */
    public function initUser($username, $password) {
        $this->username = $username;
        $this->password = $password;
    }

    public function exists(): bool {
        $sql = "SELECT userid, username FROM user WHERE username = ?";
        $rows = $this->numRows(query: $sql, params: [$this->username]);
        return $rows > 0;
    }

    public function accountHealth($status, $attempts): bool|string {
        if ($status == '0') {
            return "Account not activated. Please contact your school admin to activate";
        } else if ($attempts <= 0) {
            return "Your account is blocked";
        } else {
            return TRUE;
        }
    }

    public function verifyPassword($userid, $password, $attempts): bool|string {
        if (password_verify($this->password, $password) === TRUE) {
            $sql = "UPDATE user SET attempts = ? WHERE userid = ? ";
            $this->executeUpdate(query: $sql, params: [4, $userid]);
            return TRUE;
        } else {
            $attempts--;
            $sql = "UPDATE user SET attempts = ? WHERE userid = ?";
            $this->executeUpdate(query: $sql, params: [$attempts, $userid]);
            if ($attempts > 0) {
                return "Incorrect password: $attempts attempts remaining";
            } else {
                return "Account blocked";
            }
        }
    }

    /* ---------- Login & Role Switching ---------- */
    public function login($user): bool|string {
        $UserProfilesAvailable = $this->getUserProfilesAvailable();
        $this->regenerateSession(['route_tokens', 'csrf_token']);
        $profile = $user['profile'] ?? null;
        $url = $UserProfilesAvailable[$profile] ?? 'default.php';
        $_SESSION['user'] = $user;
        return "request.php?tkn=" . $this->storeRoute($url);
    }

    public function switch_role($user): bool|string {
        $UserProfilesAvailable = $this->getUserProfilesAvailable();
        $profile = $user['profile'] ?? null;
        $url = $UserProfilesAvailable[$profile] ?? 'default.php';
        $_SESSION['user'] = $user;
        return "request.php?tkn=" . $this->storeRoute($url);
    }

    /* ---------- UAC Integration ---------- */

    /** Return array of switchable profiles for a given profile and (optionally) userId */
    public function getSwitchableProfiles(string $currentProfile, ?string $userId = null): array {
        return $this->uac->getSwitchableProfiles($currentProfile, $userId);
    }

    /** Return permission entries for profile */
    public function getProfilePermissions(string $profile): array {
        return $this->uac->getProfilePermissions($profile);
    }

    /** Check whether current user (or specified user) has a specific permission */
    public function hasPermission(string $userId, string $permission): bool {
        $data = $this->uac->get();

        // 1. check explicit user permissions
        $userPerms = array_filter($data['user_permission'] ?? [], function($p) use ($userId, $permission) {
            return isset($p['user'], $p['permission'], $p['is_allowed']) &&
                   $p['user'] === $userId &&
                   $p['permission'] === $permission &&
                   !empty($p['is_allowed']);
        });
        if (!empty($userPerms)) return true;

        // 2. check the current session profile
        $currentProfile = $_SESSION['user']['profile'] ?? null;
        if (!$currentProfile) return false;

        $profilePerms = array_filter($data['permission_keys'] ?? [], function($p) use ($currentProfile, $permission) {
            return isset($p['profile'], $p['permission']) &&
                   $p['profile'] === $currentProfile &&
                   $p['permission'] === $permission;
        });
        return !empty($profilePerms);
    }

    /* ---------- Existing helpers preserved ---------- */
    public function checkmail($address): bool {
        $stmt = "SELECT email FROM user WHERE email = ?";
        $row_count = $this->numRows(query: $stmt, params: [$address]);
        return $row_count > 0;
    }

    public function resetPassword($new_password, $address): bool {
        $stmt = "UPDATE user SET password = ?, attempts = ? WHERE email = ?";
        $result = $this->executeUpdate(query: $stmt, params: [$new_password, 4, $address]);
        return (bool)$result;
    }
    public function reportLogin($userid): void {
        $stmt = "UPDATE user SET session_id = ?, lastlogindate = ?, lastlogintime = ? WHERE userid = ? ";
        $this->executeUpdate(query: $stmt, params: [session_id(), $this->todaysDate(), $this->currentTime(), $userid]);
    }
    public function check_login() {
        if (!isset($_SESSION['user'])) {
            $host = $_SERVER['HTTP_HOST'];
            $uri  = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
            $extra = "request.php?tkn=".$this->storeRoute("user/signin.php")."&error=Please login to begin your session";
            header("location: http://$host$uri/$extra"); exit;
        }
        $this->check_for_multiple_logins($_SESSION['user']['userid']);
    }
    public function getUserProfilesAvailable(): array {
        $data = $this->uac->get();
        $profiles = [];
        foreach ($data['user_roles'] ?? [] as $role) {
            if (isset($role['role_id'])) {
                $profiles[$role['role_id']] = $role['default_page'] ?? '';
            }
        }
        return $profiles;
    }

    public function getUserProfiles($user_role) {
        return $this->uac->getSwitchableProfiles($user_role, null);
    }

    public function check_profile($user, $profile) {
        $host = $_SERVER['HTTP_HOST'];
        $uri  = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');

        try {
            $rows = $this->uac->getSwitchableProfiles($user['role'] ?? '', null);
            if(isset($_SESSION['locked']) && $_SESSION['locked'] == true){
                $extra = "request.php?tkn=".$this->storeRoute("user/lockscreen.php")."&info=Please enter password to restore your session.";
                header("location: http://$host$uri/$extra"); exit;
            }
            if (empty($rows)) {
                $this->log("User Role Error: The ".$user['role']." role assigned to ".$user['displayname']." is not initialized in the user account control json file");
                $extra = "request.php?tkn=".$this->storeRoute("user/signin.php")."&info=Your role of ".$user['role']." has not been fully initialized in the user account control";
                header("location: http://$host$uri/$extra"); exit;
            }
            $rolesAllowed = array_column($rows, 'can_switch_to');
            if (!in_array($profile, $rolesAllowed, true)) {
                $extra = "request.php?tkn=".$this->storeRoute("user/signin.php")."&error=Your role as ".$user['role']." has been denied access";
                header("location: http://$host$uri/$extra"); exit;
            }
        } catch (Exception $e) {
            $this->log($e->getMessage());
        }
    }

    public function check_for_multiple_logins($userid) {
        $stmt = $this->pdo->prepare("SELECT session_id FROM user WHERE userid = ?");
        $stmt->execute([$userid]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$row || $row['session_id'] !== session_id()) {
            session_unset();
            session_destroy();
            header("location: request.php?tkn=".$this->storeRoute("user/signin.php")."&warning=Your session has been terminated because you're logged in somewhere else. Please login to proceed");
            exit();
        }
    }
    public function manageSessionTimeout($ajax = false) {
        $now = time();
        if (!isset($_SESSION['last_activity'])) {
            $_SESSION['last_activity'] = $now;
            return;
        }
        $inactive = $now - $_SESSION['last_activity'];

        if ($inactive >= LOGOUT_AFTER) {
            unset($_SESSION['user']);
            unset($_SESSION['last_activity']);
            unset($_SESSION['locked']);
            if ($ajax) { echo json_encode(['action' => 'logout']); exit; }
            header("Location: request.php?tkn=" . $this->storeRoute("user/signin.php") . "&info=You were logged out for inactivity.");
            exit;
        }

        if ($inactive >= LOCK_AFTER && !isset($_SESSION['locked'])) {
            $_SESSION['locked'] = true;
            if ($ajax) { echo json_encode(['action' => 'lock']); exit; }
            header("Location: request.php?tkn=" . $this->storeRoute("user/lockscreen.php"));
            exit;
        }

        if (!isset($_SESSION['locked'])) {
            $_SESSION['last_activity'] = $now;
        }

        if ($ajax) {
            echo json_encode(['action' => 'active']);
            exit;
        }
    }
    public function reportLogout($userid): void {
        $stmt = "UPDATE user SET session_id = ?, lastlogoutdate = ?, lastlogouttime = ? WHERE userid = ? ";
        $this->executeUpdate(query: $stmt, params: [NULL, $this->todaysDate(), $this->currentTime(), $userid]);
    }
}

class DataManipulation extends User{
    private $response = [];
    private function loadJson(string $section, array $conditions = []): array {
        $json = new DataHandler(__DIR__ . "\\user\\uac.json");
        $data = $json->getAllData();
        return $json->filter($data, $conditions, $section);
    }
    public function IsValidPeriod($start_date, $end_date) {
        if (empty($start_date) || empty($end_date)) {
            return false;
        }
        if(strtotime($end_date) < strtotime($start_date)) {
            return false;
        }
        return true;
    }
    public function hasPermission(string $userid, string $permissionKey): bool {
        $permissions = $this->loadJson('user_permission', [
            'user' => $userid,
            'permission' => $permissionKey,
        ]);
        foreach ($permissions as $perm) {
            if (!empty($perm['is_allowed'])) {
                return true;
            }
        }
        return false;
    }

    public function generateUid(): string{
        return substr(string: str_shuffle(string: "0123456789qwertyuioplkjhgfdsamnbvcxzQWERTYUIOPLKJHGFDSAMNBVCXZ"),offset: 0, length: 5);
    }
    public function create_dummy_school($code, $name, $category, $mail, $contact, $logo="upload/png/user-default-2-min.png"){
        $stmt = "SELECT `school_code` FROM school WHERE school_code = ? OR school_code = ? ";
        $num_rows = $this->numRows(query: $stmt, params: [$code, $name]);
        if($num_rows<1){
            $stmt = "INSERT INTO school (school_code, school_name, category, mail, contact, logo) VALUES (?, ?, ?, ?, ?, ?) ";
            if($this->executeInsert(query: $stmt, params: [$code,$name,$category,$mail,$contact,$logo])){
                $this->response = ["status"=>true,"message"=> "$name created successfully"];
            }else{$this->response = ["status"=>false, "message"=>"Unable to add $name"];}
        }else{$this->response = ["status"=>false, "message"=>"$name already exists"];}
        return $this->response;
    }
    public function create_default_school_account($school_code, $school_name, $school_mail, $school_contact, $logo="user-default-2-min.png"){
        $password = password_hash($this->cleanData("password"), PASSWORD_DEFAULT);
        $stmt = "SELECT userid FROM user WHERE username = ? ";
        if($this->numRows(query: $stmt, params: [$school_code]) == false){
            $stmt = "INSERT INTO user (school, userid, username, password, displayname, role, profile, email, contact, photo, regdate, attempts, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $last_insert_id = $this->executeInsert(query: $stmt, params: [$school_code, $this->generateUid(), $school_code, $password, $school_name, "school", "school", $school_mail, $school_contact, $logo, $this->todaysDate(), 4, 1]);
            if($last_insert_id){
                $this->response = ["status"=>true, "message"=>"Account created successfully"];
            }else{$this->response = ["status"=>false, "message"=>"Unable to create a default school account"];}
        }else{ $this->response = ["status"=>false, "message"=>"Account already exists"]; }
        return $this->response;
    }
    public function getNoSeries($conditions=[]){
        $stmt = "SELECT ns.id, ns.school AS school_code, sch.school_name, ns.ns_code, ns_name, ns.description, ns.startno, ns.endno, ns.lastused, ns.canskip, ns.category FROM no_series ns INNER JOIN school sch ON ns.school = sch.school_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code, ns_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getUsers($conditions=[]){
        $stmt = "SELECT u.id, u.school AS school_code, sch.school_name, u.userid, u.username, u.password, u.displayname, u.role, u.profile, u.email, u.contact, u.photo, u.regdate, u.lastlogindate, u.lastlogintime, u.lastlogoutdate, u.lastlogouttime, u.attempts, u.status FROM user u LEFT JOIN school sch ON u.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY role ASC, username ASC";
        $num_rows = $this->numRows($stmt, $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getUserList($conditions=[]){
        $stmt = "SELECT u.id, u.school AS school_code, sch.school_name, u.userid, u.username, u.password, u.displayname, u.role, u.profile, u.email, u.contact, u.photo, u.regdate, u.lastlogindate, u.lastlogintime, u.lastlogoutdate, u.lastlogouttime, u.attempts, u.status FROM user u LEFT JOIN school sch ON u.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); $stmt .= " AND role != 'sa' ";}
        $stmt .= " ORDER BY role ASC, username ASC";
        $num_rows = $this->numRows($stmt, $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getUserPermission(array $conditions = []): array {
        $this->response = ["status" => true, "data" => $this->loadJson("user_permission", $conditions)];
        return $this->response;
    }
    public function getPermissionKeys(array $conditions = []): array {
        $this->response = ["status" => true, "data" => $this->loadJson("permission_keys", $conditions)];
        return $this->response;
    }
    public function getUserRoles(array $conditions = []): array {
        $this->response = ["status" => true, "data" => $this->loadJson("user_roles", $conditions)];
        return $this->response;
    }
    public function userProfile($userid): mixed{
        $userDetails = [];
        $result = $this->getUsers(["userid"=>$userid]);
        if($result['status']){ $userDetails = $result['data'][0]; }
        return $userDetails;
    }
    public function getSchInfo($user){
        if($user['school_code'] !== NULL)
            return ["status"=>true, "data"=>$this->getschools(["school_code"=>$user['school_code']])['data'][0]];
        else
            return ["status"=>true, "message"=>"School info not initialized"];
    }
    public function getCountries(){
        $stmt = "SELECT * FROM country ORDER BY country_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: []);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: [])];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getRegions(){
        $stmt = "SELECT region.id, region.region_code, region.region_name, region.country_code, country.country_name FROM region INNER JOIN country ON region.country_code = country.country_code ORDER BY region_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: []);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: [])];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getCounties(){
        $stmt = "SELECT county.id, county.county_code, county.county_name, region.region_code, region.region_name FROM county  INNER JOIN region ON county.region = region.region_code ORDER BY county_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: []);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: [])];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSubCounties(){
        $stmt = "SELECT `sub-county`.id, `sub-county`.sc_code, `sub-county`.sc_name, county.county_code, county.county_name FROM `sub-county` INNER JOIN county ON `sub-county`.county_code = county.county_code ORDER BY sc_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: []);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: [])];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getScWards(){
        $stmt = "SELECT `sc-ward`.id, `sc-ward`.ward_code, `sc-ward`.ward_name, `sub-county`.sc_code, `sub-county`.sc_name FROM `sc-ward` INNER JOIN `sub-county` ON `sc-ward`.sub_county = `sub-county`.sc_code ORDER BY ward_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: []);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: [])];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSchools($conditions=[]){
        $stmt = "SELECT id, school_code, school_name, category, address, mail, contact, logo, mission, vision, core_values, facebook, twitter, instagram, linkedin, skype, website, established_year,status, created_at, updated_at FROM school ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, school_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getDimensions($conditions=[]){
        $stmt = "SELECT * FROM dimension d ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY created_at DESC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getDimensionValues($conditions=[]){
        $stmt = "SELECT dv.id, dv.school AS school_code, sch.school_name, dv.dim_id AS dim_id, d.dim_name, dv.dv_code, dv.dv_name, dv.description, dv.rct_nos, dv.inv_nos, dv.incharge, dv.filter_name FROM dim_value dv INNER JOIN dimension d ON dv.dim_id = d.dim_id INNER JOIN school sch ON dv.school = sch.school_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY dv.school ASC, d.dim_name ASC, dv.dv_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobCategories($conditions=[]){
        $stmt = "SELECT * FROM job_category";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobLevels($conditions=[]){
        $stmt = "SELECT * FROM job_level";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobGroups($conditions=[]){
        $stmt = "SELECT * FROM job_group";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobTitles($conditions=[]){
        $stmt = "SELECT job_title.id, job_title.title, job_category.name AS category, job_level.name AS level, job_group.name AS job_group, job_title.description, dpt.dept_name AS department, IF(job_title.status = 1, 'Active','Inactive') AS status, job_title.created_at, job_title.updated_at FROM job_title INNER JOIN department dpt ON dpt.dept_code = job_title.department INNER JOIN job_category ON job_title.category_id = job_category.id INNER JOIN job_level ON job_title.level_id = job_level.id INNER JOIN job_group ON job_title.group_id = job_group.id";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY job_title.title ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSkills($conditions=[]){
        $stmt = "SELECT * FROM skill";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobSkills($conditions=[]){
        $stmt = "SELECT job_skill.id, job_title.title AS job_title, skill.name AS skill_name, job_skill.created_at, job_skill.updated_at FROM job_skill INNER JOIN job_title ON job_skill.job_title_id = job_title.id INNER JOIN skill ON job_skill.skill_id = skill.id";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY skill.name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getTrainingPrograms($conditions=[]){
        $stmt = "SELECT tp.id, tp.school AS school_code, sch.school_name AS school_name, tp.program_code, tp.program_name, tp.facilitator_name, tp.start_date, tp.end_date, tp.status, tp.comment, tp.created_at, tp.updated_at FROM training_program tp INNER JOIN school sch ON tp.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, start_date DESC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getBenefitTypes($conditions=[]){
        $stmt = "SELECT bt.id, bt.school AS school_code, sch.school_name AS school_name, bt.benefit_type_code, bt.benefit_type_name, IF(bt.is_recurring = 1, 'Yes', 'No') AS is_recurring, bt.recurring_type, bt.quantity, bt.created_at, bt.updated_at FROM benefit_type bt INNER JOIN school sch ON bt.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, benefit_type_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getStaffBenefits($conditions=[]){
        $stmt = "SELECT sb.id, sb.school AS school_code, sch.school_name AS school_name, sb.benefit_code, CONCAT(stf.last_name, ' ', stf.first_name) AS staff_name, bt.benefit_type_name, sb.description, sb.effective_date, sb.status, sb.created_at, sb.updated_at FROM staff_benefit sb INNER JOIN benefit_type bt ON sb.benefit_type = bt.benefit_type_code INNER JOIN staff stf ON sb.staff_code = stf.staff_code INNER JOIN school sch ON sb.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, sb.staff_code, sb.benefit_type ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getLeaveTypes($conditions=[]){
        $stmt = "SELECT lt.id, lt.school AS school_code, sch.school_name AS school_name, lt.leave_type_code, lt.leave_type_name, lt.applies_to, lt.no_of_days_off, lt.maximum_leaves, lt.created_at, lt.updated_at FROM leave_type lt INNER JOIN school sch ON lt.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, leave_type_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getLeaveApplications($conditions=[]){
        $stmt = "SELECT lr.id, lr.school AS school_code, sch.school_name AS school_name, lr.leave_code, CONCAT(stf.last_name, ' ', stf.first_name) AS staff_name, lt.leave_type_name, lr.start_date, lr.end_date, lr.approval_status, lr.reason, lr.comment, usr.displayname AS approved_by, usr.displayname AS rejected_by, lr.created_at, lr.updated_at FROM leave_request lr INNER JOIN leave_type lt ON lr.leave_type = lt.leave_type_code INNER JOIN school sch ON lr.school = sch.school_code INNER JOIN staff stf ON lr.staff_code = stf.staff_code JOIN user usr ON lr.approved_by = usr.userid OR lr.rejected_by = usr.userid";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, stf.staff_code ASC, lr.start_date ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getStaffTransferRequests($conditions=[]){
        $stmt = "SELECT str.id, str.transfer_code, sch.school_name AS transfer_from, sch.school_name AS transfer_to, str.date_requested, CONCAT(stf.last_name, ' ', stf.first_name) AS requested_by, CONCAT(stf.last_name, ' ', stf.first_name) AS on_behalf_of, str.effective_date, str.approval_status, usr.displayname AS approved_by, usr.displayname AS rejected_by, str.comment, str.reason, str.created_at, str.updated_at FROM staff_transfer_request str INNER JOIN school sch ON str.transfer_from = sch.school_code OR str.transfer_to = sch.school_code LEFT JOIN staff stf ON str.requested_by = stf.staff_code OR str.on_behalf_of = stf.staff_code LEFT JOIN user usr ON str.approved_by = usr.userid OR str.rejected_by = usr.userid";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY str.transfer_from ASC, str.effective_date DESC, str.created_at DESC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getLeaveBalances($conditions=[]){
        $stmt = "SELECT lbl.id, lbl.school AS school_code, sch.school_name AS school_name, lbl.leave_balance_code, CONCAT(stf.last_name, ' ', stf.first_name) AS staff_name, lt.leave_type_name, lbl.total_leave, lbl.leave_used, lbl.leave_remaining, lbl.created_at, lbl.updated_at FROM leave_balance lbl INNER JOIN leave_type lt ON lbl.leave_type = lt.leave_type_code INNER JOIN staff stf ON lbl.staff_code = stf.staff_code INNER JOIN school sch ON lbl.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, stf.staff_code ASC, lt.leave_type_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobPostings($conditions=[]){
        $stmt = "SELECT jp.id, jp.school AS school_code, sch.school_name, dept.dept_name, jp.job_posting_code, jt.title AS job_title, jp.vacant_posts, jp.posting_date, jp.closing_date, jp.description, jp.employment_type, jp.location, jp.salary_range, jp.status, jp.created_at, jp.updated_at FROM job_posting jp INNER JOIN school sch ON jp.school = sch.school_code INNER JOIN department dept ON jp.department = dept.dept_code INNER JOIN job_title jt ON jp.job_title = jt.id";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, job_title ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getNews($conditions=[]){
        $stmt = "SELECT n.id, n.school AS school_code, sch.school_name, n.title, n.content, n.category, n.image, n.created_at, n.published_by FROM news n INNER JOIN school sch ON n.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, title ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobApplicants($conditions=[]){
        $stmt = "SELECT DISTINCT ja.id, ja.applicant_code, ja.applicant_name, ja.contact_phone, ja.contact_email, ja.created_at, ja.updated_at FROM job_applicant ja";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY applicant_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getJobApplications($conditions=[]){
        $stmt = "SELECT DISTINCT jba.id, sch.school_code, sch.school_name, ja.applicant_name, jp.job_posting_code, jt.title AS job_title, jba.resume, jba.cover_letter, jba.application_status, jba.comment, jba.created_at, jba.updated_at FROM job_application jba INNER JOIN job_posting jp ON jba.job_posting_code = jp.job_posting_code INNER JOIN job_applicant ja ON jba.applicant_code = ja.applicant_code INNER JOIN job_title jt ON jp.job_title = jt.id INNER JOIN school sch ON jp.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, job_posting_code ASC, applicant_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getTerms($conditions=[]){
        $stmt = "SELECT DISTINCT t.id, t.term_code, t.term_name, t.opening_date, t.closing_date FROM term t";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY term_code ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getClasses($conditions=[]){
        $stmt = "SELECT DISTINCT sc.id, sc.school AS school_code, sch.school_name AS school, sc.class AS class_code, c.class_name, c.abbrev, sc.is_offered, c.class_number, al.level_name, al.stage_order FROM school_class sc INNER JOIN class c ON sc.class = c.class_code INNER JOIN academic_level al ON al.level_name = c.level INNER JOIN school sch ON sc.school = sch.school_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, class_number ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getStreams($conditions=[]){
        $stmt = "SELECT DISTINCT s.id, sch.school_code, sch.school_name, sc.class, c.class_name, s.stream_code, s.stream_name, s.description, s.capacity, CONCAT(t.last_name, ' ', t.first_name) AS class_teacher, s.created_at, s.updated_at FROM stream s INNER JOIN school_class sc ON s.class = sc.class INNER JOIN class c ON sc.class = c.class_code LEFT JOIN school sch ON sch.school_code = sc.school LEFT JOIN teacher t ON s.class_teacher = t.teacher_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY sch.school_code ASC, s.class ASC, class_name ASC, stream_code ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSubjects($conditions=[]){
        $stmt = "SELECT sbj.id, sbj.school AS school_code, sch.school_name, sbj.class AS class_code, cl.class_name, sbj.subject_code, sbj.subject_name, sbj.group AS group_code, grp.group_name, sbj.department AS dept_code, dept.dept_name, sbj.category FROM `subject` sbj INNER JOIN school sch ON sbj.school = sch.school_code INNER JOIN class cl ON sbj.class = cl.class_code JOIN subject_group grp ON sbj.group = grp.group_code JOIN subject_department dept ON sbj.department = dept.dept_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, class_name ASC, dept_name ASC, subject_code ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getDepartments($conditions=[]){
        $stmt = "SELECT * FROM department ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, dept_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSubjectDepartments($conditions=[]){
        $stmt = "SELECT * FROM subject_department ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, dept_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSubjectGroups($conditions=[]){
        $stmt = "SELECT * FROM subject_group ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, group_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getStudents($conditions=[]){
        $stmt = "SELECT DISTINCT std.id, CONCAT(std.school,' - ', sch.school_name) AS school, std.adm_no, std.first_name, std.surname, std.last_name, std.gender, std.dob, std.doa, c.class_name AS class,  s.stream_name AS stream, t.term_name AS term, ce.year FROM student std INNER JOIN school sch ON std.school = sch.school_code LEFT JOIN class_enrollment ce ON ce.adm_no = std.adm_no LEFT JOIN stream s ON s.stream_code = ce.stream LEFT JOIN class c ON ce.class = c.class_code LEFT JOIN term t ON ce.term = t.term_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school ASC, class DESC, stream ASC, adm_no ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function mapStudentToClass($school, $adm_no, $class, $stream, $term, $year){
        $stmt = "SELECT id FROM class_enrollment WHERE school = ? AND adm_no = ? AND class = ? AND stream = ? AND term = ? AND year = ? ";
        $num_rows = $this->numRows(query: $stmt, params: [$school, $adm_no, $class, $stream, $term, $year]);
        if($num_rows<1){
            $stmt = "INSERT INTO class_enrollment (school, adm_no, class, stream, term, year) VALUES (?, ?, ?, ?, ?, ?) ";
            if($this->executeInsert(query: $stmt, params: [$school,$adm_no,$class,$stream,$term,$year])){
                $this->response = ["status"=>true, "message"=>"$adm_no successfully mapped to $class $stream"];
            }else{ $this->response = ["status"=>false, "message"=>"Unable to map $adm_no to $class $stream"];}
        }else{ $this->response = ["status"=>false, "message"=>"$adm_no already exists in $class $stream"];}
        return $this->response;
    }
    public function getTeachers($conditions=[]){
        $stmt = "SELECT t.id, t.school AS school_code, sch.school_name, t.teacher_code, t.first_name, t.last_name, t.gender, t.email, t.phone, t.id_no, t.hire_date, t.emp_term, t.status FROM teacher t INNER JOIN school sch ON t.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, first_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSupportStaffs($conditions=[]){
        $stmt = "SELECT sst.id, sst.school AS school_code, sch.school_name, sst.staff_code, sst.first_name, sst.last_name, sst.gender, sst.email, sst.phone,  sst.id_no, sst.hire_date, sst.emp_term, sst.status FROM support_staff sst INNER JOIN school sch ON sst.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, first_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getStaffs($conditions=[]){
        $stmt = "SELECT stf.id, stf.school AS school_code, sch.school_name, stf.staff_code, stf.first_name, stf.last_name, stf.gender, stf.email, stf.phone, stf.id_no, jt.id, jt.title AS job_title, stf.role, stf.hire_date, stf.department, dept.dept_name, stf.status, stf.emp_term, stf.profile_picture AS passport_url FROM staff stf INNER JOIN job_title jt ON stf.job_title = jt.id INNER JOIN school sch ON stf.school = sch.school_code INNER JOIN department dept ON stf.department = dept.dept_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, first_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getVendors($conditions=[]){
        $stmt = "SELECT v.id, v.school AS school_code, sch.school_name, v.vendor_no, v.vendor_name, v.contact_email, v.contact_phone, v.physical_address, v.created_at, v.updated_at FROM vendor v INNER JOIN school sch ON v.school = sch.school_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, vendor_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getDocumentUploads($conditions=[]){
        $stmt = "SELECT sf.id, sf.school AS school_code, sch.school_name, sf.file_id, CONCAT(stf.first_name, ' ', stf.last_name) AS staff_name, sf.document_type, sf.file_path, sf.uploaded_at, sf.updated_at FROM staff_file sf INNER JOIN school sch ON sf.school = sch.school_code INNER JOIN staff stf ON sf.staff = stf.staff_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, staff_name ASC, document_type ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getUnitCategories($conditions=[]){
        $stmt = "SELECT uc.id, uc.name AS unit_category, uc.description, uc.is_active, uc.created_at, uc.updated_at FROM unit_category uc";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY unit_category ASC, description ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getItemCategories($conditions=[]){
        $stmt = "SELECT ic.id, ic.name AS item_category, ic.description, ic.is_active, ic.created_at, ic.updated_at FROM item_category ic";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY item_category ASC, description ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getBaseUOMs($conditions=[]){
        $stmt = "SELECT buom.id, buom.name AS base_uom, buom.abbreviation, buom.category_id, ic.name AS category_name, buom.description, buom.symbol, buom.si_unit, buom.is_active, buom.created_at, buom.updated_at FROM base_unit_of_measure buom INNER JOIN item_category ic ON buom.category_id = ic.id ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY base_uom ASC, description ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getItemUOMs($conditions=[]){
        $stmt = "SELECT uom.id, uom.name AS item_uom, uom.abbreviation, uom.base_unit_id, CONCAT(buom.name, ' (',buom.abbreviation,')') AS base_uom, uom.conversion_factor, uom.is_default, uom.is_compound, uom.compound_structure, uom.description, uom.is_active, uom.created_at, uom.updated_at FROM unit_of_measure uom INNER JOIN base_unit_of_measure buom ON uom.base_unit_id = buom.id ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY item_uom ASC, description ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getStockItems($conditions=[]){
        $stmt = "SELECT itm.id, itm.school AS school_code, sch.school_name, itm.name AS item_name, itm.description, itm.category_id, ic.name AS item_category, itm.type AS item_type, itm.base_unit_of_measure_id, CONCAT(buom.name, ' (',buom.abbreviation,')') AS base_uom, itm.is_active, itm.purchase_cost, itm.is_depreciable, itm.depreciation_rate, itm.quantity_in_stock, itm.reorder_level, itm.asset_tag, itm.purchase_date, itm.last_service_date, itm.expected_service_lifetime, itm.created_at, itm.updated_at FROM stock_item itm INNER JOIN school sch ON itm.school = sch.school_code INNER JOIN item_category ic ON itm.category_id = ic.id INNER JOIN base_unit_of_measure buom ON itm.base_unit_of_measure_id = buom.id ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school ASC, item_type ASC, item_name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    
    // Finance module
    public function getBankAccounts($conditions=[]){
        $stmt = "SELECT ba.id, ba.school AS school_code, sch.school_name AS school_name, ba.name, ba.account_number, ba.bank_name, ba.branch, ba.currency FROM bank_account ba INNER JOIN school sch ON ba.school = sch.school_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school ASC, account_number ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getChartOfAccounts($conditions=[]){
        $stmt = "SELECT coa.id, coa.school AS school_code, sch.school_name, coa.no, coa.name, coa.type, coa.category, coa.parent, coa.typical_balance, coa.opening_balance, IF(coa.is_active = 1, 'Yes', 'No') AS is_active, coa.created_at, coa.updated_at, usr.displayname AS updated_by FROM chart_of_account coa INNER JOIN school sch ON coa.school = sch.school_code LEFT JOIN user usr ON coa.updated_by = usr.userid";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY type ASC, no ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getSchoolCharges($conditions=[]){
        $stmt = "SELECT c.id, c.school AS school_code, sch.school_name, c.charge_code, c.description, c.type, c.is_recurring, c.recurring_type, c.income_gl_account, c.expense_gl_account, dept.dept_name, c.normal_charge, c.insurance_charge, c.special_charge, c.special_from, c.special_to, c.status FROM charge c INNER JOIN school sch ON c.school = sch.school_code LEFT JOIN department dept ON c.department = dept.dept_code";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY school_code ASC, description ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function getTaxRates($conditions=[]){
        $stmt = "SELECT tr.id, tr.school AS school_code, sch.school_name AS school_name, tr.name, tr.rate, tr.type FROM tax tr INNER JOIN school sch ON tr.school = sch.school_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY type DESC, name ASC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
    public function editValue($table, $column, $id, $value){
        try{
            $stmt = "UPDATE ".$table." SET ".$column." = ? WHERE id = ?";
            $result = $this->executeUpdate(query: $stmt, params: [$value, $id]);
            return $result;
        } catch (Exception $e){
            throw new Exception("Unable to update $column to $value in $table where id is $id");
        }
    }
    public function registerApplicant($applicant_code, $applicant_name, $contact_phone, $contact_email){
        $stmt = "SELECT id FROM job_applicant WHERE applicant_code = ? OR contact_phone = ? OR contact_email = ?";
        $num_rows = $this->numRows(query: $stmt, params: [$applicant_code, $contact_phone, $contact_email]);
        if($num_rows<1){
            $stmt = "INSERT INTO job_applicant (applicant_code, applicant_name, contact_phone, contact_email) VALUES (?, ?, ?, ?) ";
            if($this->executeInsert(query: $stmt, params: [$applicant_code, $applicant_name, $contact_phone, $contact_email])){
                return ["status"=>"success","message"=> "Applicant registered successfully"];
            }else{ return ["status"=>"error","message"=> "Unable to register client"];}
        }else{ return ["status"=>"warning","message"=> "Client already exists"];}
    }
    public function applyForJob($applicant_code, $job_posting_code, $resume, $cover_letter){
        $stmt = "SELECT id FROM job_application WHERE applicant_code = ? AND job_posting_code = ?";
        $num_rows = $this->numRows(query: $stmt, params: [$applicant_code, $job_posting_code]);
        if($num_rows<1){
            $rus = $this->upload($resume);
            $clus = $this->upload($cover_letter);
            if($rus["status"] == FALSE){
                return ["status"=>"warning","message"=>$rus["message"]];
            }
            if($clus["status"] == FALSE){
                return ["status"=>"warning","message"=>$clus["message"]];
            }
            $resume_name = $rus["path"]; $cover_letter_name = $clus["path"];
            $stmt = "INSERT INTO job_application (applicant_code, job_posting_code, resume, cover_letter) VALUES (?, ?, ?, ?) ";
            if($this->executeInsert(query: $stmt, params: [$applicant_code, $job_posting_code, $resume_name, $cover_letter_name])){
                return ["status"=>"success","message"=> "Application submitted successfully"];
            }else{ return ["status"=>"error","message"=> "Unable to submit application"];}
        }else{ return ["status"=>"warning","message"=> "You already submitted an application for this post"];}
    }
    public function deleteRecord($table, $key, $value): string{
        $stmt = "DELETE FROM ".$table." WHERE ".$key." = ? ";
        $affected = $this->executeDelete(query: $stmt, params: [$value]);
        if($affected == true){
            $success = "$table deleted successfully";
        }else{$err = "Unable to delete $table";}
        return $err;
    }
    public function getAcademicSessions($conditions=[]){
        $stmt = "SELECT acds.id, acds.school AS school_code, sch.school_name AS school_name, acds.session_code, acds.session_name, acds.year, acds.start_date, acds.end_date, acds.term_no, acds.status FROM academic_session acds INNER JOIN school sch ON acds.school = sch.school_code ";
        $params = [];
        if(!empty($conditions)){ $stmt .= $this->buildWhereClauses($conditions); $params = $this->buildParams(conditions: $conditions); }
        $stmt .= " ORDER BY acds.school ASC, acds.year DESC, acds.term_no DESC";
        $num_rows = $this->numRows(query: $stmt, params: $params);
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->readData_array(query: $stmt, params: $params)];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
	}
    public function getCurrentAcademicSession($school, $year){
        $num_rows = $this->getAcademicSessions(["acds.school"=>$school,"acds.year"=>$year,"acds.status"=>1])['status'];
        if($num_rows>0){
            $this->response = ["status"=>true, "data"=>$this->getAcademicSessions(["school_code"=>$school,"acds.year"=>$year,"acds.status"=>1])['data']];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
	}
    public function getEnumValues($table, $column){
        $stmt = "SHOW COLUMNS FROM ".$table." WHERE Field = ? ";
        $num_rows = $this->numRows(query: $stmt, params: [$column]);
        if($num_rows>0){
            $row = $this->readData(query: $stmt, params: [$column]);
            if($row && isset($row['Type'])){
                $data = str_getcsv(trim($row['Type'], "enum()"), ",", "'", "\\");
                // if (is_array($data)) { sort($data);
                // } else { $data = []; }
            }
            $this->response = ["status"=>true, "data"=>$data];
        }else{$this->response = ["status"=>false, "message"=>"No records found"];}
        return $this->response;
    }
}

class Timetable{
    private $db;

    public function __construct() {
        $this->db = new DataManipulation();
    }
    public function generate($school, $session) {
        try {
            // Get classes for this school
            $res = $this->db->getClasses(["sc.school"=>$school['school_code']]);
            if($res['status']==false){ throw new Exception($res['message']);}
            $classes = $res['data'];
            foreach ($classes as $class) {
                // Get streams for this class
                $res = $this->db->getStreams(["sc.class"=>$class->class_code]);
                if($res['status']==false){ throw new Exception($res['message']); }
                $streams = $res['data'];
                foreach ($streams as $stream) {
                    $this->generateForStream($school, $session, $class, $stream);
                }
            }
        } catch (Exception $e) {
            $this->db->log($e->getMessage());
        }
    }

    private function generateForStream($school, $session, $class, $stream) {
        // Get subjects for this class
        try {
            $rows = $this->db->readData_array("SELECT * FROM class_subject WHERE school=? AND class=?", [$school['school_code'],$class->class]);

            foreach ($rows as $row) {
                $subjectId = $row['subject'];
                $lessons = $row['lessons_per_week'];

                // Pick a teacher
                $teacherRow = $this->db->readData("SELECT teacher FROM subject_teacher WHERE school=? AND subject=? LIMIT 1", [$school['school_code'],$subjectId]);
                if (!$teacherRow) continue;
                $teacherId = $teacherRow['teacher'];

                // Assign lessons one by one
                while ($lessons > 0) {
                    $slot = $this->findSlot($school, $class->class, $stream->id, $subjectId, $teacherId, $lessons);
                    if ($slot) {
                        if (!empty($slot['double'])) {
                            // double period
                            $this->create($school['school_code'], $session, $class->class, $stream->id, $slot['day'], $slot['period'], $subjectId, $teacherId);
                            $this->create($school['school_code'], $session, $class->class, $stream->id, $slot['day'], $slot['period'] + 1, $subjectId, $teacherId);
                            $lessons -= 2;
                        } else {
                            $this->create($school['school_code'], $session, $class->class, $stream->id, $slot['day'], $slot['period'], $subjectId, $teacherId);
                            $lessons--;
                        }
                    } else {
                        // no slot available, break to avoid infinite loop
                        break;
                    }
                }
            }
        } catch (Exception $e) {
            $this->db->log(''. $e->getMessage());
        }
    }

    private function findSlot($school, $class, $stream, $subject, $teacher, $remaining) {
        try {
            $subjectPref = $this->db->readData("SELECT * FROM subject_preference WHERE school=? AND subject=?", [$school['school_code'], $subject]);
            $subjectPref = is_array($subjectPref) && isset($subjectPref[0]) ? $subjectPref[0] : null;

            for ($day = 1; $day <= $school['days_per_week']; $day++) {
                for ($period = 1; $period <= $school['periods_per_day']; $period++) {

                    // Skip if preference mismatch
                    if ($subjectPref) {
                        if ($subjectPref['prefer_period'] === 'morning' && $period > ($school['periods_per_day'] / 2)) continue;
                        if ($subjectPref['prefer_period'] === 'afternoon' && $period <= ($school['periods_per_day'] / 2)) continue;
                        if ($subjectPref['prefer_day'] && $subjectPref['prefer_day'] != $day) continue;
                    }

                    // Handle double lessons
                    if ($subjectPref && $subjectPref['allow_double'] && $remaining >= 2) {
                        if ($period < $school['periods_per_day'] &&
                            $this->isSlotFree($school['school_code'], $class, $stream, $day, $period, $teacher) &&
                            $this->isSlotFree($school['school_code'], $class, $stream, $day, $period+1, $teacher)) {
                            return ['day' => $day, 'period' => $period, 'double' => true];
                        }
                    }

                    // Normal single slot
                    if ($this->isSlotFree($school['school_code'], $class, $stream, $day, $period, $teacher)) {
                        return ['day' => $day, 'period' => $period];
                    }
                }
            }
            return null;
        } catch (Exception $e) {
            $this->db->log($e->getMessage());
        }
    }

    private function isSlotFree($school, $class, $stream, $day, $period, $teacher) {
        try {
            // Check if class already has something
            $row = $this->db->numRows("SELECT id FROM class_schedule 
                WHERE school=? AND class=? AND stream=? AND day=? AND period=?",
                [$school, $class, $stream, $day, $period]);
            if ($row>0) return false;

            // Check if teacher already assigned
            $row = $this->db->numRows("SELECT id FROM class_schedule 
                WHERE school=? AND teacher=? AND day=? AND period=?",
                [$school, $teacher, $day, $period]);
            if ($row>0) return false;

            // Check constraints
            $row = $this->db->numRows("SELECT id FROM timetable_constraint
                WHERE school=? AND day=? AND period=? 
                AND (teacher=? OR class=? OR stream=?)",
                [$school, $day, $period, $teacher, $class, $stream]);
            if ($row>0) return false;

            return true;
        } catch (Exception $e){
            $this->db->log($e->getMessage());
        }
    }
    private function create($school, $session, $class, $stream, $day, $period, $subject, $teacher, $room = null) {
        $db = new DBController();
        $db->executeInsert("INSERT INTO timetable (school, session, day, period, class, stream, subject, teacher, room) VALUES (?,?,?,?,?,?,?,?,?)", [$school, $session, $class, $stream, $day, $period, $subject, $teacher, $room]);
    }
}
$dmo = new DataManipulation();
$pdf = new TCPDF();
$mail = new PHPMailer(false);
$mpesa = new Mpesa();