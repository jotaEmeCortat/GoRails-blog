require "test_helper"

class PostTest < ActiveSupport::TestCase
   test "draft? returns true for draft post" do
    assert posts(:draft).draft?
  end

  test "draft? returns false for published post" do
    refute posts(:published).draft?
  end

  test "draft? returns false for scheduled post" do
    refute posts(:scheduled).draft?
  end

  test "published? returns true for published post" do
    assert posts(:published).published?
  end

  test "published? returns false for draft post" do
    refute posts(:draft).published?
  end

  test "published? returns false for scheduled post" do
    refute posts(:scheduled).published?
  end

  test "scheduled? returns true for scheduled post" do
    assert posts(:scheduled).scheduled?
  end

  test "scheduled? returns false for draft post" do
    refute posts(:draft).scheduled?
  end

  test "scheduled? returns false for published post" do
    refute posts(:published).scheduled?
  end
end
