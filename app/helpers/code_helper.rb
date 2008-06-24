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

  def syntax_highlight(file)
    syntax = Uv.syntax_for_file(file.path)
    if syntax.first
      Uv.parse(file.read, 'xhtml', syntax.first.first, false, 'lazy')
    else
      content_tag(:pre, file.read)
    end
  end

  def entry_link(dir, path, entry)
    text = entry
    if File.directory?(File.join(dir.path, entry))
      text += '/'
    end

    link_to text, code_path(:path => (path + entry).to_s)
  end
end
