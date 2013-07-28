require 'fpm'
require 'trollop'
require 'open3'

  opts = Trollop::options do
    opt :giturl, "The github url to clone from", :type => :string
    opt :ver, "The branch or tag referenced in git repo", :type => :string
    opt :newpackage, "Create a new package" 
    opt :key, "Apt repo key to use to sign package and repo", :type => :string
    opt :add, "Add package to local apt-repo"
  end

def packagebuild( version, giturl )
	month = Time.now.month
	day   = Time.now.day
	year  = Time.now.year
	if File.exist?("~/#{version}") 
		puts "#{ver}"
		Open3.popen3("rm -rf ~/#{version}")
	end	

	puts "checking out #{version} from #{giturl} into home directory ... "
        stdout, stderr, status = Open3.capture3("cd ~/ && git clone git://#{giturl} #{version} && cd #{version}")
	STDERR.puts stderr
	if status.success?
		puts stdout
	else
		STDERR.puts "OH NO! Error"
	end
        
	stdout, stderr, status = Open3.capture3("git checkout #{version}")
	STDERR.puts stderr
	if status.success?
		puts stdout
		puts "git checkout complete"
	else
		STDERR.puts "OH NO! Error, checkout failed, check tag name"
	end

	puts "running autogen.sh with --prefix=/usr/local"
	stdout, stderr, status = Open3.capture3("cd ~/#{version} && ./autogen.sh --prefix=/usr/local")
	if status.success?
		puts stdout
		puts "autgen complete!"
	else
		STDERR.puts "OH NO! Error, autogen failed."
	end
#	puts "running make..."
#	stdout, stderr = Open3.popen3("cd ~/#{version} && make -j8")

#	puts "Preparing temporary install directory..."
#	stdout, stderr = Open3.popen3("rm -rf /tmp/installdir && mkdir -p /tmp/installdir")

#	puts "Running make install and building into temp directory..."
#	stdout, stderr = Open3.popen3("cd ~/#{version} && make -j8 install DESTDIR=/tmp/installdir && cd ..")

#	puts "Building package using fpm builder... "
#	stdout, stderr = Open3.popen3("cd ~/ && fpm -s dir -t deb -n mono -v #{version}-git-master-#{month}#{day}#{year} -C /tmp/installdir usr/local")

#	puts "Done building package"
end


packagebuild( opts[:ver], opts[:giturl] )


#if opts[':giturl_given']
#	print "This is a test"
#	packagebuild( opts[:ver], opts[:giturl] )
#end
