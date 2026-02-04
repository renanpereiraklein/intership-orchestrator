# Intership — Telegram Multi-Agent Orchestrator

A personal operations system built with n8n that routes Telegram messages to specialized AI agents with real tool execution.

## Features
- Text and voice input via Telegram
- Central LLM-based orchestrator
- Redis-backed session memory
- Specialist agents for calendar, finance, messaging, and web search
- Direct API and database integration

## Architecture
Telegram → Orchestrator → Specialist Agents → Tools → Telegram

## Requirements
- n8n (self-hosted)
- Redis
- OpenAI API key
- Telegram Bot Token
- PostgreSQL (for finance module)

## Setup
1. Clone the repository
2. Configure environment variables using `env.example`
3. Import the workflow JSON into n8n
4. Connect credentials
5. Activate the workflow

## Security
All workflows are sanitized. No credentials or private endpoints are included.

## License
MIT
