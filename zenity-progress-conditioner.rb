#!/opt/axsh/wakame-vdc/ruby/bin/ruby

f = File.open(ARGV.shift, 'r')
while true
   last = f.readlines[-1]
   if nil == last
      sleep 1
   else
      if "\x1a" == last.chomp
         exit
      elsif "100" == last.chomp
         puts last
         p last
         sleep 1
         exit
      else
         puts last
         p last
      end
   end
end
