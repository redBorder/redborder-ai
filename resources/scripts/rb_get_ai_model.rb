#!/usr/bin/env ruby

require 'rubygems'
require 'json'

if ARGV.length != 1
  puts "Error: missing model id parameter."
  puts "Uso: ruby rb_get_ai_model.rb <id-of-model-to-get>"
  exit 1
end

# Obtener el parámetro
ai_selected_model = ARGV[0]

if !ai_selected_model
  printf "AI model selected/download from the redborder-webui not found"
  exit 1
end

# Check if file /root/.s3cfg-s3rbmalware exists
if !File.exist?('/root/.s3cfg_initial')
  printf "Impossible to connect to S3. File /root/.s3cfg-initial not found"
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
if !File.exist?("/var/lib/redborder-llm/model_sources/#{ai_selected_model}/#{model}")
  # Download machine
  printf "\nDownloading AI model. Please wait...\n"
  download_ok = system("s3cmd -c /root/.s3cfg_initial get --skip-existing s3://bucket/rb-webui/model_sources/#{ai_selected_model}/#{model} /var/lib/redborder-llm/model_sources/#{ai_selected_model}/#{model}")
  # Add permissions
  system("chmod 0755 /var/lib/redborder-llm/model_sources/#{ai_selected_model}/#{model}") if download_ok
else
  #Machine exist
  printf "\nModel already downloaded in the system\n"
end

system("rm -f /usr/lib/redborder/bin/llm-model; ln -s /var/lib/redborder-llm/model_sources/#{ai_selected_model}/#{model} /usr/lib/redborder/bin/llm-model")
printf "Finished.\n"
exit 0
