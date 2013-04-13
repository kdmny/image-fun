require 'helper'
require 'tempfile'
class TestImageFunRemote < Test::Unit::TestCase
  should "should have attr_accessors" do
    m = TestModel.new
    m.image_url = "http://placehold.it/300x250"
    assert m.image_url == "http://placehold.it/300x250", "Testing image_url attribute exists"
    m.stubs(:do_download_remote_image).returns(Tempfile.new('test'))
    m.stubs(:slug).returns("foo")
    m.valid?
    assert m.image_remote_url == m.image_url
    assert m.refreshing_image
    assert m.img_file_name == "foo.jpg"
    ::Cloudinary::Uploader.stubs(:upload).returns(true)
    m.save
    assert !m.refreshing_image
  end
end
