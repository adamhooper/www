class RedCloth
  # Patch for RedCloth.  Fixed in RedCloth r128 but _why hasn't released it yet.
  # <a href="http://code.whytheluckystiff.net/redcloth/changeset/128">http://code.whytheluckystiff.net/redcloth/changeset/128</a>
  def hard_break( text ) 
    text.gsub!( /(.)\n(?!\n|\Z| *([#*=]+(\s|$)|[{|]))/, "\\1<br />" ) if hard_breaks 
  end 
end
