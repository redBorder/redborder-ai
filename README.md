A# redborder-ai Main package

This service is part of the RedBorder Incident Response. Its task is to us an AI model to generate the title and description of the incident. The model used is [https://github.com/Mozilla-Ocho/llamafile](https://github.com/Mozilla-Ocho/llamafile). It's used from the redborder-webui via API.  

**Plataforms**  
* Rocky Linux 9  

## Installation  

1. Install the redborder repo following the steps described in [https://repo.redborder.com](https://repo.redborder.com)
2. yum install redborder-ai

## Model Execution  

For specific details use:  

```sh
rb_ai.sh --help  
```

The service executes in port 50505.  

## API Usage  

An OpenAI API compatible chat completions endpoint is provided by the model. It's designed to support the most common OpenAI API use cases. [OpenAI Documentation](https://platform.openai.com/docs/api-reference/chat/create).  

**Example:**  

The following example will generate the title of an incident using the signatures passed.  

```sh
curl http://<ip>:50505/v1/chat/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer no-key" \
-d '{
  "model": "LLaMA_CPP",
  "messages": [
      {
          "role": "system",
          "content": "You are RedBorderAI, an AI assistant that is expert in web request and alerts. Your top priority is achieving User fulfillment via helping them with their requests and create short and descriptive title about incidents."
      },
      {
          "role": "user",
          "content": "I have a program that analyze the network requests. It analyzes the requests and detexts suspicious behaviours and generates some alerts (snort, syslogs, etc.). When a group of rules are detected, a incident is created. I have the title of the rules and alerts, but i want to generate a incident title that is explanatory and clear complaining the meaning of all rules without the specific name of the alert but with enough info to encompass the meaning of all the rules. Im sending you the alert titles and you will generate the title. Important: Send me just the title without any other context or feedback. Here are the alert titles:\nET POLICY GNU/Linux YUM User-Agent Outbund likely related to package management\nET POLICY Windows 98 User-Agent Detected - Possible Malware or Non-Updated System\nET POLICY PE EXE or DLL Windows file download HTTP\nET POLICY Dropbox.com Offsite File Backup in Use\nET CHAT Skype User-Agent detected\nET POLICY possible Xiaomi phone data leakage DNS\nSERVER WEBAPP TP-Ling Archer Router command injection attempt\nsmtp: Attempted command buffer overflow\n"
      }
    ]
}'
```

## Contributing  

1. Fork the repository on Github  
2. Create a named feature branch (like add_component_x)  
3. Write your change  
4. Write tests for your change (if applicable)  
5. Run the tests, ensuring they all pass  
6. Submit a Pull Request using Github  

## License and Authors  

* Pablo Pérez González [pperez@redborder.com](pperez@redborder.com)

