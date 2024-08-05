#!/usr/bin/env ruby

require 'rubygems'
require 'chef'
require 'json'

#Configuring Chef parameters
Chef::Config.from_file("/etc/chef/client.rb")
Chef::Config[:client_key] = "/etc/chef/client.pem"
Chef::Config[:http_retry_count] = 5

def get_ai_selected_model
  role = Chef::Role.load("manager")
  role.override_attributes['redborder']['ai_selected_model'] rescue nil
end

# Check if file /root/.s3cfg-s3rbmalware exists
if !File.exist?('/root/.s3cfg_initial')
  printf "Impossible to connect to S3. File /root/.s3cfg-initial not found"
  exit 1
end

ai_selected_model = get_ai_selected_model
if !ai_selected_model
  printf "AI model selected/download from the redborder-webui not found"
  exit 1
end

# List available models from S3
models = `s3cmd -c /root/.s3cfg_initial ls s3://bucket/rb-webui/model_sources/#{ai_selected_model}/ | awk {'print $4;'} | cut -d "/" -f 7`
m_list = models.split("\n")

if m_list.length == 0
  printf "No AI Models #{ai_selected_model} available to download from S3\n"
  exit 1
end

model = m_list.first

download_ok = true

# Check if VM exists in the system
if !File.exist?("/var/lib/redborder-ai/model_sources/#{ai_selected_model}/#{model}")
  #Download machine
  printf "\nDownloading AI model. Please wait...\n"
  download_ok = system("s3cmd -c /root/.s3cfg_initial get --skip-existing s3://bucket/rb-webui/model_sources/#{ai_selected_model}/#{model} /var/lib/redborder-ai/model_sources/#{ai_selected_model}/#{model}")
else
  #Machine exist
  printf "\nModel already downloaded in the system\n"
end

system("rm -f /usr/lib/redborder/bin/ai-model; ln -s /var/lib/redborder-ai/model_sources/#{ai_selected_model}/#{model} /usr/lib/redborder/bin/ai-model")
printf "Finished.\n"
exit 0
