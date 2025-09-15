#!/usr/bin/env node

import fsPromises from 'fs/promises';

/**
 * Highlevel CLI tool description.
 * 1. parse command line arguments
 * 2. merge config in following order. Futher overwrites. Oreder: defaults, environment variable and arguments
 * 3. read file
 * 4. parse markdown: extract SYSTEM, USER and PREFIX prompts
 * 5. make http call using OpenAI
 * 6. parse response and extract content
 * 7. write output to file
 *
 * RULES:
 * - use node js standart library
 * - use promise versions for http client call, file read and write
 */

// Parse arguments block
interface InstructLlmArgs {
    // required argument. Should be a readable file.
    promptFile: string;
    // optional. If empty output to stdout.
    outputFile: string;
    // default is LLM_API_KEY environment variable
    apiKey: string;
    // default is https://codestral.mistral.ai/v1/chat/completions
    apiUrl: string;
    // default is 0
    temperature: number;
    // default is '
    model: string;
    // default is 1000
    maxTokens: number;
    // default is 42
    seed: number;
}

/**
 * Parse arguments as long name options.
 * Merge with environment variables.
 * Use a default values if none.
 */
function parseArguments(args: Array<string>): InstructLlmArgs {
    const defaults: InstructLlmArgs = {
        promptFile: '',
        outputFile: '',
        apiKey: process.env.LLM_API_KEY || '',
        apiUrl: 'https://codestral.mistral.ai/v1/chat/completions',
        temperature: 0,
        model: 'codestral-latest',
        maxTokens: 1000,
        seed: 42,
    };
    const result: InstructLlmArgs = {...defaults};
    for (let i = 2; i < args.length; i++) {
        const arg = args[i];
        if (arg.startsWith('--')) {
            const key = arg.substring(2);
            const value = args[i + 1];
            if (value && !value.startsWith('--')) {
                result[key] = value;
                i++;
            } else {
                result[key] = true;
            }
        }
    }
    return result;
}

// Prompt build block

interface PromptRawData {
    system: string;
    user: string;
    prefix: string | undefined;
}

/**
Extract prompt from file content.
File has following structure:
```markdown
# SYSTEM
Here a system prompt.
It could be multiline and even contain code.
# USER
This block contains a user prompt.
It could be multiline as well.
# PREFIX
This block is optional.
It could be multiline againg.
```
It should be:
```json
{
    "system": "Here a system prompt.\n It could be multiline and even contain code.",
    "user": "This block contains a user prompt.\n It could be multiline as well.",
    "prefix": "This block is optional.\n It could be multiline againg."
}
```
 */
async function parseFile(filepath: string): Promise<PromptRawData> {
    const result: PromptRawData = {
        system: '',
        user: '',
        prefix: undefined,
    };
    const content = await fsPromises.readFile(filepath, 'utf8');
    const lines = content.split('\n');
    let currentKey: string | undefined = undefined;
    for (const line of lines) {
        if (line.startsWith('# ')) {
            currentKey = line.substring(2).toLowerCase();
        } else if (currentKey) {
            result[currentKey] += line + '\n';
        }
    }
    
    // remove blank spaces for each field
    for (const key in result) {
        if (result[key]) {
            result[key] = result[key].trim();
        }
    }

    return result;
}


// OpenAI api block

interface MessageRequest {
    // system, user or assistent for prefix
    role: string;
    // message content
    content: string;
    // prefix is true ONLY for prefix message, for anything else it's empty
    prefix?: boolean;
}

interface OpenAIRequest {
    model: string;
    temperature: number;
    max_tokens: number;
    // seed and random_seed is mutually exclusive. For mistral use random_seed, for others seed
    seed?: number;
    // copy of seed
    random_seed: number;
    // always false
    stream: boolean;
    // message order: system, user [, prefix]
    messages: Array<MessageRequest>;
}

// Convert data to request
function convertToRequest(args: InstructLlmArgs, prompts: PromptRawData): OpenAIRequest {
    const messages: Array<MessageRequest> = [];
    if (prompts.system) {
        messages.push({
            role: 'system',
            content: prompts.system,
        });
    }
    if (prompts.user) {
        messages.push({
            role: 'user',
            content: prompts.user,
        });
    }
    if (prompts.prefix) {
        messages.push({
            role: 'assistent',
            content: prompts.prefix,
            prefix: true,
        });
    }
    return {
        model: args.model,
        temperature: args.temperature,
        max_tokens: args.maxTokens,
        // seed: args.seed,
        random_seed: args.seed,
        stream: false,
        messages,
    };
}

/*
Make an http call using fetch and return content
 */
async function callLlm(args: InstructLlmArgs, request: OpenAIRequest): Promise<string> {
    const response = await fetch(args.apiUrl, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': `Bearer ${args.apiKey}`,
        },
        body: JSON.stringify(request),
    });
    const data = await response.json();
    // when content is not presented throw an error
    if (!data.choices || !data.choices[0] || !data.choices[0].message || !data.choices[0].message.content) {
        throw new Error('Error: content is not presented in response: ' + JSON.stringify(data));
    }
    return data.choices[0].message.content;
}

/**
 * Print usage with long names, defaults and environment variable names.
 */
function printUsage() {
    console.log('Usage: instruct-llm [--help] --promptFile <file> [--outputFile <file>] [--apiKey <key>] [--apiUrl <url>] [--temperature <number>] [--model <model>] [--maxTokens <number>] [--seed <number>]');
    console.log('Environment variables:');
    console.log('  LLM_API_KEY - default API key');
    console.log('Defaults:');
    console.log('  apiUrl: https://codestral.mistral.ai/v1/chat/completions');
    console.log('  temperature: 0');
    console.log('  model: codestral-latest');
    console.log('  maxTokens: 1000');
    console.log('  seed: 42');
}

// Main use case
async function main(args: Array<string>) {
    // if args contain --help printUsage
    if (args.includes('--help')) {
        printUsage();
        return;
    }
    const parsedArgs = parseArguments(args);
    const filepath = parsedArgs.promptFile;

    // test filepath is presented
    if (!filepath) {
        console.error('Error: promptFile is required');
        printUsage();
        return;
    }
    
    // test file exist and readable using node js file io
    await fsPromises.access(filepath, fsPromises.constants.R_OK);
    const prompt = await parseFile(filepath);

    // test prompt is not empty
    if (!prompt.system && !prompt.user) {
        console.error('Error: prompt is empty');
        return;
    }
    const request = convertToRequest(parsedArgs, prompt);

    // test apiKey is presented
    if (!parsedArgs.apiKey) {
        console.error('Error: apiKey is required');
        printUsage();
        return;
    }
    const response = await callLlm(parsedArgs, request);
    // if outputFile is presented write to file, else print to stdout
    if (parsedArgs.outputFile) {
        await fsPromises.writeFile(parsedArgs.outputFile, response);
    } else {
        console.log(response);
    }
}

// EXECUTION BLOCK
main(process.argv);

