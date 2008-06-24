class CodeController < ApplicationController
  helper_method :path, :full_path

  def show
  end

  def download
    if full_path.directory?
      data = generate_tarball(full_path)
      filename = path.to_s.blank? ? 'adam-hooper-code' : path.basename.to_s
      send_data data, :type => 'application/x-tar', :filename => "#{filename}.tar.gz"
    elsif full_path.exist?
      type = MIME::Types.type_for(full_path.to_s)
      send_file full_path.to_s, :type => type.to_s, :stream => false
    else
      render :action => :show
    end
  end

  private

  def path
    if params[:path] && params[:path] != '.'
      Pathname.new(params[:path])
    else
      Pathname.new('')
    end
  end

  def full_path
    @full_path ||= find_full_path
  end

  def find_full_path
    root = "#{Rails.root}/lib/code"
    ret = Pathname.new(root) + path

    begin
      unless ret.realpath.to_s =~ /^#{Regexp.quote(root)}/
        raise Exception, "Path not allowed: '#{path}'"
      end
    rescue Errno::ENOENT
      return root
    end

    ret
  end

  def generate_tarball(directory)
    Dir.chdir(directory.parent) do
      StringIO.open do |io|
        class << io
          alias_method :close, :close_write
        end
        sgz = Zlib::GzipWriter.new(io)
        Archive::Tar::Minitar.pack(directory.basename.to_s, sgz)
        io.rewind
        return io.read
      end
    end
  end
end
