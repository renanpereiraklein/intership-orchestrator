{
  "name": "Estagiario",
  "nodes": [
    {
      "parameters": {
        "toolDescription": "AI specialist agent for Google Calendar. Responsible for managing Renan's schedule.",
        "text": "={{ $fromAI('Prompt__User_Message_', ``, 'string') }}",
        "options": {
          "systemMessage": "=You are my calendar secretary.\n\nYour job is to interpret the user request, find events in Google Calendar, and execute actions safely and precisely.\n\n---\n\n### Flow for delete\nAlways follow: Get → filter → Delete\n\n---\n\n### Date/time rules\n- Preserve the exact format returned by Get.\n- If event has \"dateTime\": keep \"dateTime\" and include \"timeZone\": \"America/New_York\".\n- If event has \"date\": keep \"date\" and remember end.date is one day after start.date.\n- Never convert date ↔ dateTime.\n\n---\n\n### Update rule\nWhen updating: Get → Create updated → Delete old (Create → Delete).\n\n---\n\nTools:\n- Get (getAll)\n- Create\n- Delete\n\nNow: {{ $now }}\n"
        }
      },
      "type": "@n8n/n8n-nodes-langchain.agentTool",
      "typeVersion": 2.2,
      "position": [1296, 880],
      "id": "REDACTED_NODE_ID",
      "name": "Calendar Agent"
    },
    {
      "parameters": {
        "toolDescription": "Specialist agent for WhatsApp messaging and contact management.",
        "text": "={{ $fromAI('Prompt__User_Message_', ``, 'string') }}",
        "options": {
          "systemMessage": "=You are the WhatsApp specialist agent.\n\nTasks:\n1) Look up contacts in Contacts tool when needed.\n2) Send WhatsApp messages via HTTP tool.\n\nContacts tool:\n- search always lowercase, no accents\n- columns: nome, numero\n\nWhatsApp tool:\n- body must be exactly: { \"number\": \"<E164>\", \"text\": \"<message>\" }\n- do NOT include name in the body\n- if schema error, do NOT retry; ask for confirmation\n\nNow: {{ $now }}\n"
        }
      },
      "type": "@n8n/n8n-nodes-langchain.agentTool",
      "typeVersion": 2.2,
      "position": [1904, 880],
      "id": "REDACTED_NODE_ID",
      "name": "Message Agent"
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Contacts table",
        "operation": "get",
        "dataTableId": "REDACTED_DATATABLE_ID",
        "filters": {
          "conditions": [
            {
              "keyName": "nome",
              "condition": "ilike",
              "keyValue": "={{ $fromAI('conditions0_Value', ``, 'string') }}"
            }
          ]
        }
      },
      "type": "n8n-nodes-base.dataTableTool",
      "typeVersion": 1,
      "position": [2112, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "Contacts"
    },
    {
      "parameters": {
        "toolDescription": "Personal finance specialist agent. Interprets questions and runs SQL on financial records.",
        "text": "={{ $fromAI('Prompt__User_Message_', ``, 'string') }}",
        "options": {
          "systemMessage": "=# CONTEXT\nYou are Renan's Finance Agent.\nYou are excellent at personal finance and strong in SQL.\nNow is {{ $now }}.\n\n# INSTRUCTIONS\n- Interpret the request.\n- Translate colloquial terms into valid filters.\n- Build SQL using quoted identifiers for columns with spaces/accents.\n- Execute query on Financial Records tool.\n- Reply with totals, comparisons, trends.\n\n# TOOLS\n- Financial Records (Postgres)\n- Calculator\n"
        }
      },
      "type": "@n8n/n8n-nodes-langchain.agentTool",
      "typeVersion": 2.2,
      "position": [2416, 880],
      "id": "REDACTED_NODE_ID",
      "name": "Finance Agent"
    },
    {
      "parameters": {
        "sessionIdType": "customKey",
        "sessionKey": "={{ $json.memoryKey }}",
        "sessionTTL": 180,
        "contextWindowLength": 7
      },
      "type": "@n8n/n8n-nodes-langchain.memoryRedisChat",
      "typeVersion": 1.5,
      "position": [2048, 400],
      "id": "REDACTED_NODE_ID",
      "name": "memory",
      "credentials": {
        "redis": {
          "id": "REDACTED",
          "name": "Redis account"
        }
      }
    },
    {
      "parameters": {
        "model": {
          "__rl": true,
          "value": "gpt-4o-mini",
          "mode": "list"
        },
        "options": {
          "temperature": 0.4
        }
      },
      "type": "@n8n/n8n-nodes-langchain.lmChatOpenAi",
      "typeVersion": 1.2,
      "position": [1920, 400],
      "id": "REDACTED_NODE_ID",
      "name": "model",
      "credentials": {
        "openAiApi": {
          "id": "REDACTED",
          "name": "OpenAI account"
        }
      }
    },
    {
      "parameters": {
        "resource": "audio",
        "operation": "transcribe",
        "options": {}
      },
      "type": "@n8n/n8n-nodes-langchain.openAi",
      "typeVersion": 1.8,
      "position": [1200, 304],
      "id": "REDACTED_NODE_ID",
      "name": "transcribe",
      "credentials": {
        "openAiApi": {
          "id": "REDACTED",
          "name": "OpenAI account"
        }
      }
    },
    {
      "parameters": {
        "rules": {
          "values": [
            {
              "conditions": {
                "options": { "caseSensitive": true, "typeValidation": "loose", "version": 2 },
                "conditions": [
                  {
                    "leftValue": "={{ $json.message.text }}",
                    "rightValue": "",
                    "operator": { "type": "string", "operation": "exists", "singleValue": true }
                  }
                ],
                "combinator": "and"
              },
              "renameOutput": true,
              "outputKey": "texto"
            },
            {
              "conditions": {
                "options": { "caseSensitive": true, "typeValidation": "loose", "version": 2 },
                "conditions": [
                  {
                    "leftValue": "={{ $json.message.voice.file_id }}",
                    "rightValue": "",
                    "operator": { "type": "string", "operation": "exists", "singleValue": true }
                  }
                ],
                "combinator": "and"
              },
              "renameOutput": true,
              "outputKey": "audio"
            }
          ]
        },
        "looseTypeValidation": true,
        "options": { "fallbackOutput": "extra" }
      },
      "type": "n8n-nodes-base.switch",
      "typeVersion": 3.3,
      "position": [752, 192],
      "id": "REDACTED_NODE_ID",
      "name": "switch"
    },
    {
      "parameters": {
        "resource": "file",
        "fileId": "={{ $json.message.voice.file_id }}",
        "additionalFields": {}
      },
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [976, 304],
      "id": "REDACTED_NODE_ID",
      "name": "get audio",
      "credentials": {
        "telegramApi": {
          "id": "REDACTED",
          "name": "Telegram bot account"
        }
      }
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            { "name": "msg", "value": "={{ $json.text || '' }}", "type": "string" }
          ]
        },
        "options": {}
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.4,
      "position": [1424, 304],
      "id": "REDACTED_NODE_ID",
      "name": "set audio"
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            { "name": "msg", "value": "={{ $json.message.text || '' }}", "type": "string" }
          ]
        },
        "options": {}
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.4,
      "position": [1424, 112],
      "id": "REDACTED_NODE_ID",
      "name": "set text"
    },
    {
      "parameters": {},
      "type": "n8n-nodes-base.merge",
      "typeVersion": 3.2,
      "position": [1648, 208],
      "id": "REDACTED_NODE_ID",
      "name": "standardize"
    },
    {
      "parameters": {
        "updates": ["message"],
        "additionalFields": {}
      },
      "type": "n8n-nodes-base.telegramTrigger",
      "typeVersion": 1.2,
      "position": [528, 208],
      "id": "REDACTED_NODE_ID",
      "name": "message",
      "credentials": {
        "telegramApi": {
          "id": "REDACTED",
          "name": "Telegram bot account"
        }
      }
    },
    {
      "parameters": {
        "assignments": {
          "assignments": [
            { "name": "msg", "value": "={{ $json.msg }}", "type": "string" },
            {
              "name": "memoryKey",
              "value": "={{ $('message').item.json.message.from.id }} - {{ $('message').item.json.message.from.username }}",
              "type": "string"
            }
          ]
        },
        "options": {}
      },
      "type": "n8n-nodes-base.set",
      "typeVersion": 3.4,
      "position": [1872, 208],
      "id": "REDACTED_NODE_ID",
      "name": "input"
    },
    {
      "parameters": {
        "promptType": "define",
        "text": "={{ $json.msg }}",
        "options": {
          "systemMessage": "=You are my orchestrator.\nYour job is to interpret my message, decide which specialist tool to use, and coordinate execution.\n\nRules:\n- Use Finance Agent for finance.\n- Use Calendar Agent for calendar.\n- Use Message Agent ONLY when I explicitly want to message someone else.\n- Keep outputs structured and short.\n\nMessage: {{ $json.msg }}\nNow: {{ $now }}\n"
        }
      },
      "type": "@n8n/n8n-nodes-langchain.agent",
      "typeVersion": 2.2,
      "position": [2192, 208],
      "id": "REDACTED_NODE_ID",
      "name": "orchestrator"
    },
    {
      "parameters": {
        "chatId": "={{ $('message').item.json.message.chat.id }}",
        "text": "={{ $json.output }}",
        "additionalFields": {}
      },
      "type": "n8n-nodes-base.telegram",
      "typeVersion": 1.2,
      "position": [2880, 208],
      "id": "REDACTED_NODE_ID",
      "name": "reply",
      "credentials": {
        "telegramApi": {
          "id": "REDACTED",
          "name": "Telegram bot account"
        }
      }
    },
    {
      "parameters": {
        "model": "perplexity/sonar",
        "options": {}
      },
      "type": "@n8n/n8n-nodes-langchain.lmChatOpenRouter",
      "typeVersion": 1,
      "position": [2752, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "perplexity",
      "credentials": {
        "openRouterApi": {
          "id": "REDACTED",
          "name": "OpenRouter account"
        }
      }
    },
    {
      "parameters": {
        "url": "https://www.google.com",
        "options": {}
      },
      "type": "n8n-nodes-base.httpRequestTool",
      "typeVersion": 4.3,
      "position": [3008, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "search"
    },
    {
      "parameters": {
        "text": "={{ $fromAI('Prompt__User_Message_', ``, 'string') }}",
        "options": {
          "systemMessage": "=Search agent. Use web tools to find reliable information and summarize."
        }
      },
      "type": "@n8n/n8n-nodes-langchain.agentTool",
      "typeVersion": 2.2,
      "position": [2864, 880],
      "id": "REDACTED_NODE_ID",
      "name": "Search Agent"
    },
    {
      "parameters": {
        "descriptionType": "manual",
        "toolDescription": "Postgres table with personal financial records. Use quoted identifiers for columns with spaces/accents.",
        "operation": "executeQuery",
        "query": "{{ $fromAI('sql_query') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.postgresTool",
      "typeVersion": 2.6,
      "position": [2624, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "financial entries",
      "credentials": {
        "postgres": {
          "id": "REDACTED",
          "name": "Postgres account"
        }
      }
    },
    {
      "parameters": {},
      "type": "@n8n/n8n-nodes-langchain.toolCalculator",
      "typeVersion": 1,
      "position": [2496, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "calculator"
    },
    {
      "parameters": {
        "toolDescription": "Use this tool to send a WhatsApp message via HTTP.",
        "method": "POST",
        "url": "REDACTED_WHATSAPP_ENDPOINT",
        "sendHeaders": true,
        "headerParameters": {
          "parameters": [
            { "name": "Content-Type", "value": "application/json" },
            { "name": "apikey", "value": "REDACTED" }
          ]
        },
        "sendBody": true,
        "bodyParameters": {
          "parameters": [
            { "name": "number", "value": "={{ $fromAI('parameters0_Value', `phone in E164`, 'string') }}" },
            { "name": "text", "value": "={{ $fromAI('parameters1_Value', `message text`, 'string') }}" }
          ]
        },
        "options": {}
      },
      "type": "n8n-nodes-base.httpRequestTool",
      "typeVersion": 4.3,
      "position": [1984, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "whatsapp"
    },
    {
      "parameters": {
        "operation": "delete",
        "calendar": {
          "__rl": true,
          "value": "REDACTED_CALENDAR_ID",
          "mode": "list"
        },
        "eventId": "={{ $fromAI('Event_ID', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [1600, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "delete",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "REDACTED",
          "name": "Google Calendar account"
        }
      }
    },
    {
      "parameters": {
        "operation": "getAll",
        "calendar": {
          "__rl": true,
          "value": "REDACTED_CALENDAR_ID",
          "mode": "list"
        },
        "returnAll": "={{ $fromAI('Return_All', ``, 'boolean') }}",
        "timeMin": "={{ $fromAI('After', ``, 'string') }}",
        "timeMax": "={{ $fromAI('Before', ``, 'string') }}",
        "options": {}
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [1472, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "get",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "REDACTED",
          "name": "Google Calendar account"
        }
      }
    },
    {
      "parameters": {
        "calendar": {
          "__rl": true,
          "value": "REDACTED_CALENDAR_ID",
          "mode": "list"
        },
        "start": "={{ $fromAI('Start', ``, 'string') }}",
        "end": "={{ $fromAI('End', ``, 'string') }}",
        "additionalFields": {
          "description": "={{ $fromAI('Description', ``, 'string') }}",
          "summary": "={{ $fromAI('Summary', ``, 'string') }}"
        }
      },
      "type": "n8n-nodes-base.googleCalendarTool",
      "typeVersion": 1.3,
      "position": [1344, 1088],
      "id": "REDACTED_NODE_ID",
      "name": "create",
      "credentials": {
        "googleCalendarOAuth2Api": {
          "id": "REDACTED",
          "name": "Google Calendar account"
        }
      }
    }
  ],
  "pinData": {},
  "connections": {
    "message": { "main": [[{ "node": "switch", "type": "main", "index": 0 }]] },
    "switch": {
      "main": [
        [{ "node": "set text", "type": "main", "index": 0 }],
        [{ "node": "get audio", "type": "main", "index": 0 }]
      ]
    },
    "get audio": { "main": [[{ "node": "transcribe", "type": "main", "index": 0 }]] },
    "transcribe": { "main": [[{ "node": "set audio", "type": "main", "index": 0 }]] },
    "set text": { "main": [[{ "node": "standardize", "type": "main", "index": 0 }]] },
    "set audio": { "main": [[{ "node": "standardize", "type": "main", "index": 1 }]] },
    "standardize": { "main": [[{ "node": "input", "type": "main", "index": 0 }]] },
    "input": { "main": [[{ "node": "orchestrator", "type": "main", "index": 0 }]] },
    "orchestrator": { "main": [[{ "node": "reply", "type": "main", "index": 0 }]] },

    "Calendar Agent": { "ai_tool": [[{ "node": "orchestrator", "type": "ai_tool", "index": 0 }]] },
    "Message Agent": { "ai_tool": [[{ "node": "orchestrator", "type": "ai_tool", "index": 0 }]] },
    "Finance Agent": { "ai_tool": [[{ "node": "orchestrator", "type": "ai_tool", "index": 0 }]] },
    "Search Agent": { "ai_tool": [[{ "node": "orchestrator", "type": "ai_tool", "index": 0 }]] },

    "memory": { "ai_memory": [[{ "node": "orchestrator", "type": "ai_memory", "index": 0 }]] },
    "model": { "ai_languageModel": [[{ "node": "orchestrator", "type": "ai_languageModel", "index": 0 }]] },

    "Contacts": { "ai_tool": [[{ "node": "Message Agent", "type": "ai_tool", "index": 0 }]] },
    "whatsapp": { "ai_tool": [[{ "node": "Message Agent", "type": "ai_tool", "index": 0 }]] },

    "get": { "ai_tool": [[{ "node": "Calendar Agent", "type": "ai_tool", "index": 0 }]] },
    "create": { "ai_tool": [[{ "node": "Calendar Agent", "type": "ai_tool", "index": 0 }]] },
    "delete": { "ai_tool": [[{ "node": "Calendar Agent", "type": "ai_tool", "index": 0 }]] },

    "financial entries": { "ai_tool": [[{ "node": "Finance Agent", "type": "ai_tool", "index": 0 }]] },
    "calculator": { "ai_tool": [[{ "node": "Finance Agent", "type": "ai_tool", "index": 0 }]] },

    "perplexity": { "ai_languageModel": [[{ "node": "Search Agent", "type": "ai_languageModel", "index": 0 }]] },
    "search": { "ai_tool": [[{ "node": "Search Agent", "type": "ai_tool", "index": 0 }]] }
  },
  "active": false,
  "settings": {
    "executionOrder": "v1",
    "callerPolicy": "workflowsFromSameOwner",
    "availableInMCP": false
  },
  "versionId": "REDACTED",
  "meta": {
    "templateCredsSetupCompleted": true,
    "instanceId": "REDACTED"
  },
  "id": "REDACTED_WORKFLOW_ID",
  "tags": []
}
