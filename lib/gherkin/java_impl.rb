class Class
  # Causes a Java class to be instantiated instead of the Ruby class when 
  # running on JRuby. This is used to test both pure Java and pure Ruby classes 
  # from the same Ruby based test suite. The Java Class must have a package name
  # that corresponds with the Ruby class.
  def java_impl(jar)
    if defined?(JRUBY_VERSION)
      require jar
      class << self
        define_method(:new) do |*args|
          names = self.name.split('::')
          package = Java
          names[0..-2].each do |module_name|
            package = package.__send__(module_name.downcase)
          end
          package.__send__(names[-1]).new(*args)
        end
      end
    end
  end
end