require File.dirname(__FILE__) + '/../../spec_helper'

describe Blog::Post do
  before(:each) do
    @post = Blog::Post.new
  end

  it "should return no tags" do
    @post.tags.should be_empty
  end

  it "should accept tags" do
    tag1 = Tag.new(:name => 'foo')
    tag2 = Tag.new(:name => 'bar')
    @post.tags = [ tag1, tag2 ]
    @post.tags.should eql([ tag1, tag2 ])
  end

  it "should return tags in tag_names" do
    tag1 = Tag.new(:name => 'foo')
    tag2 = Tag.new(:name => 'bar')
    @post.tags = [ tag1, tag2 ]
    @post.tag_names.should eql('bar, foo') # alphabetical
  end

  it "should return empty string in empty tag_names" do
    @post.tag_names.should eql('')
  end

  it "should assign tags via tag_names=" do
    tag1 = Tag.create!(:name => 'foo')
    tag2 = Tag.create!(:name => 'bar')
    @post.tag_names = 'foo, bar'
    @post.tags.should eql([ tag1, tag2 ])
  end

  it "should delete tags via tag_names=" do
    tag1 = Tag.create!(:name => 'foo')
    tag2 = Tag.create!(:name => 'bar')
    @post.tag_names = 'foo, bar'
    @post.tag_names = 'bar'
    @post.tags.should eql([ tag2 ])
  end

  it "should strip whitespace in tag_names=" do
    @post.tag_names = '1,2,           3'
    @post.tag_names.should eql('1, 2, 3')
  end
end

describe Blog::Post, "which is unsaved and valid" do
  before(:each) do
    @post = Blog::Post.new(
      :title => 'Title',
      :body => 'Body',
      :format => 'Format'
    )
  end

  it "should be valid" do
    @post.should be_valid
  end
end
