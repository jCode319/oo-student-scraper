require 'open-uri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []
    index_page.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css("p")[0].text
        student_name = student.css("h4")[0].text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    students
    # binding.pry
   end

  def self.scrape_profile_page(profile_url)
    student = {}
    html = open(profile_url)
    profile = Nokogiri::HTML(html)
    profile.css("div.main-wrapper.profile .social-icon-container a").each do |social|
      if social.attribute("href").value.include?("twitter")
        student[:twitter] = social.attribute("href").value
      elsif social.attribute("href").value.include?("linkedin")
        student[:linkedin] = social.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        student[:github] = social.attribute("href").value
      else
        student[:blog] = social.attribute("href").value
      end
    end

    student[:profile_quote] = profile.css("div.main-wrapper.profile .vitals-text-container .profile-quote").text
    student[:bio] = profile.css("div.main-wrapper.profile .description-holder p").text

    student
  end
end