require "test_helper"

class AccessControlTest < ActiveSupport::TestCase
  def test_nonexistent_repo_guest_cannot_read_or_write
    guest = Guest.new
    access_control = AccessControl.new(PretendProject.new)

    assert_equal(false, access_control.readable?(guest))
    assert_equal(false, access_control.writable?(guest))
  end
end
