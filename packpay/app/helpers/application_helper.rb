# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
  def make_attributes(hsh)
    unless hsh.nil?
      output = ""
      hsh.each do |key, val|
        output << " #{key}=\"#{val}\"" 
      end
    end
    output
  end

  def country_code_select(object, method, priority_countries=nil, options={}, html_options={})
    countries = [TZInfo::Country.all.collect{|x|x.name}, TZInfo::Country.all_codes].transpose.sort
    if priority_countries.nil?
      output = select(object, method, countries, options, html_options)
    else
      output = "<select id='#{object}_#{method}' name='#{object}[#{method}]'#{make_attributes html_options}>\n"
      if options[:include_blank] == true
        output << "<option value=''></option>"
      end
      priority_countries.each do |pc|
        if options[:selected] == pc[:code] or options[:selected] == pc[:name]
          output << "<option value='#{pc[:code]}' selected>#{pc[:name]}</option>\n"
        else
          output << "<option value='#{pc[:code]}'>#{pc[:name]}</option>\n"
        end
      end
      output << "<option value='' disabled>----------------------------</option>\n"
      output << options_for_select(countries, options[:selected])
      output << "</select>\n"
    end
    output
  end  

  def get_age(dob)
    return nil unless dob
    now = Time.now
    now.year - dob.year - (dob.to_time.change(:year => now.year) > now ? 1 : 0)
  end
          
  def age(dob)
    diff = Date.today - dob
    age = (diff / 365.25).floor
    age.to_s
  end

  #def textilize(text)
    #RedCloth.new(text).to_html
  #end
  
end
