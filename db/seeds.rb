# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

pages = Dir[ Rails.root + 'db/seeds/*.txt' ]
pages.each do |page|
  text = File.open(page).read
  text.gsub!(/\r\n?/, "\n")

  line_num = 0

  title = ''
  body = ''

  text.each_line do |line|
    if line_num == 0
      title = line
    else
      body += line
    end
    line_num += 1
  end

  Page.create( title: title.strip, body: body.strip )
end
