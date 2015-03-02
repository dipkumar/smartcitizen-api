require 'rails_helper'

RSpec.describe Reading, :type => :model do

  let(:device) { create(:device) }

  it "needs more specs"

  skip "id should be device_id:recorded_at:created_at"

  skip "should belong_to device" do
    reading = Reading.add device.id, Time.now, {'10': '12'}
    expect( reading.device ).to eq(device)
    expect( device.readings.first ).to eq(reading)
  end

  skip "updates latest_data on its device" do
    data = { '1': '12.10', '2': '33.40' }.stringify_keys
    Reading.create(device: device, values: data)
    device.reload
    expect(device.latest_data).to eq(data)
  end

end