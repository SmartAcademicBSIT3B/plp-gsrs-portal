<?php

if (!function_exists('loadEnvFile')) {
    /**
     * Load simple KEY=VALUE pairs from a .env file into process env.
     */
    function loadEnvFile($filePath)
    {
        static $loaded = [];

        if (isset($loaded[$filePath])) {
            return;
        }

        if (!is_readable($filePath)) {
            $loaded[$filePath] = true;
            return;
        }

        $lines = file($filePath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        if ($lines === false) {
            $loaded[$filePath] = true;
            return;
        }

        foreach ($lines as $line) {
            $line = trim($line);

            if ($line === '' || strpos($line, '#') === 0) {
                continue;
            }

            if (strpos($line, 'export ') === 0) {
                $line = substr($line, 7);
            }

            $separatorPos = strpos($line, '=');
            if ($separatorPos === false) {
                continue;
            }

            $key = trim(substr($line, 0, $separatorPos));
            $value = trim(substr($line, $separatorPos + 1));

            if ($key === '') {
                continue;
            }

            $firstChar = substr($value, 0, 1);
            $lastChar = substr($value, -1);
            if (($firstChar === '"' && $lastChar === '"') || ($firstChar === "'" && $lastChar === "'")) {
                $value = substr($value, 1, -1);
            }

            putenv($key . '=' . $value);
            $_ENV[$key] = $value;
            $_SERVER[$key] = $value;
        }

        $loaded[$filePath] = true;
    }
}
