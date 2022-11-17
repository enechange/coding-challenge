shared_examples 'validationに通らない' do
  it 'validationに通らない' do
    expect(error_value.valid?).to be_falsey
  end
end