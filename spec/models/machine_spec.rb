require 'rails_helper'

RSpec.describe Machine, type: :model do
  describe 'validations' do
    it { should validate_presence_of :location }
    it { should belong_to :owner }
  end

  describe "relationships" do
    it { should have_many :machine_snacks }
    it { should have_many(:snacks).through(:machine_snacks) }
  end

  it "model methods" do
    owner = Owner.create(name: "Carl")
    machine_1 = Machine.create(location: "Denver", owner_id: owner.id)
    machine_2 = Machine.create(location: "Aurora", owner_id: owner.id)

    chips = Snack.create!(name: "chips", price: 1.0)
    donut = Snack.create!(name: "donut", price: 2.0)
    salsa = Snack.create!(name: "salsa", price: 3.0)
    soda = Snack.create!(name: "soda", price: 1.0)

    MachineSnack.create!(machine_id: machine_1.id, snack_id: chips.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: donut.id)
    MachineSnack.create!(machine_id: machine_1.id, snack_id: salsa.id)
    MachineSnack.create!(machine_id: machine_2.id, snack_id: soda.id)

    expect(machine_1.average_price).to eq(2.0)
  end
end
