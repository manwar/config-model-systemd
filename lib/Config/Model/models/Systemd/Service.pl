[
  {
    'accept' => [
      '.*',
      {
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn' => 'Unknown parameter'
      }
    ],
    'element' => [
      'Service',
      {
        'config_class_name' => 'Systemd::Section::Service',
        'type' => 'warped_node',
        'warp' => {
          'follow' => {
            'disable' => '- disable'
          },
          'rules' => [
            '$disable',
            {
              'level' => 'hidden'
            }
          ]
        }
      }
    ],
    'include' => [
      'Systemd::CommonElements'
    ],
    'name' => 'Systemd::Service',
    'read_config' => [
      {
        'auto_create' => '1',
        'auto_delete' => '1',
        'backend' => 'Systemd::Unit',
        'file' => '&index.service'
      }
    ]
  }
]
;

