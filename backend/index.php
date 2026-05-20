<?php
header('Content-Type: application/json');
echo json_encode([
    'service' => 'plp-gsrs-backend',
    'status' => 'ok'
]);
