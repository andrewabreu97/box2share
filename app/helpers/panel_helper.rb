module PanelHelper

  def file_icon(extension)
    if extension && FileTest.exists?(Rails.root.join('app','assets','images','fileicons', "#{extension.downcase}.png"))
      "fileicons/#{extension.downcase}.png"
    else
      'fileicons/file.png'
    end
  end

end
