require 'fileutils'
require 'date'
require 'yaml'
require 'rexml/document'
require 'ya2yaml'

include REXML

doc = Document.new(File.new(ARGV[0]))

FileUtils.rmdir "_posts"
FileUtils.mkdir_p "_posts"

doc.elements.each("rss/channel/item[wp:status = 'publish' and wp:post_type = 'post']") do |e|
  p e.elements['wp:post_name'].text
  post = e.elements
  wordpress_id = post['wp:post_id'].text
  #slug = post['wp:post_name'].text
  slug = wordpress_id
  date = DateTime.parse(post['wp:post_date'].text)
  name = "%02d-%02d-%02d-%s.textile" % [date.year, date.month, date.day, slug]
  date_string = "#{date.year}-#{date.month}-#{date.day}"
  title_string = post['title'].text

  


  # convert all tags and categories into categories
  categories = []
  post.each('category') do |cat|
    categories << cat.text
  end
  

  content = post['content:encoded'].text.encode("UTF-8")

  # convert <code></code> blocks to {% codeblock %}{% encodebloc %}
  #content = content.gsub(/<code>(.*?)<\/code>/, '`\1`')
  content = content.gsub(/<code>/, '{% codeblock %}')
  content = content.gsub(/<\/code>/, '{% endcodeblock %}')

  # convert <pre></pre> blocks to {% codeblock %}{% encodebloc %}
  #content = content.gsub(/<pre lang="([^"]*)">(.*?)<\/pre>/m, '`\1`')
  content = content.gsub(/<pre>/, '{% codeblock %}')
  content = content.gsub(/<pre lang="([^"]*)">/, '{% codeblock %}')
  content = content.gsub(/<\/pre>/m, '{% endcodeblock %}')

  # convert headers
  (1..3).each do |i|
    content = content.gsub(/<h#{i}>([^<]*)<\/h#{i}>/, ('#'*i) + ' \1')
  end

  puts "Converting: #{name}"

  data = {
    'layout' => 'post',
    'title' => post['title'].text,
    'date' => date_string,
    'comments' => true,
    'categories' => categories,
  }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

  File.open("_posts/#{name}", "w") do |f|
    f.puts "---"
    f.puts "layout: post"
    f.puts "title: '#{title_string}'"
    f.puts "date: #{date_string}"
    f.puts "wordpress_id: #{wordpress_id}"
    f.puts "permalink: /blogs/#{wordpress_id}"
    f.puts "comments: true"
    #f.puts "categories: #{categories_string}"
    #f.puts data
    f.puts "---"
    f.puts content
  end

end
