shared_context 'with a running app' do
  let(:app) { Rack::Builder.parse_file('config.ru').first }
end

shared_context 'with token authorization' do
  let(:permitted_token) { Gris.secrets.permitted_tokens }
  before(:each) do
    header 'Http-Authorization', permitted_token
  end
end

shared_context 'with a running app and client accessing API V1' do
  include_context 'with a running app'
  include_context 'with token authorization'

  let(:client) do
    Hyperclient.new('http://example.org/') do |client|
      client.headers['Http-Authorization'] = permitted_token
      client.connection(default: false) do |conn|
        conn.request :hal_json
        conn.response :json
        conn.use Faraday::Adapter::Rack, app
      end
      client.headers.update('Accept' => 'application/vnd.echo-v1+json')
    end
  end
end

shared_context 'with a running app and client accessing API V2' do
  include_context 'with a running app'
  include_context 'with token authorization'

  let(:client) do
    Hyperclient.new('http://example.org/') do |client|
      client.headers['Http-Authorization'] = permitted_token
      client.connection(default: false) do |conn|
        conn.request :hal_json
        conn.response :json
        conn.use Faraday::Adapter::Rack, app
      end
      client.headers.update('Accept' => 'application/vnd.echo-v2+json')
    end
  end
end
