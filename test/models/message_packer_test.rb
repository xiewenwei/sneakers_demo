require 'test_helper'

class MessagePackerTest < ActiveSupport::TestCase
  setup do
    @packer = MessagePacker.new "sneaker_demo_test"
  end

  test "pack request" do
    message = @packer.pack_request 1
    assert_match /\"from\":\"sneaker_demo_test/, message
    assert_match /\"data\":1/, message
  end

  test "unpack request" do
    message = "{\"from\" : \"one boohee-tiger 6354\", \"data\" : 12 }"
    data, from = @packer.unpack_request message
    assert_equal 12, data
    assert_equal "one boohee-tiger 6354", from
  end

  test "pack response" do
    message = @packer.pack_response "ok", 200
    assert_match /\"from\":\"sneaker_demo_test/, message
    assert_match /\"data\":\"ok\"/, message
    assert_match /\"status\":200/, message
  end

  test "unpack response" do
    message = "{\"from\" : \"one boohee-tiger 6355\", \"status\" : 200, \"data\" : \"success\" }"
    data, from, status = @packer.unpack_response message
    assert_equal "success", data
    assert_equal "one boohee-tiger 6355", from
    assert_equal 200, status
  end
end