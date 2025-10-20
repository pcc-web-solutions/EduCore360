<?php
if (!function_exists('config')) {
    function config(string $key, $default = null) {
        $value = getenv($key);

        if ($value === false) {
            return $default;
        }

        // Convert booleans automatically
        $lower = strtolower($value);
        if (in_array($lower, ['true', 'false'])) {
            return $lower === 'true';
        }

        return $value;
    }
}