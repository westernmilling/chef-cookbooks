name             'deploy'
maintainer       'Joseph Bridgwater-Rowe'
maintainer_email 'joe@westernmilling.com'
license          'All rights reserved'
description      'Creates and configures a passwordless deployment user.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apt'
depends 'user'
