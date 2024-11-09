require 'spec_helper'

describe Persey::Adapters::Yaml do
  describe '.load' do
    let(:fixtures_path) { File.expand_path('../../../fixtures', __dir__) }

    context 'with aliases' do
      let(:config_path) { File.join(fixtures_path, 'yaml_config_with_aliases.yml') }

      it 'correctly loads yaml with aliases' do
        result = described_class.load(config_path, :production)

        expect(result[:defaults][:database]).to eq(result[:production][:database])
        expect(result[:production][:database][:host]).to eq('localhost')
        expect(result[:production][:database][:port]).to eq(5432)
      end
    end

    context 'with ERB and aliases' do
      let(:config_path) { File.join(fixtures_path, 'yaml_config_with_erb_and_aliases.yml') }

      before do
        ENV['DB_HOST'] = 'custom-host'
      end

      after do
        ENV.delete('DB_HOST')
      end

      it 'processes ERB and resolves aliases' do
        result = described_class.load(config_path, :production)

        expect(result[:production][:database][:host]).to eq('custom-host')
        expect(result[:staging][:database]).to eq(result[:production][:database])
      end
    end
  end
end