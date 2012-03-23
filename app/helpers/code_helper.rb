module CodeHelper
  def listing(path)
    if full_path.directory?
      directory_contents(path, full_path)
    elsif full_path.exist?
      file_contents(path, full_path)
    else
      nonexistent_contents(path)
    end
  end

  private

  def directory_contents(path, full_path)
    readme = nil
    begin
      if File.exists?(full_path + 'README')
        File.open(full_path + 'README') { |f| readme = f.read }
      end
    rescue Errno::ENOENT
      # No file
    end
    Dir.open(full_path) do |dir|
      render :partial => 'directory', :locals => {
        :path => path,
        :dir => dir,
        :readme => readme
      }
    end
  end

  def file_contents(path, full_path)
    full_path.open do |file|
      render :partial => 'file', :locals => { :path => path, :file => file }
    end
  end

  def nonexistent_contents(path)
    render :partial => 'nonexistent', :locals => { :path => path }
  end

  def syntax_highlight(file, relative_path)
    mime_type = nil

    if file.path =~ /\.([a-zA-Z0-9]+)$/
      ext = $1

      mime_db = {
        'jpg' => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'gif' => 'image/gif',
        'svg' => 'image/svg+xml',
        'png' => 'image/png',
        'pdf' => 'application/pdf'
      }

      mime_type = mime_db[ext]
    end

    if mime_type
      if mime_type == 'application/pdf'
        content_tag(
          :object,
          nil,
          :data => data_code_path(:path => relative_path, :mime_type => mime_type),
          :type => mime_type,
          :style => 'width: 100%; height: 20em;'
        )
      else
        content_tag(
          :img,
          nil,
          :src => data_code_path(:path => relative_path, :mime_type => mime_type),
          :alt => 'This file represents an image.'
        )
      end
    else
      CodeRay.scan_file(file.path, :auto).div(:css => :class).html_safe
    end
  end

  def entry_link(dir, path, entry)
    text = entry
    if File.directory?(File.join(dir.path, entry))
      text += '/'
    end

    link_to(text, code_path(:path => (path + entry).to_s))
  end
end
