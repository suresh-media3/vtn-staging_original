module ApplicationHelper

  def getStringForActivityType(eType)

    hItems = {EActivityTypeAdmin     => "Admin",
              EActivityTypeUser      => "User",
              EActivityTypeAppraiser => "Appraiser",
              EActivityTypeUnknown   => "Unknown"}

    if hItems[eType].empty?
      return ""
    else
      return hItems[eType]
    end

  end

  def getStringForActivityValue(eValue)
    if APPRAISAL_STATUS[eValue].empty?
      return ""
    else
      return APPRAISAL_STATUS[eValue]
    end

  end

  def getStringForAppraisalDataType(eType)

    hItems = {EAppraisalDataTypeString    => "String",
              EAppraisalDataTypeLocation  => "Location",
              EAppraisalDataTypeValuation => "Valuation"}

    if hItems[eValue].empty?
      return ""
    else
      return hItems[eValue]
    end

  end

  def getStringForAppraisalType(nType)
    return "" if nType.nil?

    hItems = {EAAppraisalTypeShortRestricted => "Light Restricted Use Appraisal",
              EAAppraisalTypeLongRestricted  => "Full Restricted Use Appraisal",
              EAAppraisalTypeShortForSelling => "Light Summary Appraisal",
              EAAppraisalTypeLongForSelling => "Full Summary Appraisal"}

    hItems[nType].empty? ? "" : hItems[nType]
  end

  def getStringForPayoutStatus(status)
    return "" if status.nil?
    PAYOUT_STATUS[status].empty? ? "" : PAYOUT_STATUS[status]
  end

  def getStringForExpectedUse(nType)
    aTypes = ["Summary","Restricted"]

    if nType.nil? || nType < 0 || nType >= aTypes.length
      return ""
    else
      return aTypes[nType]
    end
  end

  
  def wicked_pdf_image_tag(img, options={})
    if img[0].chr == "/" # images from paperclip
      new_image = img.slice 1..-1
      image_tag "file://#{Rails.root.join('public', new_image)}", options
    elsif img[0].chr == "h" # images stored in s3
      image_tag img, options
    else
      image_tag "file://#{Rails.root.join('public', 'images', img)}", options
    end
  end

  def getProfileForUser(user)
    u = User.find(user)
    if !u.nil?
      return raw "#{image_tag u.avatar_url(:small), :size => '20x20', :class=>'gravatar-tiny'} #{u.name}" 
    else
      return ""
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.simple_fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s + "/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "btn btn-success add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def get_url_for_shared_appraisal(appraisal)
    show_shared_url(appraisal)
  end

  def print_as_currency(number)
    number_to_currency(number, :locale => :us)
  end

  def display_time(total_seconds)
    total_seconds = total_seconds.to_i
    
    days = total_seconds / 86400
    hours = (total_seconds / 3600) - (days * 24)
    minutes = (total_seconds / 60) - (hours * 60) - (days * 1440)
    seconds = total_seconds % 60
    
    display = ''
    display_concat = ''
    if days > 0
      display = display + display_concat + "#{days}d"
      display_concat = ' '
    end
    if hours > 0 || display.length > 0
      display = display + display_concat + "#{hours}h"
      display_concat = ' '
    end
    if minutes > 0 || display.length > 0
      display = display + display_concat + "#{minutes}m"
      display_concat = ' '
    end
    display = display + display_concat + "#{seconds}s"
    display
  end

  def get_cms_content(path)
    page = Cms::Page.find_by_full_path(path)
    return page.nil? ? "Add content to #{path}" : page.content
  end
end
