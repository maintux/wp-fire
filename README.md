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