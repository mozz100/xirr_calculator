# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

sipp = Account.create(code: 'SIPP001', name: 'Example SIPP')
isa  = Account.create(code: 'ISA001', name: 'Example ISA')

valuation = Entry.entrytypes[:valuation]
deposit   = Entry.entrytypes[:deposit]

start_date = Date.new(2014,1,1)
sipp.entries << Entry.new(entrytype: deposit,   entrydate: start_date,            value: 1000)
sipp.entries << Entry.new(entrytype: valuation, entrydate: start_date,            value: 1000)
sipp.entries << Entry.new(entrytype: valuation, entrydate: start_date +  30.days, value: 1100)
sipp.entries << Entry.new(entrytype: valuation, entrydate: start_date +  60.days, value: 1150)
sipp.entries << Entry.new(entrytype: valuation, entrydate: start_date +  90.days, value: 1140)
sipp.entries << Entry.new(entrytype: deposit,   entrydate: start_date + 100.days, value:  200)
sipp.entries << Entry.new(entrytype: valuation, entrydate: start_date + 101.days, value: 1342)
sipp.entries << Entry.new(entrytype: valuation, entrydate: start_date + 300.days, value: 1512)
