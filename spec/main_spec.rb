require_relative "../get_rbs"
get_rbs "main", from: './'
RSpec.describe do
  it "should return hash in given string" do
    expect(Parser.parse_hash("{begin: end") == {begin: "end"})
  end
end
