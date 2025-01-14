# frozen_string_literal: true

RSpec.describe Serialize::Notion::BirthdayToday do
  before do
    @serialize = described_class.new
    reader_config = {
      base_url: "https://api.notion.com",
      database_id: "c17e556d16c84272beb4ee73ab709631",
      secret: "secret_BELfDH6cf4Glc9NLPLxvsvdl9iZVD4qBCyMDXqch51B",
      filter: {
        "filter": {
          "or": [
            {
              "property": "BD_this_year",
              "date": {
                "equals": "2024-01-24"
              }
            }
          ]
        },
        "sorts": []
      }
    }
    @read = Read::Notion::BirthdayToday.new(reader_config)
  end

  describe "attributes and arguments" do
    it { expect(described_class).to respond_to(:new).with(0).arguments }
    it { expect(@serialize).to respond_to(:execute).with(1).arguments }
  end

  describe ".execute" do
    it "serialize the given data into a domain specific one" do
      VCR.use_cassette("/notion/birthdays/read_with_filter") do
        birthdays_response = @read.execute

        serialized_data = @serialize.execute(birthdays_response)

        are_birthdays = serialized_data.all? { |element| element.is_a?(Domain::Birthday) }

        expect(serialized_data).to be_an_instance_of(Array)
        expect(serialized_data.length).to eq(1)
        expect(are_birthdays).to be_truthy
      end
    end
  end
end
