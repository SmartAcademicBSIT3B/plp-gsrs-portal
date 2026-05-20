<?php
// Shared CORS/session bootstrap for backend API wrappers.
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$allowedOriginsEnv = getenv('FRONTEND_ORIGINS') ?: '';
$allowedOrigins = array_values(array_filter(array_map('trim', explode(',', $allowedOriginsEnv))));

if ($origin !== '') {
    if (empty($allowedOrigins) || in_array($origin, $allowedOrigins, true)) {
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Vary: Origin');
        header('Access-Control-Allow-Credentials: true');
    }
}

header('Access-Control-Allow-Headers: Content-Type, X-Requested-With, Accept, Authorization');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'OPTIONS') {
    http_response_code(204);
    exit();
}

$httpsOn = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
    || (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https');

if ($httpsOn) {
    ini_set('session.cookie_secure', '1');
    ini_set('session.cookie_samesite', 'None');
}
