# Build gemspec
gem build  logstash-output-journal.gemspec | tee build.out
filename=$(  grep "File:" build.out | sed "s/File://" | sed "s/^ *//" )
echo "New gem: $filename"
echo "Remove old output-journal"
sudo /usr/share/logstash/bin/logstash-plugin remove logstash-output-journal
echo "Install new one"
sudo /usr/share/logstash/bin/logstash-plugin install $(realpath "$filename" )
echo "done"
