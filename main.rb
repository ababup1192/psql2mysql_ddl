require 'treetop'
require_relative 'ddl'

def parse(sql, name)
  parser = DDLParser.new
  parse = parser.parse(sql)
  if parse.nil?
    raise "#{name} is parse error!"
  else
    dbname = name.split(/\.sql/).first
    "CREATE DATABASE #{dbname};\n" +
    '\c ' + "#{dbname};\n" +
    (parse.get.map{|table|
      key_empty = table[:primary_key].nil?
      "CREATE TABLE IF NOT EXISTS #{table[:tname]} (\n" +
      table[:fields].map{|field|
        "\t#{field[:name]} #{field[:attr]}#{field[:not_null] ? " NOT NULL" : ""}"
      }.join(",\n") +
      if !key_empty then
        ",\n\tPRIMARY KEY (" +
        table[:primary_key].join(', ') +
        '));'
      else
        ");"
      end
    }.join("\n\n")) + "\n"
  end
end

def main
  sql_list = Dir::entries("./sql")
  puts(sql_list.select{|name| /\w+.sql/ =~ name}.map{ |name|
    parse(File.read("./sql/#{name}", {encoding: Encoding::UTF_8}), name)
  }.join("\n\n"))
# ddl = <<EOS
# EOS
# puts parse(ddl, "ddl")
end

main()
