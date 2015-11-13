# DiagnosticReport Spec

require 'rest-client'
server = YAML.load_file('fhir_server.yml')

resource = JSON.parse(File.read("siim_andy_tcga-50-5072/DiagnosticReport/diagnostic_report_5072.ct499.json"))

describe '#delete' do
    result = RestClient.delete server[:url] + resource['resourceType'] + "/" + resource['id'],
                               :params => {:_format => server[:format]}

    it {expect(result.code).to be >= 200}
    it {expect(result.code).to be <= 204}

end

describe '#put' do

    begin
        result = RestClient.put server[:url] + resource['resourceType'] + "/" + resource['id'],
                                resource.to_json,
                                :content_type => server[:format] + '+fhir',
                                :params => {:_format => server[:format]}
    rescue => e
        puts e.inspect
    end

    it {expect(result.code).to eq 200}

end

describe '#get' do

    result = RestClient.get server[:url] + resource['resourceType'] + "/" + resource['id'],
                            :params => {:_format => server[:format]}

    it {expect(result.code).to eq 200}

    # need to remove the metadata and other keys from the server version
    json = JSON.parse(result)
    json.delete('meta')
    json.delete('lastUpdated')


    resource['performer']['reference'] = server[:url] + resource['performer']['reference']
    resource['subject']['reference'] = server[:url] + resource['subject']['reference']

    it {expect(json).to eq resource}

end
