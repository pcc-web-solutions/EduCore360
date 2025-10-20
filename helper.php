<?php
if (!function_exists('config')) {
    function config(string $key, $default = null) {
        $value = $_ENV[$key];

        if ($value === false) {
            return $default;
        }
        $lower = strtolower($value);
        if (in_array($lower, ['true', 'false'])) {
            return $lower === 'true';
        }

        return $value;
    }
}