require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_number(number)
  digits = number.scan(/\d+/).join
  return digits if digits.length == 10
  return digits[1..10] if digits.length == 11 && digits[0] == '1'

  :bad_number
end

def peak(hashmap)
  max_count = hashmap.values.max
  hashmap.select { |_hour, count| count == max_count }.keys
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

phone_numbers = []
registration_hours = Hash.new { 0 }
registration_days = Hash.new { 0 }

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)

  phone_numbers << clean_phone_number(row[:homephone])

  date = Time.strptime(row[:regdate], '%m/%d/%y %H:%M')
  registration_hours[date.hour] += 1
  registration_days[date.wday] += 1
end

p phone_numbers

puts "Hours, most people registered at: #{peak(registration_hours)
                                            .join(', ')}"
WEEKDAY_NAMES = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday].freeze

puts "Weekdays, most people registered on: #{peak(registration_days)
                                               .map { |day| WEEKDAY_NAMES[day] }
                                               .join ', '}"
