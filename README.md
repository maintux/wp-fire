Wp Fire
=======

**Wordpress theme generator with Coffee Script and Sass support**
-----

Install Wp Fire (requires [Ruby](http://www.ruby-lang.org/))

    $ gem install wp-fire

Create a new theme

    $ cd your_wordpress_path/wp-content/themes/
    $ wp_fire create new_theme_name

If you want create a theme based on existing template

    $ cd your_wordpress_path/wp-content/themes/
    $ wp_fire create -t template_name --template_path ./

To edit theme settings

    $ wp_fire create --help

Run watcher for compiling sass and coffeescript file

    $ cd your_wordpress_path/wp-content/themes/
    $ wp_fire watch new_theme_name (Ctrl + C to exit)

License
-------

(The GPLv2 License)

Copyright (C) 2012 Massimo Maino

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as published by
the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

<http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt>