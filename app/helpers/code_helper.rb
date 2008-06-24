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
    Dir.open(full_path) do |dir|
      render :partial => 'directory', :locals => { :path => path, :dir => dir }
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
end
