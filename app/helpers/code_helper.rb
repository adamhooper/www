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
      File.open(full_path + 'README') { |f| readme = f.read }
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
    mime_types = MIME::Types.type_for(file.path)
    if mime_types and mime_types.size > 0
      mime_type = mime_types.first

      if mime_type.media_type == 'image'
        return content_tag(
          :img,
          nil,
          :src => data_code_path(:path => relative_path, :mime_type => mime_type.content_type),
          :alt => 'This file represents an image.'
        )
      end

      if mime_type.content_type == 'application/pdf'
        return content_tag(
          :object,
          nil,
          :data => data_code_path(:path => relative_path, :mime_type => mime_type.content_type),
          :type => mime_type.content_type,
          :style => 'width: 100%; height: 20em;'
        )
      end
    end

    syntax = Uv.syntax_for_file(file.path)
    if syntax.first
      return Uv.parse(file.read, 'xhtml', syntax.first.first, false, 'lazy')
    end

    return content_tag(:pre, file.read)
  end

  def entry_link(dir, path, entry)
    text = entry
    if File.directory?(File.join(dir.path, entry))
      text += '/'
    end

    link_to text, code_path(:path => (path + entry).to_s)
  end
end
