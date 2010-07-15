jaunte
	by rjungemann (MIT License)
	http://thefifthcircuit.com

Jaunte is a utility to allow a user to quickly move from one directory to another. By remembering the user's most commonly accessed directories, Jaunte allows the user to switch to a particular directory with a tag (instead of typing a long path to get there).

It is similar to autojump (http://github.com/joelthelion/autojump) but neither requires a daemon to run, nor requires the user to modify files in the /etc directory. Additionally, Jaunte can be installed by typing in `gem install jaunte` and pasting a couple lines into the user's ".profile".

Jaunte is a little slower than autojump and its system of tagging and weighing is not as sophisticated. I hope to improve both of these characteristics of Jaunte.

The name originates from the book "The Stars My Destination" by Alfred Bester, where humans can teleport from place-to-place by "jaunting" (http://en.wikipedia.org/wiki/The_Stars_My_Destination).

Jaunte is currently pre-alpha. See the To Do section of this file to see what needs. The software obviously isn't perfect yet, though it works. I would love to hear feedback.


Usage:

Install Jaunte by typing in `gem install jaunte` (requires Ruby 1.8 or Ruby 1.9).

Alternatively you can check out the source from Github and install like so:

	git clone http://github.com/thefifthcircuit/jaunte.git
	cd jaunte && rake gem && gem install jaunte-*.gem

Your $HOME environment variable must be defined.

Add the following to your ".profile":

  function j {
  	cd `jaunte-jump $1`
  }
  function jd {
  	cd $1 && jaunte-append
  }

You can additionally add the following to the end of your ".profile" to make `cd` tap into Jaunte.

	  alias cd=jd

You can now type `jd PATH` to go to a particular path. To recall a path you've visited earlier, type `j TAG`, where TAG is a component of PATH.

For example,

	cd ~/Desktop # change directory to /Users/NAME/Desktop
	cd ../Pictures # change directory to /Users/NAME/Pictures
	cd /usr/lib # change directory to /usr/lib
	j Pictures # return to /Users/NAME/Pictures

Lastly, you can type in `jaunte-stat` to see the weights and paths for a particular tag.

Jaunte can be extended by overriding the "weigh" and the "taggify" methods in the Jaunte class. This can be done by adding something like the following to the end of the lib/jaunte.rb file:

	class Jaunte
		def weigh path, tag, tags
			1 # all tags are weighed the same
		end
	end
	
or

	class Jaunte
		def taggify path
			path.split("/")[1..-1].reverse # tags are in reverse order
		end
	end
	
The db used can be swapped with any Moneta-compatible storage engine. At the moment the easiest way to do this is to set the "defaults_store" class variable on the Jaunte class. You could add this to the bottom of lib/jaunte.rb:

	Jaunte.default_store =
		Moneta::YAML.new(:path => "#{ENV['HOME']}/.jaunte/catalog.yml")

To Do:

* Use a non-single-file database (perhaps using Moneta::File or another relatively cross-platform Moneta adapter)
* Push to rubygems.org
